part of 'auth_bloc.dart';

sealed class AuthEvent {}

class OnRegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String nombre;
  final String? telefono;
  final String? ubicacion;

  OnRegisterEvent({
    required this.email,
    required this.password,
    required this.nombre,
    this.telefono,
    this.ubicacion,
  });
}

class OnLoginEvent extends AuthEvent {
  final String email;
  final String password;

  OnLoginEvent({required this.email, required this.password});
}

class OnForgotPasswordEvent extends AuthEvent {
  final String email;

  OnForgotPasswordEvent({required this.email});
}

class OnCheckUserLoginEvent extends AuthEvent {}

class OnCloseSessionEvent extends AuthEvent {}

class OnNavigateToRegisterEvent extends AuthEvent {}

class OnNavigateToLoginEvent extends AuthEvent {}

class OnNavigateToForgotPasswordEvent extends AuthEvent {}
