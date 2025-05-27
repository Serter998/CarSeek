part of 'favorite_vehicles_bloc.dart';

sealed class FavoriteVehiclesEvent {
  const FavoriteVehiclesEvent();
}

class LoadFavoritosConVehiculosEvent extends FavoriteVehiclesEvent {
  final String userId;

  const LoadFavoritosConVehiculosEvent({required this.userId});
}

class ToggleVehiculoFavoritoEvent extends FavoriteVehiclesEvent {
  final Vehiculo vehiculo;

  const ToggleVehiculoFavoritoEvent({required this.vehiculo});
}

class ActualizarFiltroFavoritosEvent extends FavoriteVehiclesEvent {
  final FiltroVehiculo filtro;

  const ActualizarFiltroFavoritosEvent({required this.filtro});
}