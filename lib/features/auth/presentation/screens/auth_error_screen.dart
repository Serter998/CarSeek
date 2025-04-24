import 'package:car_seek/core/errors/auth_failure.dart';
import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/core/errors/server_failure.dart';
import 'package:car_seek/core/themes/text_styles.dart';
import 'package:car_seek/features/auth/presentation/widgets/redirect_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/validation_failures.dart';
import '../blocs/auth_bloc.dart';

class AuthErrorScreen extends StatelessWidget {
  final Failure failure;

  const AuthErrorScreen({super.key, required this.failure});

  IconData _getErrorIcon() {
    switch (failure) {
      case EmailAlreadyInUseFailure _:
        return Icons.email;
      case WeakPasswordFailure _:
        return Icons.lock_outline;
      case InvalidEmailFailure _:
        return Icons.mark_email_unread;
      case InvalidCredentialsFailure _:
        return Icons.login;
      case UserNotFoundFailure _:
        return Icons.person_off;
      case AccountLockedFailure _:
        return Icons.lock_clock;
      case EmailNotConfirmedFailure _:
        return Icons.mark_email_unread;
      case NetworkFailure _:
        return Icons.wifi_off;
      case TimeoutFailure _:
        return Icons.timer_off;
      case DatabaseFailure _:
        return Icons.storage;
      case ServerFailure _:
        return Icons.cloud_off;
      default:
        return Icons.error_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 18.0),
              child: Icon(_getErrorIcon(), color: Colors.red, size: 100),
            ),
            Text(failure.defaultMessage, style: TextStyles.errorText),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: RedirectTextButton(
                function: () {
                  context.read<AuthBloc>().add(OnLoadCredentialsEvent());
                },
                text: "Volver al inicio",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
