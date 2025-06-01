import 'dart:io';

import 'package:http/http.dart';
import 'package:todo/core/network/api_client.dart';
import 'package:todo/core/network/response.dart';
import 'package:todo/core/repository/base_repository.dart';
import 'package:todo/core/storage/shared_pref_service.dart';
import 'package:todo/features/download/domain/download_repository.dart';

class DownloadRepositoryImpl extends BaseRepository implements DownloadRepository {
  DownloadRepositoryImpl(this._apiClient, this._sharedPref);

  final ApiClient _apiClient;
  final SharedPrefService _sharedPref;

  @override
  Future<Result<StreamedResponse>> downloadWithResume(File file) async {
    var headers = <String, String>{};

    int downloadedBytes = 0;
    if (await file.exists()) {
      downloadedBytes = await file.length();
    }

    if (downloadedBytes > 0) {
      // debugPrint('Download resume');
      // headers['Range'] = 'bytes=$downloadedBytes-';
    }

    final url = 'https://www.pexels.com/download/video/854635/';
    final uri = Uri.parse(url);
    final request = Request('GET', uri);
    request.headers.addAll(headers);
    final response = await _apiClient.client.send(request);

    if (response.statusCode == 206 || response.statusCode == 200) {
      return ResultSuccess(response);
    }

    return ResultError('Download failed');
  }

  @override
  Future<Result<String?>> getDownloadPath() async {
    return ResultSuccess(_sharedPref.prefs.getString('download_path'));
  }

  @override
  Future<void> saveDownloadPath(String path) async {
    await _sharedPref.prefs.setString('download_path', path);
  }
}
