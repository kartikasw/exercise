import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:todo/features/user/domain/user_model.dart';
import 'package:todo/features/user/domain/user_repository.dart';

class UserViewModel extends ChangeNotifier {
  UserViewModel(this._repository);

  final UserRepository _repository;

  final _userList = List<UserModel>.empty(growable: true);

  List<UserModel> get userList => _userList;

  var _loading = false;

  bool get loading => _loading;

  String? _error;

  String? get error => _error;

  var _success = false;

  bool get success => _success;

  Future<void> getUserList({bool refresh = true}) async {
    _setState(() {
      _loading = true;
      _error = null;
    });

    final result = await _repository.getUserList();

    result.when(
      onSuccess: (data) => _setState(() {
        _loading = false;

        if (refresh) {
          _userList.clear();
        }

        _userList.addAll(data);
        _error = null;
        _success = true;
      }),
      onError: (e) => _setState(() {
        _loading = false;
        _error = e;
        _success = true;
      }),
    );
  }

  Future<Uint8List?> getImageFromCacheManager(String imageUrl) async {
    if (imageUrl.trim().isEmpty) return null;

    try {
      final fileInfo = await DefaultCacheManager().getFileFromCache(imageUrl);
      Uint8List? image;
      if (fileInfo != null && fileInfo.file.existsSync()) {
        image = await fileInfo.file.readAsBytes();
      } else {
        final response = await _repository.downloadAvatar(imageUrl);
        response.when(
          onSuccess: (data) {
            image = data;
          },
        );
      }
      return image;
    } catch (e) {
      return null;
    }
  }

  void clearError() {
    _setState(
      () => _error = null,
    );
  }

  void _setState(VoidCallback fn) {
    fn();
    notifyListeners();
  }
}
