import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/share/domain/entities/vehiculo.dart';
import 'package:car_seek/share/domain/repositories/vehiculo_repository.dart';
import 'package:dartz/dartz.dart';

class GetVehiculosByIdsUseCase {
  final VehiculoRepository repository;

  GetVehiculosByIdsUseCase({required this.repository});

  Future<Either<Failure, List<Vehiculo>>> call(List<String> ids) async {
    if (ids.isEmpty) return Right([]);
    return await repository.getVehiculosByIds(ids);
  }
}
