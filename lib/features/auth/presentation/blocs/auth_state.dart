part of 'auth_bloc.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}
final class AuthRegister extends AuthState {}
final class AuthLoading extends AuthState {}
final class AuthSuccess extends AuthState {
  final Usuario user;
  AuthSuccess({required this.user});
}
final class AuthError extends AuthState {
  final Failure failure;
  AuthError({required this.failure});
}