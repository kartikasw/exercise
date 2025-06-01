import 'dart:async';
import 'dart:convert';

import 'package:todo/core/network/api_client.dart';
import 'package:todo/core/network/response.dart';
import 'package:todo/core/repository/base_repository.dart';
import 'package:todo/core/storage/shared_pref_service.dart';
import 'package:todo/features/auth/domain/auth_repository.dart';

class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  AuthRepositoryImpl(this._apiClient, this._sharedPref);

  final ApiClient _apiClient;
  final SharedPrefService _sharedPref;

  @override
  Future<Result<String?>> register(String email, String password) async {
    return sendRequest(
      url: 'https://reqres.in/api/register',
      action: (url) => _apiClient.client.post(
        url,
        headers: {'x-api-key': 'reqres-free-v1'},
        body: {'email': email, 'password': password},
      ),
      onSuccess: (response) async {
        final jsonBody = json.decode(response.body);

        if (jsonBody is Map<String, dynamic>) {
          final token = jsonBody['token'] as String;
          await _sharedPref.prefs.setString('token', token);
        }

        return ResultSuccess(null);
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
  Future<Result<String?>> login(String email, String password) async {
    return sendRequest(
      url: 'https://reqres.in/api/login',
      action: (url) => _apiClient.client.post(
        url,
        headers: {'x-api-key': 'reqres-free-v1'},
        body: {'email': email, 'password': password},
      ),
      onSuccess: (response) async {
        final jsonBody = json.decode(response.body);

        if (jsonBody is Map<String, dynamic>) {
          final token = jsonBody['token'] as String;
          await _sharedPref.prefs.setString('token', token);
        }

        return ResultSuccess(null);
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
