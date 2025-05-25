part of 'favorite_vehicles_bloc.dart';

sealed class FavoriteVehiclesEvent {}

class LoadFavoritesEvent extends FavoriteVehiclesEvent {}

class ToggleFavoriteEvent extends FavoriteVehiclesEvent {
  final Vehiculo vehiculo;
  ToggleFavoriteEvent(this.vehiculo);
}

class CheckFavoriteStatusEvent extends FavoriteVehiclesEvent {
  final Vehiculo vehiculo;
  CheckFavoriteStatusEvent(this.vehiculo);
}
