part of 'favorite_vehicles_bloc.dart';

sealed class FavoriteVehiclesState {}

class FavoriteVehiclesInitial extends FavoriteVehiclesState {}

class FavoriteVehiclesLoading extends FavoriteVehiclesState {}

class FavoriteVehiclesLoaded extends FavoriteVehiclesState {
  final List<Vehiculo> favoritos;
  FavoriteVehiclesLoaded(this.favoritos);
}

class FavoriteStatusLoaded extends FavoriteVehiclesState {
  final String vehiculoId;
  final bool isFavorite;
  FavoriteStatusLoaded(this.vehiculoId, this.isFavorite);
}

class FavoriteVehiclesError extends FavoriteVehiclesState {
  final Failure failure;
  FavoriteVehiclesError(this.failure);
}
