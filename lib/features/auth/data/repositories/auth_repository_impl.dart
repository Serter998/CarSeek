import 'package:car_seek/core/errors/failures.dart';
import 'package:car_seek/features/auth/data/models/user_model.dart';
import 'package:car_seek/features/auth/data/sources/auth_source.dart';
import 'package:car_seek/features/auth/domain/entities/user.dart';
import 'package:car_seek/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthSource authSource;

  AuthRepositoryImpl({required this.authSource});

  @override
  Future<Either<Failure, User>> register(String email, String password) async {
    try{
      UserModel userModel = await authSource.register(email, password);
      final User resp = User(id: userModel.id, email: userModel.email);
      return Right(resp);
    } on ServerFailure {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try{
      UserModel userModel = await authSource.login(email, password);
      final User resp = User(id: userModel.id, email: userModel.email);
      return Right(resp);
    } on ServerFailure {
      return Left(ServerFailure());
    }
  }
}
