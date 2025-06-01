import 'package:flutter/material.dart';
import 'package:todo/features/auth/domain/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this._repository);

  final AuthRepository _repository;

  var _passwordVisible = false;

  bool get passwordVisible => _passwordVisible;

  var _loading = false;

  bool get loading => _loading;

  String? _error;

  String? get error => _error;

  var _success = false;

  bool get success => _success;

  Future<void> login(String email, String password) async {
    _setState(() {
      _loading = true;
      _error = null;
    });

    final result = await _repository.login(email, password);

    result.when(
      onSuccess: (_) => _setState(() {
        _loading = false;
        _success = true;
      }),
      onError: (e) => _setState(() {
        _loading = false;
        _error = e;
        _success = false;
      }),
    );
  }

  Future<void> register(String email, String password) async {
    _setState(() {
      _loading = true;
      _error = null;
    });

    final result = await _repository.register(email, password);

    result.when(
      onSuccess: (_) => _setState(() {
        _loading = false;
        _success = true;
      }),
      onError: (e) => _setState(() {
        _loading = false;
        _error = e;
        _success = false;
      }),
    );
  }

  void updatePasswordVisibility() {
    _setState(() {
      _passwordVisible = !_passwordVisible;
    });
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
