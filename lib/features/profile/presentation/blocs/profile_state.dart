part of 'profile_bloc.dart';

sealed class ProfileState {}

final class ProfileInitial extends ProfileState {
  final Usuario usuario;

  ProfileInitial({required this.usuario});
}
final class ProfileUpdate extends ProfileState {
  final Usuario usuario;
  final User user;

  ProfileUpdate({required this.usuario, required this.user});
}
final class ProfileEditVehicles extends ProfileState {
  final List<Vehiculo>? vehiculos;

  ProfileEditVehicles({required this.vehiculos});
}
final class ProfileUpdateVehicle extends ProfileState {
  final Vehiculo vehiculo;

  ProfileUpdateVehicle({required this.vehiculo});
}
final class ProfileLoading extends ProfileState {}
final class ProfileUpdateSuccess extends ProfileState {
  final Usuario usuario;

  ProfileUpdateSuccess({required this.usuario});
}
final class ProfileDeleteSuccess extends ProfileState {}
final class ProfileCerrarSesionSuccess extends ProfileState {}
final class ProfileUpdateVehicleSuccess extends ProfileState {
  final List<Vehiculo>? vehiculos;

  ProfileUpdateVehicleSuccess({required this.vehiculos});
}
final class ProfileError extends ProfileState {
  final Failure failure;
  ProfileError({required this.failure});
}
final class ProfileAdministracion extends ProfileState {
  final Usuario usuario;

  ProfileAdministracion({required this.usuario});
}

final class ProfileAdministracionVerificaciones extends ProfileState {
  final List<Vehiculo>? vehiculos;

  ProfileAdministracionVerificaciones({required this.vehiculos});
}

final class ProfileAdministracionUsuarios extends ProfileState {
  final List<Usuario>? usuarios;

  ProfileAdministracionUsuarios({required this.usuarios});
}