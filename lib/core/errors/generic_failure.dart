import 'package:car_seek/core/errors/failure.dart';

class GenericFailure extends Failure {
  @override
  String get defaultMessage => 'Error desconocido';

  const GenericFailure({
    super.customMessage,
    super.errorCode = 'generic_error',
    super.statusCode = 500,
  });
}
