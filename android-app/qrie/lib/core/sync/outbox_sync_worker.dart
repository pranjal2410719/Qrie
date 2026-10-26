import 'dart:async';
import 'dart:convert';
import 'dart:math';
import '../network/api_client.dart';
import '../network/rfc7807_error.dart';
import '../storage/local_database.dart';

/// Worker responsible for synchronizing offline outbox interaction events with the backend.
class OutboxSyncWorker {
  final LocalDatabaseService localDb;
  final ApiClient apiClient;
  bool _isSyncing = false;
  Timer? _periodicTimer;

  OutboxSyncWorker({
    required this.localDb,
    required this.apiClient,
  });

  void startPeriodicSync({Duration interval = const Duration(seconds: 30)}) {
    _periodicTimer?.cancel();
    _periodicTimer = Timer.periodic(interval, (_) => flush());
  }

  void stopPeriodicSync() {
    _periodicTimer?.cancel();
    _periodicTimer = null;
  }

  /// Flushes pending events to backend `POST /api/v1/sync/events` in batches of 20
  Future<int> flush() async {
    if (_isSyncing) return 0;
    _isSyncing = true;

    int totalSynced = 0;

    try {
      final token = await apiClient.secureStorage.getAccessToken();
      if (token == null || token.isEmpty) {
        _isSyncing = false;
        return 0; // Not authenticated yet, hold queue
      }

      final pending = await localDb.getPendingEvents(limit: 20);
      if (pending.isEmpty) {
        _isSyncing = false;
        return 0;
      }

      final eventsPayload = pending.map((e) {
        final payload = jsonDecode(e['payload_json'] as String) as Map<String, dynamic>;
        return {
          'id': e['id'],
          'event_type': e['event_type'],
          'session_id': payload['session_id'],
          'item_id': payload['item_id'] ?? payload['question_id'],
          'concept_ids': payload['concept_ids'],
          'correctness': payload['is_correct'],
          'payload': payload,
          'created_at': e['created_at'],
        };
      }).toList();

      try {
        final response = await apiClient.post(
          '/sync/events',
          data: {'events': eventsPayload},
        );

        if (response is Map<String, dynamic>) {
          final syncedIds = (response['synced_ids'] as List<dynamic>?)?.map((e) => e.toString()).toList();
          if (syncedIds != null && syncedIds.isNotEmpty) {
            await localDb.markEventsSynced(syncedIds);
            totalSynced = syncedIds.length;
          }
        }
      } on ProblemDetails catch (e) {
        if (e.status == 401) {
          // Token expired, halt syncing until re-authenticated
          _isSyncing = false;
          return 0;
        }

        // On transient failure, increment retry counts
        for (final row in pending) {
          await localDb.incrementEventRetry(row['id'] as String);
        }
      } catch (_) {
        for (final row in pending) {
          await localDb.incrementEventRetry(row['id'] as String);
        }
      }
    } finally {
      _isSyncing = false;
    }

    return totalSynced;
  }

  /// Calculates backoff with jitter
  static Duration calculateBackoff(int retryCount) {
    final baseSeconds = min(60, pow(2, retryCount).toInt());
    final jitter = Random().nextInt(1000); // 0 to 1000 ms jitter
    return Duration(seconds: baseSeconds) + Duration(milliseconds: jitter);
  }
}
