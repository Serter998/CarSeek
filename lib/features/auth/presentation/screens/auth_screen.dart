import 'package:car_seek/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:car_seek/features/auth/presentation/screens/auth_error_screen.dart';
import 'package:car_seek/features/auth/presentation/screens/auth_success_screen.dart';
import 'package:car_seek/features/auth/presentation/screens/login_screen.dart';
import 'package:car_seek/features/auth/presentation/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthRegister) {
              return const Text("Registro");
            } else {
              return const Text("Inicio de sesión");
            }
          },
        ),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          switch (state) {
            case AuthLoading():
              return const Center(child: CircularProgressIndicator(),);
            case AuthInitial():
              return LoginScreen();
            case AuthRegister():
              return RegisterScreen();
            case AuthError():
              return AuthErrorScreen();
            case AuthSuccess():
              return AuthSuccessScreen();
          }
        },
      ),
    );
  }
}
