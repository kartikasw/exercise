import 'dart:async';

sealed class Result<T> {
  FutureOr<void> when({
    FutureOr<void> Function(T)? onSuccess,
    FutureOr<void> Function(String)? onError,
  }) {
    switch (this) {
      case ResultSuccess<T>(:final data):
        return onSuccess?.call(data);
      case ResultError<T>(:final error):
        return onError?.call(error);
    }
  }
}

class ResultSuccess<T> extends Result<T> {
  ResultSuccess(this.data);

  final T data;
}

class ResultError<T> extends Result<T> {
  ResultError(this.error);

  final String error;
}
