import 'package:car_seek/core/services/navigation_service.dart';
import 'package:car_seek/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:car_seek/features/auth/presentation/widgets/redirect_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthSuccessScreen extends StatelessWidget {
  const AuthSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NavigationService.navigateTo(context, "/home");
    });
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Exito"),
            const SizedBox(height: 30),
            RedirectTextButton(
              function:
                  () =>
                  context.read<AuthBloc>().add(OnCheckUserLoginEvent()),
              text: "Volver a login",
            ),
          ],
        ),
      ),
    );
  }
}
