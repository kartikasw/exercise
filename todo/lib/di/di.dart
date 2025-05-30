import 'package:get_it/get_it.dart';
import 'package:todo/feature/data/local/db_helper.dart';
import 'package:todo/feature/data/remote/http_client.dart';
import 'package:injectable/injectable.dart';
import 'package:todo/di/di.config.dart';

final locator = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() => locator.init();

@module
abstract class RegisterModule {
  @lazySingleton
  CustomHttpClient get customHttpClient => CustomHttpClient();

  @preResolve
  Future<DbHelper> get dbHelper => DbHelper.create();
}
