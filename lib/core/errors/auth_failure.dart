import 'package:car_seek/core/errors/failure.dart';

class AuthFailure extends Failure {
  @override
  String get defaultMessage => 'Error de autenticación. Intenta nuevamente.';

  const AuthFailure({
    super.customMessage,
    super.errorCode = 'authentication_error',
    super.statusCode = 401,
  });
}

class InvalidCredentialsFailure extends AuthFailure {
  @override
  String get defaultMessage => 'Correo o contraseña incorrectos. Verifica tus datos.';

  const InvalidCredentialsFailure({
    super.customMessage,
    super.errorCode = 'invalid_credentials',
    super.statusCode = 400,
  });
}

class UserNotFoundFailure extends AuthFailure {
  @override
  String get defaultMessage => 'Usuario no encontrado. Regístrate primero.';

  const UserNotFoundFailure({
    super.customMessage,
    super.errorCode = 'user_not_found',
    super.statusCode = 404,
  });
}

class EmailAlreadyInUseFailure extends AuthFailure {
  @override
  String get defaultMessage => 'Este correo ya está registrado. ¿Olvidaste tu contraseña?';

  const EmailAlreadyInUseFailure({
    super.customMessage,
    super.errorCode = 'email_in_use',
    super.statusCode = 409,
  });
}

class EmailNotConfirmedFailure extends AuthFailure {
  @override
  String get defaultMessage => 'Correo no confirmado. Entra en tu correo y confirma tu cuenta.';

  const EmailNotConfirmedFailure({
    super.customMessage,
    super.errorCode = 'email_not_confirmed',
    super.statusCode = 400,
  });
}

class WeakPasswordFailure extends AuthFailure {
  @override
  String get defaultMessage => 'Contraseña muy débil. Usa al menos 6 caracteres.';

  const WeakPasswordFailure({
    super.customMessage,
    super.errorCode = 'weak_password',
    super.statusCode = 400,
  });
}

class AccountLockedFailure extends AuthFailure {
  @override
  String get defaultMessage => 'Cuenta bloqueada. Contacta al soporte.';

  const AccountLockedFailure({
    super.customMessage,
    super.errorCode = 'account_locked',
    super.statusCode = 403,
  });
}