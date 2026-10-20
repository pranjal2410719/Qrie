import 'package:dio/dio.dart';

/// RFC 7807 Problem Details for HTTP APIs
class ProblemDetails implements Exception {
  final String? type;
  final String title;
  final int status;
  final String detail;
  final String? instance;
  final Map<String, dynamic> extensions;

  ProblemDetails({
    this.type,
    required this.title,
    required this.status,
    required this.detail,
    this.instance,
    this.extensions = const {},
  });

  factory ProblemDetails.fromJson(Map<String, dynamic> json, {int? defaultStatus}) {
    final status = json['status'] is int ? json['status'] as int : (defaultStatus ?? 500);
    final title = json['title'] as String? ?? 'An error occurred';
    final detail = json['detail'] as String? ?? json['message'] as String? ?? 'Please try again in a moment.';
    final type = json['type'] as String?;
    final instance = json['instance'] as String?;

    final ext = Map<String, dynamic>.from(json)
      ..remove('type')
      ..remove('title')
      ..remove('status')
      ..remove('detail')
      ..remove('instance');

    return ProblemDetails(
      type: type,
      title: title,
      status: status,
      detail: detail,
      instance: instance,
      extensions: ext,
    );
  }

  factory ProblemDetails.fromDioException(DioException exception) {
    if (exception.response?.data is Map<String, dynamic>) {
      return ProblemDetails.fromJson(
        exception.response!.data as Map<String, dynamic>,
        defaultStatus: exception.response?.statusCode,
      );
    }

    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ProblemDetails(
          title: 'Connection Timed Out',
          status: 408,
          detail: 'Your internet connection seems slow. Checking your saved offline content.',
        );
      case DioExceptionType.connectionError:
        return ProblemDetails(
          title: 'No Internet Connection',
          status: 0,
          detail: 'You are currently offline. Your practice sessions will sync when you reconnect.',
        );
      case DioExceptionType.badResponse:
        final code = exception.response?.statusCode ?? 500;
        return ProblemDetails(
          title: code == 401 ? 'Session Expired' : 'Server Issue',
          status: code,
          detail: code == 401
              ? 'Please log in again to continue your session.'
              : 'Our servers encountered an issue ($code). Please try again.',
        );
      case DioExceptionType.cancel:
        return ProblemDetails(
          title: 'Request Cancelled',
          status: 499,
          detail: 'The request was cancelled.',
        );
      default:
        return ProblemDetails(
          title: 'Network Error',
          status: 500,
          detail: 'Unable to reach the server. Please check your network.',
        );
    }
  }

  @override
  String toString() => 'ProblemDetails(status: $status, title: "$title", detail: "$detail")';
}
