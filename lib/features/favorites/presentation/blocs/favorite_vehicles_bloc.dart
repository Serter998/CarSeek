import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/core/errors/generic_failure.dart';
import 'package:car_seek/features/favorites/domain/entities/favorito.dart';
import 'package:car_seek/features/favorites/domain/use_cases/create_favorite_usecase.dart';
import 'package:car_seek/features/favorites/domain/use_cases/delete_favorito_usecase.dart';
import 'package:car_seek/features/favorites/domain/use_cases/get_favoritos_by_user_id_usecase.dart';
import 'package:car_seek/share/domain/entities/vehiculo.dart';
import 'package:car_seek/share/domain/enums/filtro_vehiculo.dart';
import 'package:car_seek/share/domain/use_cases/vehicles/get_vehiculos_by_ids_usecase.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'favorite_vehicles_event.dart';
part 'favorite_vehicles_state.dart';

class FavoriteVehiclesBloc extends Bloc<FavoriteVehiclesEvent, FavoriteVehiclesState> {
  final GetFavoritosByUserIdUseCase getFavoritosByUserIdUseCase;
  final CreateFavoritoUseCase createFavoritoUseCase;
  final DeleteFavoritoUseCase deleteFavoritoUseCase;
  final GetVehiculosByIdsUseCase getVehiculosByIdsUseCase;
  final String userId;

  FavoriteVehiclesBloc({
    required this.getFavoritosByUserIdUseCase,
    required this.createFavoritoUseCase,
    required this.deleteFavoritoUseCase,
    required this.getVehiculosByIdsUseCase,
    required this.userId,
  }) : super(FavoriteInitial()) {
    on<LoadFavoritosConVehiculosEvent>(_onLoadFavoritosConVehiculos);
    on<ToggleVehiculoFavoritoEvent>(_onToggleFavorite);
  }

  Future<void> _onLoadFavoritosConVehiculos(
      LoadFavoritosConVehiculosEvent event,
      Emitter<FavoriteVehiclesState> emit,
      ) async {
    emit(FavoriteLoading());

    final resultFavoritos = await getFavoritosByUserIdUseCase(userId);

    await resultFavoritos.fold(
          (failure) async => emit(FavoriteError(failure: failure)),
          (favoritos) async {
        final idsVehiculos = favoritos.map((f) => f.idVehiculo).toList();
        if (idsVehiculos.isEmpty) {
          return emit(FavoriteVehiclesLoaded(
            vehiculosFavoritos: [],
            favoritos: favoritos,
          ));
        }

        final resultVehiculos = await getVehiculosByIdsUseCase(idsVehiculos);
        resultVehiculos.fold(
              (failure) => emit(FavoriteError(failure: failure)),
              (vehiculos) => emit(FavoriteVehiclesLoaded(
            vehiculosFavoritos: vehiculos,
            favoritos: favoritos,
          )),
        );
      },
    );
  }

  Future<void> _onToggleFavorite(
      ToggleVehiculoFavoritoEvent event,
      Emitter<FavoriteVehiclesState> emit,
      ) async {
    final currentState = state;
    if (currentState is! FavoriteVehiclesLoaded) return;

    emit(FavoriteLoading());

    final currentFavoritos = await _getFavoritos();
    final existing = currentFavoritos.firstWhereOrNull(
          (f) => f.idVehiculo == event.vehiculo.idVehiculo,
    );

    String message;

    if (existing != null) {
      final deleteResult = await deleteFavoritoUseCase(existing.idFavorito);
      if (deleteResult.isLeft()) {
        emit(FavoriteError(failure: deleteResult.swap().getOrElse(() => GenericFailure())));
        return;
      }
      message = 'Vehículo eliminado de favoritos';
    } else {
      final nuevoFavorito = Favorito(
        idFavorito: '',
        idUsuario: userId,
        idVehiculo: event.vehiculo.idVehiculo,
        createdAt: DateTime.now(),
      );
      final createResult = await createFavoritoUseCase(nuevoFavorito);
      if (createResult.isLeft()) {
        emit(FavoriteError(failure: createResult.swap().getOrElse(() => GenericFailure())));
        return;
      }
      message = 'Vehículo agregado a favoritos';
    }

    final updatedFavoritos = await _getFavoritos();
    final idsVehiculos = updatedFavoritos.map((f) => f.idVehiculo).toList();

    if (idsVehiculos.isEmpty) {
      emit(FavoriteVehiclesLoaded(
        vehiculosFavoritos: [],
        favoritos: updatedFavoritos,
        message: message,
      ));
      return;
    }

    final resultVehiculos = await getVehiculosByIdsUseCase(idsVehiculos);
    resultVehiculos.fold(
          (failure) => emit(FavoriteError(failure: failure)),
          (vehiculos) => emit(FavoriteVehiclesLoaded(
        vehiculosFavoritos: vehiculos,
        favoritos: updatedFavoritos,
        message: message,
      )),
    );
  }

  Future<List<Favorito>> _getFavoritos() async {
    final result = await getFavoritosByUserIdUseCase(userId);
    return result.getOrElse(() => []);
  }
}