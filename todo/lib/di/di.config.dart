// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:todo/di/di.dart' as _i1006;
import 'package:todo/feature/bloc/todo_bloc.dart' as _i369;
import 'package:todo/feature/data/local/db_helper.dart' as _i843;
import 'package:todo/feature/data/remote/http_client.dart' as _i552;
import 'package:todo/feature/data/repository.dart' as _i932;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i843.DbHelper>(
      () => registerModule.dbHelper,
      preResolve: true,
    );
    gh.lazySingleton<_i552.CustomHttpClient>(
        () => registerModule.customHttpClient);
    gh.lazySingleton<_i932.Repository>(() => _i932.Repository(
          gh<_i552.CustomHttpClient>(),
          gh<_i843.DbHelper>(),
        ));
    gh.factory<_i369.ToDoBloc>(() => _i369.ToDoBloc(gh<_i932.Repository>()));
    return this;
  }
}

class _$RegisterModule extends _i1006.RegisterModule {}
