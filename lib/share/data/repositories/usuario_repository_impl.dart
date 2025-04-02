import 'package:car_seek/core/errors/failures.dart';
import 'package:car_seek/share/data/source/usuario_source.dart';
import 'package:car_seek/share/domain/entities/usuario.dart';
import 'package:car_seek/share/domain/repositories/usuario_repository.dart';
import 'package:dartz/dartz.dart';

class UsuarioRepositoryImpl implements UsuarioRepository {
  final UsuarioSource userSource;

  UsuarioRepositoryImpl({required this.userSource});

  @override
  Future<Either<Failure, void>> createUser(Usuario usuario) {
    // TODO: implement createUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deleteUser(String id) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Usuario>>> getAllUsers() {
    // TODO: implement getAllUsers
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Usuario>> getUserById(String id) {
    // TODO: implement getUserById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> updateUser(Usuario usuario) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }

}