part of 'auth_bloc.dart';

sealed class AuthEvent {}

class OnRegisterEvent extends AuthEvent {
  final String email;
  final String password;
  OnRegisterEvent({required this.email, required this.password});
}

class OnLoginEvent extends AuthEvent {
  final String email;
  final String password;
  OnLoginEvent({required this.email, required this.password});
}