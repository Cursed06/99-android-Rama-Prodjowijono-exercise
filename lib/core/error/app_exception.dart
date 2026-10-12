/// Base domain exception for all expected failures across the application.
///
/// Sealed hierarchy so consumers (e.g. ViewModels) can exhaustively handle
/// known error categories and map them to appropriate UI messages.
sealed class AppException implements Exception {
  /// User-friendly or debug message describing the failure.
  final String message;

  /// Underlying cause or stack trace, if available.
  final Object? cause;

  const AppException(this.message, [this.cause]);

  @override
  String toString() => '$runtimeType: $message${cause != null ? ' (Cause: $cause)' : ''}';
}

/// Thrown when a network request fails due to connectivity, timeout, or server HTTP error.
final class NetworkException extends AppException {
  const NetworkException(super.message, [super.cause]);
}

/// Thrown when the incoming JSON payload cannot be parsed into expected models.
final class ParseException extends AppException {
  const ParseException(super.message, [super.cause]);
}

/// Thrown when a requested resource is not found (e.g. Firebase 200 with null body).
final class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Listing not found', super.cause]);
}
