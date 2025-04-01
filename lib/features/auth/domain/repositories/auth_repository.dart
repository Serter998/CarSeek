import 'package:car_seek/core/errors/failures.dart';
import 'package:car_seek/features/auth/domain/entities/user.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> register(String email, String password);
  Future<Either<Failure, User>> login(String email, String password);
}
