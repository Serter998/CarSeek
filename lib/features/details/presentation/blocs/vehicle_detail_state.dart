part of 'vehicle_detail_bloc.dart';

sealed class VehicleDetailState {}

class VehicleDetailInitial extends VehicleDetailState {}

class VehicleDetailLoading extends VehicleDetailState {}

class VehicleDetailLoaded extends VehicleDetailState {
  final Vehiculo vehiculo;
  final bool isFavorite;

  VehicleDetailLoaded({required this.vehiculo, required this.isFavorite});
}

class VehicleDetailError extends VehicleDetailState {
  final String message;

  VehicleDetailError({required this.message});
}

class VehicleDetailNavigateToChat extends VehicleDetailState {
  final ConversacionModel conversacion;
  VehicleDetailNavigateToChat({required this.conversacion});
}


