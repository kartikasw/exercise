import 'package:flutter/material.dart';
import 'package:todo/core/di/di.dart';
import 'package:todo/features/auth/presentation/auth_viewmodel.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({required this.authPage, super.key});

  final AuthPage authPage;

  @override
  State<StatefulWidget> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late final TextEditingController _emailCtrl;
  late final TextEditingController _passwordCtrl;
  late final AuthViewModel _authViewModel;

  @override
  void initState() {
    _authViewModel = locator<AuthViewModel>();
    _emailCtrl = TextEditingController();
    _passwordCtrl = TextEditingController();
    _authViewModel.addListener(_onAuthViewModelChanged);
    super.initState();
  }

  @override
  void dispose() {
    _authViewModel.removeListener(_onAuthViewModelChanged);
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _onAuthViewModelChanged() {
    final error = _authViewModel.error;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      _authViewModel.clearError();
      return;
    }

    final success = _authViewModel.success;
    if (success) {
      Navigator.pushNamedAndRemoveUntil(context, '/user', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.authPage.title),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 16,
            children: [
              _TextField(
                controller: _emailCtrl,
                labelText: 'Email',
              ),
              ListenableBuilder(
                listenable: _authViewModel,
                builder: (context, child) => _TextField(
                  controller: _passwordCtrl,
                  labelText: 'Password',
                  obscureText: !_authViewModel.passwordVisible,
                  suffixIcon: InkWell(
                    onTap: () => _authViewModel.updatePasswordVisibility(),
                    child: Icon(
                      _authViewModel.passwordVisible ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _onAuthProcess,
                child: ListenableBuilder(
                    listenable: _authViewModel,
                    builder: (context, child) {
                      if (_authViewModel.loading) {
                        return CircularProgressIndicator();
                      }

                      return Text(widget.authPage.title);
                    }),
              ),
              TextButton(
                onPressed: onNavigation,
                child: Text(_getNavigationText()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getNavigationText() {
    return switch (widget.authPage) {
      AuthPage.register => AuthPage.login.title,
      AuthPage.login => AuthPage.register.title,
    };
  }

  void onNavigation() {
    switch (widget.authPage) {
      case AuthPage.login:
        Navigator.pushNamedAndRemoveUntil(context, '/register', (route) => false);
      case AuthPage.register:
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  void _onAuthProcess() {
    switch (widget.authPage) {
      case AuthPage.login:
        _authViewModel.login(_emailCtrl.text, _passwordCtrl.text);
      case AuthPage.register:
        _authViewModel.register(_emailCtrl.text, _passwordCtrl.text);
    }
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.controller,
    this.obscureText = false,
    this.labelText,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final bool obscureText;
  final String? labelText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

enum AuthPage {
  login('Login'),
  register('Register');

  const AuthPage(this._title);

  final String _title;

  String get title => _title;
}
