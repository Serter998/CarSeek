import 'package:car_seek/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:car_seek/features/auth/data/sources/auth_source.dart';
import 'package:car_seek/features/auth/domain/repositories/auth_repository.dart';
import 'package:car_seek/features/favorites/data/repositories/favorite_vehicle_repository_impl.dart';
import 'package:car_seek/features/favorites/data/sources/favorito_source.dart';
import 'package:car_seek/features/favorites/domain/repositories/favorite_repository.dart';
import 'package:car_seek/features/favorites/domain/use_cases/create_favorite_usecase.dart';
import 'package:car_seek/features/favorites/domain/use_cases/delete_favorito_usecase.dart';
import 'package:car_seek/features/favorites/domain/use_cases/get_favoritos_by_user_id_usecase.dart';
import 'package:car_seek/features/favorites/presentation/blocs/favorite_vehicles_bloc.dart';
import 'package:car_seek/features/home/presentation/blocs/vehicle_list_bloc.dart';
import 'package:car_seek/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:car_seek/features/sell/presentation/blocs/sell_bloc.dart';
import 'package:car_seek/share/data/repositories/vehiculo_repository_impl.dart';
import 'package:car_seek/share/data/source/vehiculo_source.dart';
import 'package:car_seek/share/domain/repositories/vehiculo_repository.dart';
import 'package:car_seek/share/domain/use_cases/usuario/cerrar_sesion_usecase.dart';
import 'package:car_seek/features/auth/domain/use_cases/forgot_password_usecase.dart';
import 'package:car_seek/share/domain/use_cases/usuario/delete_user_usecase.dart';
import 'package:car_seek/share/domain/use_cases/usuario/get_all_users_usecase.dart';
import 'package:car_seek/share/domain/use_cases/usuario/get_current_user_usecase.dart';
import 'package:car_seek/features/auth/domain/use_cases/load_credentials_usecase.dart';
import 'package:car_seek/features/auth/domain/use_cases/login_usecase.dart';
import 'package:car_seek/features/auth/domain/use_cases/register_usecase.dart';
import 'package:car_seek/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:car_seek/share/data/repositories/usuario_repository_impl.dart';
import 'package:car_seek/share/data/source/usuario_source.dart';
import 'package:car_seek/share/domain/repositories/usuario_repository.dart';
import 'package:car_seek/share/domain/use_cases/usuario/get_current_usuario_usecase.dart';
import 'package:car_seek/share/domain/use_cases/usuario/get_user_by_id_usecase.dart';
import 'package:car_seek/share/domain/use_cases/usuario/update_user_usecase.dart';
import 'package:car_seek/share/domain/use_cases/vehicles/create_vehiculo_usecase.dart';
import 'package:car_seek/share/domain/use_cases/vehicles/delete_vehiculo_usecase.dart';
import 'package:car_seek/share/domain/use_cases/vehicles/get_all_vehiculos_by_current_user.dart';
import 'package:car_seek/share/domain/use_cases/vehicles/get_all_vehiculos_usecase.dart';
import 'package:car_seek/share/domain/use_cases/vehicles/get_vehiculo_by_id_usecase.dart';
import 'package:car_seek/share/domain/use_cases/vehicles/get_vehiculos_by_ids_usecase.dart';
import 'package:car_seek/share/domain/use_cases/vehicles/get_vehiculos_destacados_usecase.dart';
import 'package:car_seek/share/domain/use_cases/vehicles/get_vehiculos_filtrados_usecase.dart';
import 'package:car_seek/share/domain/use_cases/vehicles/search_vehiculos_usecase.dart';
import 'package:car_seek/share/domain/use_cases/vehicles/update_vehiculo_usecase.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final di = GetIt.instance;

