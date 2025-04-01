import 'package:car_seek/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:car_seek/features/auth/data/sources/auth_source.dart';
import 'package:car_seek/features/auth/domain/repositories/auth_repository.dart';
import 'package:car_seek/features/auth/domain/use_cases/login_usecase.dart';
import 'package:car_seek/features/auth/domain/use_cases/register_usecase.dart';
import 'package:car_seek/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

final di = GetIt.instance;

Future<void> init() async {
  // Cargar variables de entorno antes de registrar dependencias
  await dotenv.load(fileName: ".env");

  /*-------------
  *Inicio de Auth
  * -------------*/
  //Bloc
  di.registerFactory(() => AuthBloc(di(), di()));

  //Use cases
  di.registerLazySingleton(() => LoginUseCase(repository: di()));
  di.registerLazySingleton(() => RegisterUseCase(repository: di()));

  //Repositories
  di.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      authSource: di(),
    ),
  );

  //Sources
  di.registerLazySingleton<AuthSource>(
        () => AuthSourceImpl(dotenv.env['API_KEY'] ?? ''),
  );
}
