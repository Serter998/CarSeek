import 'package:car_seek/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:car_seek/features/auth/presentation/screens/auth_error_screen.dart';
import 'package:car_seek/features/auth/presentation/screens/auth_success_screen.dart';
import 'package:car_seek/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:car_seek/features/auth/presentation/screens/login_screen.dart';
import 'package:car_seek/features/auth/presentation/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authBloc = context.read<AuthBloc>();

      // Primero carga las credenciales
      authBloc.add(OnLoadCredentialsEvent());

      // Espera un pequeño delay para que se cargue antes de verificar el usuario
      await Future.delayed(const Duration(milliseconds: 200));

      // Luego verifica si el usuario está logueado
      authBloc.add(OnCheckUserLoginEvent());
    });
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthRegister) {
              return const Text("Registro");
            } else if (state is AuthInitial) {
              return const Text("Inicio de sesión");
            } else if (state is AuthLoginSuccess) {
              return const Text("Acceso exitoso");
            } else if (state is AuthRegisterSuccess) {
              return const Text(
                "Registro Exitoso, Confirme su cuenta e inicie sesión",
              );
            } else if (state is AuthForgotPassword) {
              return const Text("Recuperar Contraseña");
            } else if (state is AuthError) {
              return const Text("");
            } else if (state is AuthLoading) {
              return const Text("Cargando");
            } else {
              return const Text("Estado no contemplado");
            }
          },
        ),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          switch (state) {
            case AuthLoading():
              return const Center(child: CircularProgressIndicator());
            case AuthInitial(:final savedEmail, :final savedPassword):
              return LoginScreen(
                initialEmail: savedEmail,
                initialPassword: savedPassword,
                rememberMe: savedEmail != null,
              );
            case AuthRegister():
              return RegisterScreen();
            case AuthForgotPassword():
              return ForgotPasswordScreen();
            case AuthError():
              return AuthErrorScreen(failure: state.failure);
            case AuthLoginSuccess():
              return AuthSuccessScreen();
            case AuthRegisterSuccess():
              return LoginScreen();
          }
        },
      ),
    );
  }
}
