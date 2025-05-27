part of 'favorite_vehicles_bloc.dart';

sealed class FavoriteVehiclesState {
  final String? message;

  const FavoriteVehiclesState({this.message});
}

class FavoriteInitial extends FavoriteVehiclesState {
  const FavoriteInitial();
}

class FavoriteLoading extends FavoriteVehiclesState {
  const FavoriteLoading();
}

class FavoriteVehiclesLoaded extends FavoriteVehiclesState {
  final List<Vehiculo> vehiculosFavoritos;
  final List<Favorito> favoritos;


  const FavoriteVehiclesLoaded({
    required this.vehiculosFavoritos,
    required this.favoritos,
    String? message,
  }) : super(message: message);
}

class FavoriteError extends FavoriteVehiclesState {
  final Failure failure;

  FavoriteError({
    required this.failure,
  }) : super(message: failure.message);
}


