import 'package:car_seek/features/auth/domain/use_cases/load_credentials_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_seek/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:car_seek/features/auth/presentation/widgets/action_button.dart';
import 'package:car_seek/features/auth/presentation/widgets/custom_snack_bar.dart';
import 'package:car_seek/features/auth/presentation/widgets/redirect_text_button.dart';
import 'package:car_seek/features/auth/presentation/widgets/text_fields.dart';
import 'package:car_seek/features/auth/presentation/widgets/password_input_text.dart';
import 'package:car_seek/features/auth/presentation/widgets/remember_checkbox.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadRememberedData();
  }

  Future<void> _loadRememberedData() async {
    final credentials = await LoadCredentialsUsecase(repository: null);
    final rememberedEmail = credentials['email'];
    final rememberedPassword = credentials['password'];

    if (rememberedEmail != null && rememberedPassword != null) {
      emailController.text = rememberedEmail;
      passwordController.text = rememberedPassword;
      setState(() {
        rememberMe = true;
      });
    }
  }

  // Manejo del login
  Future<void> _handleLogin(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      if (rememberMe) {
        await OnSaveCredentialsEvent(email: email, password: password);
      } else {
        await OnDeleteCredentialsEvent();
      }

      context.read<AuthBloc>().add(OnLoginEvent(email: email, password: password));
    } else {
      CustomSnackBar.showWarning(
        context: context,
        message: "Por favor, ingrese su correo y contraseña",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InputText(
            placeholder: "Introduzca su correo*",
            controller: emailController,
          ),
          PasswordInputText(
            placeholder: "Introduzca su contraseña*",
            controller: passwordController,
          ),
          RememberMeCheckbox(
            value: rememberMe,
            onChanged: (value) {
              setState(() {
                rememberMe = value!;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RedirectTextButton(
                function: () {
                  context.read<AuthBloc>().add(OnNavigateToForgotPasswordEvent());
                },
                text: "¿Has olvidado tu contraseña?",
              ),
              RedirectTextButton(
                function: () {
                  context.read<AuthBloc>().add(OnNavigateToRegisterEvent());
                },
                text: "¿Aún no estás registrado?",
              ),
            ],
          ),
          const SizedBox(height: 10),
          ActionButton(
            function: () => _handleLogin(context),
            text: "Iniciar sesión",
          ),
        ],
      ),
    );
  }
}
