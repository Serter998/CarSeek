import 'package:car_seek/core/errors/auth_failure.dart';
import 'package:car_seek/core/errors/failure.dart';

class ValidationFailure extends Failure {
  @override
  String get defaultMessage => 'Datos de entrada no válidos';

  const ValidationFailure({
    super.customMessage,
    super.errorCode,
    super.statusCode = 400,
  });
}

class InvalidEmailFailure extends ValidationFailure {
  @override
  String get defaultMessage => 'Formato de correo electrónico inválido';

  const InvalidEmailFailure({
    super.customMessage,
    super.errorCode = 'invalid_email',
    super.statusCode = 400,
  });
}

class DatabaseFailure extends Failure {
  @override
  String get defaultMessage => 'Error en la base de datos';

  const DatabaseFailure({
    super.customMessage,
    super.errorCode,
    super.statusCode = 500,
  });
}