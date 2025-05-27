part of 'vehicle_list_bloc.dart';

sealed class VehicleListEvent {}

class LoadAllVehiculosEvent extends VehicleListEvent {}

class FilterVehiculosEvent extends VehicleListEvent {
  final String query;
  final FiltroVehiculo? filtro;

  FilterVehiculosEvent({
    required this.query,
    this.filtro,
  });
}

class LoadVehiculosByIdsEvent extends VehicleListEvent {
  final List<String> ids;
  LoadVehiculosByIdsEvent(this.ids);
}
