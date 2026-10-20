import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

/// Local Database Service using SQLite
/// Manages durable outbox interaction events, cached curriculum, lessons, and resumable sessions.
class LocalDatabaseService {
  static const _dbName = 'qrie_student.db';
  static const _dbVersion = 1;
  static const _uuid = Uuid();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE outbox_events (
            id TEXT PRIMARY KEY,
            event_type TEXT NOT NULL,
            payload_json TEXT NOT NULL,
            created_at TEXT NOT NULL,
            retry_count INTEGER DEFAULT 0,
            status TEXT DEFAULT 'pending'
          )
        ''');

        await db.execute('''
          CREATE TABLE cached_curriculum (
            grade TEXT NOT NULL,
            board TEXT NOT NULL,
            subject_id TEXT NOT NULL,
            payload_json TEXT NOT NULL,
            updated_at TEXT NOT NULL,
            PRIMARY KEY (grade, board, subject_id)
          )
        ''');

        await db.execute('''
          CREATE TABLE cached_lessons (
            lesson_id TEXT PRIMARY KEY,
            payload_json TEXT NOT NULL,
            updated_at TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE resumable_sessions (
            session_id TEXT PRIMARY KEY,
            topic_id TEXT NOT NULL,
            state_json TEXT NOT NULL,
            updated_at TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // --- Outbox Management ---

  /// Queue an interaction event with client-minted UUID idempotency
  Future<String> enqueueEvent({
    required String eventType,
    required Map<String, dynamic> payload,
  }) async {
    final db = await database;
    final eventId = _uuid.v4();
    final now = DateTime.now().toUtc().toIso8601String();

    await db.insert(
      'outbox_events',
      {
        'id': eventId,
        'event_type': eventType,
        'payload_json': jsonEncode(payload),
        'created_at': now,
        'retry_count': 0,
        'status': 'pending',
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

    return eventId;
  }

  /// Get pending outbox events up to a batch limit (chronological order)
  Future<List<Map<String, dynamic>>> getPendingEvents({int limit = 20}) async {
    final db = await database;
    return await db.query(
      'outbox_events',
      where: 'status = ?',
      whereArgs: ['pending'],
      orderBy: 'created_at ASC',
      limit: limit,
    );
  }

  /// Mark events as successfully synchronized (delete them from outbox)
  Future<void> markEventsSynced(List<String> eventIds) async {
    if (eventIds.isEmpty) return;
    final db = await database;
    final placeholders = List.filled(eventIds.length, '?').join(',');
    await db.delete(
      'outbox_events',
      where: 'id IN ($placeholders)',
      whereArgs: eventIds,
    );
  }

  /// Increment retry count on failure
  Future<void> incrementEventRetry(String eventId) async {
    final db = await database;
    await db.rawUpdate(
      'UPDATE outbox_events SET retry_count = retry_count + 1 WHERE id = ?',
      [eventId],
    );
  }

  /// Get count of pending outbox events
  Future<int> getPendingEventCount() async {
    final db = await database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery("SELECT COUNT(*) FROM outbox_events WHERE status = 'pending'"),
    );
    return count ?? 0;
  }

  // --- Curriculum & Lesson Cache ---

  Future<void> cacheCurriculum({
    required String grade,
    required String board,
    required String subjectId,
    required Map<String, dynamic> data,
  }) async {
    final db = await database;
    await db.insert(
      'cached_curriculum',
      {
        'grade': grade,
        'board': board,
        'subject_id': subjectId,
        'payload_json': jsonEncode(data),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getCachedCurriculum({
    required String grade,
    required String board,
    required String subjectId,
  }) async {
    final db = await database;
    final results = await db.query(
      'cached_curriculum',
      where: 'grade = ? AND board = ? AND subject_id = ?',
      whereArgs: [grade, board, subjectId],
    );
    if (results.isEmpty) return null;
    return jsonDecode(results.first['payload_json'] as String) as Map<String, dynamic>;
  }

  Future<void> cacheLesson({
    required String lessonId,
    required Map<String, dynamic> data,
  }) async {
    final db = await database;
    await db.insert(
      'cached_lessons',
      {
        'lesson_id': lessonId,
        'payload_json': jsonEncode(data),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getCachedLesson(String lessonId) async {
    final db = await database;
    final results = await db.query(
      'cached_lessons',
      where: 'lesson_id = ?',
      whereArgs: [lessonId],
    );
    if (results.isEmpty) return null;
    return jsonDecode(results.first['payload_json'] as String) as Map<String, dynamic>;
  }

  // --- Resumable Session Cache ---

  Future<void> saveResumableSession({
    required String sessionId,
    required String topicId,
    required Map<String, dynamic> state,
  }) async {
    final db = await database;
    await db.insert(
      'resumable_sessions',
      {
        'session_id': sessionId,
        'topic_id': topicId,
        'state_json': jsonEncode(state),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getResumableSession(String sessionId) async {
    final db = await database;
    final results = await db.query(
      'resumable_sessions',
      where: 'session_id = ?',
      whereArgs: [sessionId],
    );
    if (results.isEmpty) return null;
    return jsonDecode(results.first['state_json'] as String) as Map<String, dynamic>;
  }

  Future<void> clearResumableSession(String sessionId) async {
    final db = await database;
    await db.delete('resumable_sessions', where: 'session_id = ?', whereArgs: [sessionId]);
  }
}
