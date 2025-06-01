import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:todo/core/network/api_client.dart';
import 'package:todo/core/network/response.dart';
import 'package:todo/core/repository/base_repository.dart';
import 'package:todo/features/user/domain/user_model.dart';
import 'package:todo/features/user/domain/user_repository.dart';

class UserRepositoryImpl extends BaseRepository implements UserRepository {
  UserRepositoryImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<Result<List<UserModel>>> getUserList({int page = 1}) async {
    return sendRequest(
      url: 'https://reqres.in/api/users?page=$page',
      action: (url) => _apiClient.client.get(
        url,
        headers: {'x-api-key': 'reqres-free-v1'},
      ),
      onSuccess: (response) async {
        await DefaultCacheManager().emptyCache();

        final jsonBody = json.decode(response.body);

        if (jsonBody is Map<String, Object?>) {
          final data = jsonBody['data'] as List<dynamic>;
          final list = data.map((e) => UserModel.fromJson(e as Map<String, dynamic>)).toList();
          return ResultSuccess(list);
        }
        return ResultSuccess([]);
      },
      onError: (response) {
        final jsonBody = json.decode(response.body);

        String error = '';
        if (jsonBody is Map<String, Object?>) {
          error = jsonBody['error'] as String;
        }
        return ResultError(error);
      },
    );
  }

  @override
  Future<Result<Uint8List>> downloadAvatar(String url) async {
    return sendRequest(
      url: url,
      action: (url) => _apiClient.client.get(url),
      onSuccess: (response) async {
        final ext = url.split('.').last;
        await DefaultCacheManager().putFile(url, response.bodyBytes, fileExtension: ext);

        return ResultSuccess(response.bodyBytes);
      },
      onError: (response) {
        final jsonBody = json.decode(response.body);

        String error = '';
        if (jsonBody is Map<String, Object?>) {
          error = jsonBody['error'] as String;
        }
        return ResultError(error);
      },
    );
  }
}
