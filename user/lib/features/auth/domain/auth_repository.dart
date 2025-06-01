import 'package:todo/core/network/response.dart';

abstract class AuthRepository {
  Future<Result<String?>> register(String email, String password);

  Future<Result<String?>> login(String email, String password);
}
