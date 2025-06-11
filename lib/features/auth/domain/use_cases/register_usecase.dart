import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/features/auth/domain/repositories/auth_repository.dart';
import 'package:car_seek/share/domain/entities/usuario.dart';
import 'package:dartz/dartz.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase({required this.repository});

  Future<Either<Failure, Usuario>> call(
    String email,
    String password,
    String nombre,
    String? telefono,
    String? ubicacion,
  ) {
    return repository.register(email, password, nombre, telefono, ubicacion);
  }
}
