part of 'auth_bloc.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {
  final String? savedEmail;
  final String? savedPassword;
  final bool hasSavedCredentials;

  AuthInitial({
    this.savedEmail,
    this.savedPassword,
    this.hasSavedCredentials = false,
  });

  @override
  List<Object?> get props => [savedEmail, savedPassword, hasSavedCredentials];
}

class Credentials {
  final String email;
  final String password;

  const Credentials({required this.email, required this.password});
}

final class AuthRegister extends AuthState {}

final class AuthLoading extends AuthState {}

class AuthForgotPassword extends AuthState {}

final class AuthLoginSuccess extends AuthState {
  final Usuario user;

  AuthLoginSuccess({required this.user});
}

final class AuthRegisterSuccess extends AuthState {}

final class AuthError extends AuthState {
  final Failure failure;

  AuthError({required this.failure});
}

final class AuthForgotPasswordSuccess extends AuthState {
  final String message;

  AuthForgotPasswordSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

final class AuthPasswordResetSuccess extends AuthState {}
