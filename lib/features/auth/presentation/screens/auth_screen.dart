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

      authBloc.add(OnLoadCredentialsEvent());

      await Future.delayed(const Duration(milliseconds: 200));

      final state = authBloc.state;
      if (state is AuthInitial && state.hasSavedCredentials) {
        authBloc.add(OnCheckUserLoginEvent());
      }
    });
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
          switch (state.runtimeType) {
            case AuthLoading:
              return const Center(child: CircularProgressIndicator());
            case AuthInitial:
              final savedEmail = (state as AuthInitial).savedEmail;
              final savedPassword = (state as AuthInitial).savedPassword;
              return LoginScreen(
                initialEmail: savedEmail,
                initialPassword: savedPassword,
                rememberMe: (state as AuthInitial).hasSavedCredentials,
              );
            case AuthRegister:
              return RegisterScreen();
            case AuthForgotPassword:
              return ForgotPasswordScreen();
            case AuthForgotPasswordSuccess:
              return LoginScreen();
            case AuthError:
              return AuthErrorScreen(failure: (state as AuthError).failure);
            case AuthLoginSuccess:
              return AuthSuccessScreen();
            case AuthRegisterSuccess:
              return LoginScreen();
            case AuthPasswordResetSuccess:
              return AuthSuccessScreen();
            default:
              return const Center(child: Text("Estado no contemplado"));
          }
        },
      ),
    );
  }
}
