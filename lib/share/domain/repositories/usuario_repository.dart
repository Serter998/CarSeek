import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/share/domain/entities/usuario.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class UsuarioRepository {
  Future<Either<Failure,Usuario>> getUserById(String id);
  Future<Either<Failure,List<Usuario>>> getAllUsers();
  Future<Either<Failure, void>> updateUser(Usuario usuario);
  Future<Either<Failure, void>> deleteUser(String id);
  Future<Either<Failure, void>> deleteOtherUser(String id);
  Future<Either<Failure,void>> cerrarSesion();
  Future<Either<Failure,User>> getCurrentUser();
  Future<Either<Failure,Usuario>> getCurrentUsuario();
}