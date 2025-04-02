import 'package:car_seek/core/errors/failures.dart';
import 'package:car_seek/share/domain/entities/usuario.dart';
import 'package:dartz/dartz.dart';

abstract class UsuarioRepository {
  Future<Either<Failure,Usuario>> getUserById(String id);
  Future<Either<Failure,List<Usuario>>> getAllUsers();
  Future<Either<Failure, void>> createUser(Usuario usuario);
  Future<Either<Failure, void>> updateUser(Usuario usuario);
  Future<Either<Failure, void>> deleteUser(String id);
}