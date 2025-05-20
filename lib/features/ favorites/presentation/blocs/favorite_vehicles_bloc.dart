import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/share/domain/entities/vehiculo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_seek/features/%20favorites/domain/use_cases/get_favorites_usecase.dart';
import 'package:car_seek/features/%20favorites/domain/use_cases/is_favorite_usecase.dart';
import 'package:car_seek/features/%20favorites/domain/use_cases/toggle_favorite_usecase.dart';


part 'favorite_vehicles_event.dart';
part 'favorite_vehicles_state.dart';

class FavoriteVehiclesBloc extends Bloc<FavoriteVehiclesEvent, FavoriteVehiclesState> {
  final ToggleFavoriteUseCase toggleFavoriteUseCase;
  final GetFavoritesUseCase getFavoritesUseCase;
  final IsFavoriteUseCase isFavoriteUseCase;

  FavoriteVehiclesBloc({
    required this.toggleFavoriteUseCase,
    required this.getFavoritesUseCase,
    required this.isFavoriteUseCase,
  }) : super(FavoriteVehiclesInitial()) {
    on<LoadFavoritesEvent>((event, emit) async {
      emit(FavoriteVehiclesLoading());
      final result = await getFavoritesUseCase();
      result.fold(
            (failure) => emit(FavoriteVehiclesError(failure)),
            (favorites) => emit(FavoriteVehiclesLoaded(favorites)),
      );
    });

    on<ToggleFavoriteEvent>((event, emit) async {
      await toggleFavoriteUseCase(event.vehiculo);
      add(LoadFavoritesEvent());
    });

    on<CheckFavoriteStatusEvent>((event, emit) async {
      final result = await isFavoriteUseCase(event.vehiculo.idVehiculo);
      result.fold(
            (failure) => emit(FavoriteVehiclesError(failure)),
            (isFav) => emit(FavoriteStatusLoaded(event.vehiculo.idVehiculo, isFav)),
      );
    });
  }
}

