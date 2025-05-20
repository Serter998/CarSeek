import 'package:dartz/dartz.dart';
import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/share/domain/entities/vehiculo.dart';

abstract class FavoriteVehicleRepository {
  Future<Either<Failure, void>> toggleFavorite(Vehiculo vehiculo);
  Future<Either<Failure, List<Vehiculo>>> getFavorites();
  Future<Either<Failure, bool>> isFavorite(String vehiculoId);
}
