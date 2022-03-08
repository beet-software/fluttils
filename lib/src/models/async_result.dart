import 'package:flutter/material.dart' as f;

abstract class AsyncResultConsumer<R> {
  R onComplete(_CompleteAsyncResult result);

  R onError(_ErrorAsyncResult result);
}

class AsyncResultWidgetBuilder implements AsyncResultConsumer<f.Widget> {
  final f.Widget Function(Object?) _onComplete;
  final f.Widget Function(Object, StackTrace) _onError;

  const AsyncResultWidgetBuilder({
    required f.Widget Function(Object?) onComplete,
    required f.Widget Function(Object, StackTrace) onError,
  })  : _onComplete = onComplete,
        _onError = onError;

  @override
  f.Widget onComplete(_CompleteAsyncResult result) => _onComplete(result.value);

  @override
  f.Widget onError(_ErrorAsyncResult result) =>
      _onError(result.error, result.stackTrace);
}

abstract class AsyncResult {
  const factory AsyncResult.complete({
    required Object? value,
  }) = _CompleteAsyncResult;

  const factory AsyncResult.error({
    required Object error,
    required StackTrace stackTrace,
  }) = _ErrorAsyncResult;

  const AsyncResult();

  R apply<R>(AsyncResultConsumer<R> consumer);
}

class _CompleteAsyncResult extends AsyncResult {
  final Object? value;

  const _CompleteAsyncResult({required this.value});

  @override
  R apply<R>(AsyncResultConsumer<R> consumer) => consumer.onComplete(this);
}

class _ErrorAsyncResult extends AsyncResult {
  final Object error;
  final StackTrace stackTrace;

  const _ErrorAsyncResult({
    required this.error,
    required this.stackTrace,
  });

  @override
  R apply<R>(AsyncResultConsumer<R> consumer) => consumer.onError(this);
}
