import 'dart:typed_data';

import 'package:todo/core/network/response.dart';
import 'package:todo/features/user/domain/user_model.dart';

abstract class UserRepository {
  Future<Result<List<UserModel>>> getUserList();

  Future<Result<Uint8List>> downloadAvatar(String url);
}