Future<void> init() async {
  // Cargar variables de entorno antes de registrar dependencias
  await dotenv.load(fileName: ".env");

  /*-------------*
   * Inicio de Auth
   *-------------*/

  // Registrar SupabaseClient
  di.registerLazySingleton<SupabaseClient>(
        () => SupabaseClient(
      dotenv.env['SUPABASE_URL'] ?? '',
      dotenv.env['SUPABASE_ANON_KEY'] ?? '',
    ),
  );

  // Sources
  di.registerLazySingleton<AuthSource>(
        () => AuthSourceImpl(dotenv.env['API_KEY'] ?? ''),
  );

  // Repositories
  di.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(authSource: di(), userSource: di()),
  );

  // Use cases
  di.registerLazySingleton(() => LoginUseCase(repository: di()));
  di.registerLazySingleton(() => RegisterUseCase(repository: di()));
  di.registerLazySingleton(() => LoadCredentialsUsecase(repository: di()));
  di.registerLazySingleton(() => ForgotPasswordUsecase(repository: di()));

  // Bloc
  di.registerFactory(() => AuthBloc(
    di<RegisterUseCase>(),
    di<LoginUseCase>(),
    di<GetCurrentUsuarioUseCase>(),
    di<CerrarSesionUseCase>(),
    di<LoadCredentialsUsecase>(),
    di<ForgotPasswordUsecase>(),
  ));

  /*-------------*
   * Inicio de User
   *-------------*/

  di.registerLazySingleton<UsuarioSource>(
        () => UsuarioSourceImpl(dotenv.env['API_KEY'] ?? ''),
  );

  di.registerLazySingleton<UsuarioRepository>(
        () => UsuarioRepositoryImpl(userSource: di()),
  );

  di.registerLazySingleton(() => CerrarSesionUseCase(repository: di()));
  di.registerLazySingleton(() => DeleteUserUsecase(repository: di()));
  di.registerLazySingleton(() => GetAllUsersUsecase(repository: di()));
  di.registerLazySingleton(() => GetCurrentUserUseCase(repository: di()));
  di.registerLazySingleton(() => GetCurrentUsuarioUseCase(repository: di()));
  di.registerLazySingleton(() => GetUserByIdUsecase(repository: di()));
  di.registerLazySingleton(() => UpdateUserUsecase(repository: di()));

  /*-------------*
   * Inicio de Vehiculos
   *-------------*/

  di.registerLazySingleton<VehiculoSource>(
        () => VehiculoSourceImpl(dotenv.env['API_KEY'] ?? ''),
  );

  di.registerLazySingleton<VehiculoRepository>(
        () => VehiculoRepositoryImpl(vehiculoSource: di()),
  );

  // Use cases de Vehículos
  di.registerLazySingleton(() => CreateVehiculoUseCase(repository: di()));
  di.registerLazySingleton(() => DeleteVehiculoUseCase(repository: di()));
  di.registerLazySingleton(() => GetAllVehiculosUseCase(repository: di()));
  di.registerLazySingleton(() => GetVehiculoByIdUseCase(repository: di()));
  di.registerLazySingleton(() => GetVehiculosDestacadosUseCase(repository: di()));
  di.registerLazySingleton(() => SearchVehiculosUseCase(repository: di()));
  di.registerLazySingleton(() => UpdateVehiculoUseCase(repository: di()));
  di.registerLazySingleton(() => GetVehiculosFiltradosUseCase(repository: di()));
  di.registerLazySingleton(() => GetAllVehiculosByCurrentUserUseCase(repository: di()));
  di.registerLazySingleton(() => GetVehiculosByIdsUseCase(repository: di()));

  /*-------------*
   * Inicio de Favoritos
   *-------------*/

  di.registerLazySingleton<FavoritoSource>(
        () => FavoritoSourceImpl(dotenv.env['API_KEY'] ?? ''),
  );

  di.registerLazySingleton<FavoriteRepository>(
        () => FavoriteRepositoryImpl(favoritoSource: di()),
  );

  di.registerLazySingleton(() => GetFavoritosByUserIdUseCase(repository: di()));
  di.registerLazySingleton(() => CreateFavoritoUseCase(repository: di()));
  di.registerLazySingleton(() => DeleteFavoritoUseCase(repository: di()));

  di.registerFactoryParam<FavoriteVehiclesBloc, String, void>((userId, _) =>
      FavoriteVehiclesBloc(
        getFavoritosByUserIdUseCase: di(),
        createFavoritoUseCase: di(),
        deleteFavoritoUseCase: di(),
        getVehiculosByIdsUseCase: di(),
        userId: userId,
      ),
  );

  /*-------------*
   * Otros Blocs
   *-------------*/

  di.registerFactory(() => VehicleListBloc(
    di<GetAllVehiculosUseCase>(),
    di<GetVehiculosFiltradosUseCase>(),
    di<GetVehiculosByIdsUseCase>(),
  ));

  di.registerFactory(() => SellBloc(
    di<CreateVehiculoUseCase>(),
  ));

  /*-------------
   * Inicio de Profile
   * -------------*/
  // Bloc
  di.registerFactory(() => ProfileBloc(
    di<CerrarSesionUseCase>(),
    di<DeleteUserUsecase>(),
    di<GetCurrentUserUseCase>(),
    di<GetCurrentUsuarioUseCase>(),
    di<GetUserByIdUsecase>(),
    di<UpdateUserUsecase>(),
    di<GetAllVehiculosByCurrentUserUseCase>(),
    di<UpdateVehiculoUseCase>(),
    di<DeleteVehiculoUseCase>(),
    di<GetAllVehiculosUseCase>(),
    di<GetAllUsersUsecase>(),
  ));
}
