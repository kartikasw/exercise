class UserModel {
  const UserModel({
    this.id = 0,
    this.email = '',
    this.firstName = '',
    this.lastName = '',
    this.avatar = '',
  });

  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'email': String email,
        'first_name': String firstName,
        'last_name': String lastName,
        'avatar': String avatar,
      } =>
        UserModel(
          id: id,
          email: email,
          firstName: firstName,
          lastName: lastName,
          avatar: avatar,
        ),
      _ => throw const FormatException('Failed to load user.'),
    };
  }
}
