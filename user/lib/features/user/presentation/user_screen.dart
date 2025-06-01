import 'package:flutter/material.dart';
import 'package:todo/core/di/di.dart';
import 'package:todo/core/change_notifier_provider.dart';
import 'package:todo/features/user/domain/user_model.dart';
import 'package:todo/features/user/presentation/user_view_model.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<StatefulWidget> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late final UserViewModel _userViewModel;

  @override
  void initState() {
    _userViewModel = locator<UserViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _userViewModel.getUserList();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/download');
            },
            icon: Icon(Icons.file_download),
          ),
        ],
      ),
      body: ChangeNotifierProvider(
        notifier: _userViewModel,
        child: ListenableBuilder(
          listenable: _userViewModel,
          builder: (context, child) {
            if (_userViewModel.userList.isEmpty) {
              return Center(child: Text('Empty'));
            }

            return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _userViewModel.userList.length,
              itemBuilder: (context, index) {
                final user = _userViewModel.userList[index];
                return _UserCard(user);
              },
            );
          },
        ),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard(this.user);

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        spacing: 15,
        children: [
          FutureBuilder(
            future: ChangeNotifierProvider.of<UserViewModel>(context).getImageFromCacheManager(user.avatar),
            builder: (context, snapshot) {
              final image = snapshot.data;
              if (image != null) {
                return ClipOval(
                  child: Image.memory(
                    image,
                    width: _size,
                    height: _size,
                  ),
                );
              }

              return CircleAvatar(
                radius: _size / 2,
                backgroundColor: Colors.grey,
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              );
            },
          ),
          Expanded(
            child: Text('${user.firstName} ${user.lastName}'),
          ),
        ],
      ),
    );
  }

  static const _size = 40.0;
}
