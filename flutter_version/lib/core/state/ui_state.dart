/// Sealed hierarchy representing the visual states of an asynchronous screen or component.
///
/// Ensures exhaustive pattern matching in widgets so loading, success,
/// and error feedback states are all explicitly handled.
sealed class UiState<T> {
  const UiState();
}

/// Loading state indicating an operation is in progress.
final class Loading<T> extends UiState<T> {
  const Loading();
}

/// Success state holding the resolved data payload of type [T].
final class Success<T> extends UiState<T> {
  /// The loaded data payload.
  final T data;

  const Success(this.data);
}

/// Failure state holding an error [message] and optional [cause].
final class Failure<T> extends UiState<T> {
  /// User-friendly error message to display in the UI.
  final String message;

  /// Optional underlying cause or exception.
  final Object? cause;

  const Failure(this.message, [this.cause]);
}
