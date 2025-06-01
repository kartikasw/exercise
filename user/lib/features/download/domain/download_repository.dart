import 'dart:io';

import 'package:http/http.dart';
import 'package:todo/core/network/response.dart';

abstract class DownloadRepository {
  Future<Result<StreamedResponse>> downloadWithResume(File file);

  Future<void> saveDownloadPath(String path);

  Future<Result<String?>> getDownloadPath();
}
