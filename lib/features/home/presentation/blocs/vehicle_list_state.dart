part of 'vehicle_list_bloc.dart';

sealed class VehicleListState {}

class VehicleListInitial extends VehicleListState {}

class VehicleListLoading extends VehicleListState {}

class VehicleListLoaded extends VehicleListState {
  final List<Vehiculo> vehiculos;

  VehicleListLoaded({required this.vehiculos});
}

class VehicleListError extends VehicleListState {
  final Failure failure;

  VehicleListError({required this.failure});
}
