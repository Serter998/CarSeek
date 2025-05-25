part of 'profile_bloc.dart';

sealed class ProfileEvent {}

class OnLoadInitialProfileEvent extends ProfileEvent {}

class OnCerrarSesionEvent extends ProfileEvent {}

class OnUpdateUsuarioEvent extends ProfileEvent {
  final Usuario usuario;

  OnUpdateUsuarioEvent({required this.usuario});
}

class OnDeleteUsuarioEvent extends ProfileEvent {}

class OnDeleteVehiculoEvent extends ProfileEvent {
  final Vehiculo vehiculo;

  OnDeleteVehiculoEvent({required this.vehiculo});
}

class OnEnterEditVehicleEvent extends ProfileEvent {}

class OnEditVehicleEvent extends ProfileEvent {
  final Vehiculo vehiculo;

  OnEditVehicleEvent({required this.vehiculo});
}

class OnEditVerificacionEvent extends ProfileEvent {
  final Vehiculo vehiculo;

  OnEditVerificacionEvent({required this.vehiculo});
}

class OnEditUsuarioEvent extends ProfileEvent {
  final Usuario usuario;

  OnEditUsuarioEvent({required this.usuario});
}

class OnNavigateToInitial extends ProfileEvent {}

class OnNavigateToUpdate extends ProfileEvent {}

class OnNavigateToUpdateVehicles extends ProfileEvent {}

class OnNavigateToUpdateVehicle extends ProfileEvent {
  final Vehiculo vehiculo;

  OnNavigateToUpdateVehicle({required this.vehiculo});
}

class OnNavigateToAdministracion extends ProfileEvent {}

class OnNavigateToAdministracionVerificaciones extends ProfileEvent {}

class OnNavigateToAdministracionUsuarios extends ProfileEvent {}
