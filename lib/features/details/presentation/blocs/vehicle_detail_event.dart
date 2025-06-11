part of 'vehicle_detail_bloc.dart';

sealed class VehicleDetailEvent {}

class LoadVehicleDetailEvent extends VehicleDetailEvent {
  final Vehiculo vehiculo;
  LoadVehicleDetailEvent({required this.vehiculo});
}

class ToggleFavoriteEvent extends VehicleDetailEvent {
  final Vehiculo vehiculo;
  ToggleFavoriteEvent({required this.vehiculo});
}

class ContactSellerEvent extends VehicleDetailEvent {
  final Vehiculo vehiculo;
  ContactSellerEvent({required this.vehiculo});
}
