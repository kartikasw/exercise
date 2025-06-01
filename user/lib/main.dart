import 'package:flutter/material.dart';
import 'package:todo/core/di/di.dart';
import 'package:todo/features/auth/presentation/auth_screen.dart';
import 'package:todo/features/download/presentation/download_screen.dart';
import 'package:todo/features/user/presentation/user_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (context) => AuthScreen(authPage: AuthPage.login));
          case '/user':
            return MaterialPageRoute(builder: (context) => UserScreen());
          case '/download':
            return MaterialPageRoute(builder: (context) => DownloadScreen());
          default:
            return MaterialPageRoute(builder: (context) => AuthScreen(authPage: AuthPage.register));
        }
      },
      initialRoute: '/register',
    );
  }
}
