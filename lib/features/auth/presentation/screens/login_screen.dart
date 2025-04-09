import 'package:car_seek/core/themes/dividers_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_seek/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:car_seek/features/auth/presentation/widgets/action_button.dart';
import 'package:car_seek/features/auth/presentation/widgets/custom_snack_bar.dart';
import 'package:car_seek/features/auth/presentation/widgets/redirect_text_button.dart';
import 'package:car_seek/features/auth/presentation/widgets/text_fields.dart';
import 'package:car_seek/features/auth/presentation/widgets/remember_checkbox.dart';


class LoginScreen extends StatefulWidget {
  final String? initialEmail;
  final String? initialPassword;
  final bool rememberMe;

  const LoginScreen({
    super.key,
    this.initialEmail,
    this.initialPassword,
    this.rememberMe = false,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late bool rememberMe;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.initialEmail);
    passwordController = TextEditingController(text: widget.initialPassword);
    rememberMe = widget.rememberMe;
  }

  // Manejo del login
  Future<void> _handleLogin(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      context.read<AuthBloc>().add(OnLoginEvent(email: email, password: password, rememberMe: rememberMe));
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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InputText(
              placeholder: "Introduzca su correo*",
              icon: Icon(Icons.mail),
              controller: emailController,
              toolTip: null,
              isPassword: false,
              longitudMax: 100,
            ),
            InputText(
              placeholder: "Introduzca su contraseña*",
              icon: Icon(Icons.lock),
              controller: passwordController,
              toolTip: null,
              isPassword: true,
              longitudMax: 80,
            ),
            RedirectTextButton(
              function: () {
                context.read<AuthBloc>().add(OnNavigateToForgotPasswordEvent());
              },
              text: "¿Has olvidado tu contraseña?",
            ),
            RememberMeCheckbox(
              value: rememberMe,
              onChanged: (value) {
                setState(() {
                  rememberMe = value!;
                });
              },
            ),
            const SizedBox(height: 10),
            ActionButton(
              function: () => _handleLogin(context),
              text: "Iniciar sesión",
            ),
            DividersStyles.dividerGray,
            RedirectTextButton(
              function: () {
                context.read<AuthBloc>().add(OnNavigateToRegisterEvent());
              },
              text: "¿Aún no estás registrado?",
            ),
          ],
        ),
      ),
    );
  }
}
