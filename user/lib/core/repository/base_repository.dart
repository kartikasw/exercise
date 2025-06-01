import 'dart:async';
import 'dart:io';
import 'package:http/http.dart';
import 'package:todo/core/network/response.dart';

class BaseRepository {
  FutureOr<Result<T>> sendRequest<T>({
    required String url,
    required FutureOr<Response> Function(Uri url) action,
    required FutureOr<ResultSuccess<T>> Function(Response) onSuccess,
    required FutureOr<ResultError<T>> Function(Response) onError,
    bool? Function(Response)? successCondition,
  }) async {
    try {
      final uri = Uri.parse(url);
      final result = await action(uri);

      if (successCondition?.call(result) ?? result.statusCode == HttpStatus.ok) {
        return onSuccess.call(result);
      }

      return onError.call(result);
    } on TimeoutException catch (e) {
      return ResultError(e.toString());
    } catch (e) {
      return ResultError(e.toString());
    }
  }
}
