import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http_interceptor/http_interceptor.dart';

class LogInterceptor implements InterceptorContract {
  final int maxRetries;
  final Duration delay;

  LogInterceptor({this.maxRetries = 3, this.delay = const Duration(seconds: 2)});

  @override
  FutureOr<BaseRequest> interceptRequest({required BaseRequest request}) {
    debugPrint('----- Request -----');
    debugPrint('To: ${request.url}');
    debugPrint('Method: ${request.method}');
    debugPrint('Header: ${request.headers}');
    return request;
  }

  @override
  FutureOr<BaseResponse> interceptResponse({required BaseResponse response}) {
    debugPrint('----- Response -----');
    debugPrint('Response code: ${response.statusCode}');
    debugPrint('Reason phrase: ${response.reasonPhrase}');

    if (response is Response) {
      debugPrint('Body: ${(response).body}');
    } else if (response is StreamedResponse) {
      debugPrint('Content length: ${response.contentLength}');
      debugPrint('Stream: ${response.stream}');
    }

    return response;
  }

  @override
  FutureOr<bool> shouldInterceptRequest() => true;

  @override
  FutureOr<bool> shouldInterceptResponse() => true;
}
