import 'package:dartz/dartz.dart';
import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/core/errors/generic_failure.dart';
import 'package:car_seek/features/%20favorites/domain/repositories/favorite_vehicle_repository.dart';
import 'package:car_seek/share/domain/entities/vehiculo.dart';

class FavoriteVehicleRepositoryImpl implements FavoriteVehicleRepository {
  final Map<String, Vehiculo> _favorites = {};

  @override
  Future<Either<Failure, void>> toggleFavorite(Vehiculo vehiculo) async {
    try {
      if (_favorites.containsKey(vehiculo.idVehiculo)) {
        _favorites.remove(vehiculo.idVehiculo);
      } else {
        _favorites[vehiculo.idVehiculo!] = vehiculo;
      }
      return const Right(null);
    } catch (e) {
      return Left(GenericFailure(customMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Vehiculo>>> getFavorites() async {
    try {
      final favoritos = _favorites.values.toList();
      return Right(favoritos);
    } catch (e) {
      return Left(GenericFailure(customMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(String vehiculoId) async {
    try {
      final isFav = _favorites.containsKey(vehiculoId);
      return Right(isFav);
    } catch (e) {
      return Left(GenericFailure(customMessage: e.toString()));
    }
  }
}
