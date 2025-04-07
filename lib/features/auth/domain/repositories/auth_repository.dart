import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/share/domain/entities/usuario.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, Usuario>> register(
    String email,
    String password,
    String nombre,
    String? telefono,
    String? ubicacion,
  );

  Future<Either<Failure, Usuario>> login(String email, String password, bool rememberMe);

  Future<Either<Failure, void>> cerrarSesion();

  Future<Either<Failure, Usuario?>> getCurrentUser();

  Future<Either<Failure, Map<String, String?>>> loadCredentials();
}
