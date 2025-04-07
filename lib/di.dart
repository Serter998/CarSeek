import 'package:car_seek/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:car_seek/features/auth/data/sources/auth_source.dart';
import 'package:car_seek/features/auth/domain/repositories/auth_repository.dart';
import 'package:car_seek/features/auth/domain/use_cases/cerrar_sesion_usecase.dart';
import 'package:car_seek/features/auth/domain/use_cases/get_current_user_usecase.dart';
import 'package:car_seek/features/auth/domain/use_cases/load_credentials_usecase.dart';
import 'package:car_seek/features/auth/domain/use_cases/login_usecase.dart';
import 'package:car_seek/features/auth/domain/use_cases/register_usecase.dart';
import 'package:car_seek/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:car_seek/share/data/repositories/usuario_repository_impl.dart';
import 'package:car_seek/share/data/source/usuario_source.dart';
import 'package:car_seek/share/domain/repositories/usuario_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

final di = GetIt.instance;

Future<void> init() async {
  // Cargar variables de entorno antes de registrar dependencias
  await dotenv.load(fileName: ".env");

  /*-------------
  *Inicio de User
  * -------------*/
  //Bloc

  //Use cases

  //Repositories
  di.registerLazySingleton<UsuarioRepository>(
        () => UsuarioRepositoryImpl(
      userSource: di(),
    ),
  );

  //Sources
  di.registerLazySingleton<UsuarioSource>(
        () => UsuarioSourceImpl(dotenv.env['API_KEY'] ?? ''),
  );

  /*-------------
  *Inicio de Auth
  * -------------*/
  //Bloc
  di.registerFactory(() => AuthBloc(di(), di(), di(), di(), di()));

  //Use cases
  di.registerLazySingleton(() => LoginUseCase(repository: di()));
  di.registerLazySingleton(() => RegisterUseCase(repository: di()));
  di.registerLazySingleton(() => CerrarSesionUseCase(repository: di()));
  di.registerLazySingleton(() => GetCurrentUserUseCase(repository: di()));
  di.registerLazySingleton(() => LoadCredentialsUsecase(repository: di()));

  //Repositories
  di.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      authSource: di(), userSource: di(),
    ),
  );

  //Sources
  di.registerLazySingleton<AuthSource>(
        () => AuthSourceImpl(dotenv.env['API_KEY'] ?? ''),
  );
}
