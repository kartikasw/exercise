import 'dart:io' show Platform, HttpClient;
import 'package:cupertino_http/cupertino_http.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:cronet_http/cronet_http.dart';

class CustomHttpClient {
  final int timeoutSeconds;
  final int cacheSize;
  final String userAgent;

  CustomHttpClient({
    this.timeoutSeconds = 30,
    this.cacheSize = 1024 * 1024 * 10,
    this.userAgent = '',
  });

  http.Client? _client;

  http.Client get client => _client ??= create();

  http.Client create() {
    try {
      if (Platform.isAndroid) {
        final engine = CronetEngine.build(
          cacheMode: CacheMode.memory,
          cacheMaxSize: cacheSize,
          userAgent: userAgent,
        );
        return _wrapWithTimeout(CronetClient.fromCronetEngine(engine));
      }

      if (Platform.isIOS || Platform.isMacOS) {
        final config = URLSessionConfiguration.ephemeralSessionConfiguration()
          ..cache = URLCache.withCapacity(memoryCapacity: cacheSize)
          ..httpAdditionalHeaders = {'User-Agent': userAgent};
        return _wrapWithTimeout(CupertinoClient.fromSessionConfiguration(config));
      }

      final ioClient = HttpClient()
        ..userAgent = userAgent
        ..idleTimeout = Duration(seconds: timeoutSeconds);
      return _wrapWithTimeout(IOClient(ioClient));
    } catch (e) {
      final fallbackClient = HttpClient()
        ..userAgent = userAgent
        ..idleTimeout = Duration(seconds: timeoutSeconds);
      return _wrapWithTimeout(IOClient(fallbackClient));
    }
  }

  http.Client _wrapWithTimeout(http.Client client) {
    return _TimeoutClient(client, Duration(seconds: timeoutSeconds));
  }
}

class _TimeoutClient extends http.BaseClient {
  final http.Client _inner;
  final Duration _timeout;

  _TimeoutClient(this._inner, this._timeout);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _inner.send(request).timeout(_timeout);
  }

  @override
  void close() {
    _inner.close();
  }
}
