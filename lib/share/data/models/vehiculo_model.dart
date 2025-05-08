import 'package:car_seek/share/domain/entities/vehiculo.dart';
import 'package:car_seek/share/domain/enums/tipo_combustible.dart';
import 'package:car_seek/share/domain/enums/tipo_etiqueta.dart';

class VehiculoModel extends Vehiculo {
  VehiculoModel({
    required super.idVehiculo,
    required super.idUsuario,
    required super.titulo,
    required super.marca,
    required super.modelo,
    required super.anio,
    required super.kilometros,
    required super.tipoCombustible,
    required super.cv,
    required super.tipoEtiqueta,
    required super.precio,
    super.ubicacion,
    super.descripcion,
    required super.imagenes,
    super.destacado,
    super.verificado,
    super.fechaCreacion,
    super.fechaActualizacion,
  });

  factory VehiculoModel.fromJson(Map<String, dynamic> json) {
    return VehiculoModel(
      idVehiculo: json['id_vehiculo'],
      idUsuario: json['id_usuario'],
      titulo: json['titulo'],
      marca: json['marca'],
      modelo: json['modelo'],
      anio: json['anio'],
      kilometros: json['kilometros'],
      tipoCombustible: TipoCombustible.values.firstWhere(
            (e) => e.name == json['tipo_combustible'],
        orElse: () => TipoCombustible.gasolina,
      ),
      cv: json['cv'],
      tipoEtiqueta: TipoEtiqueta.values.firstWhere(
            (e) => e.name == json['tipo_etiqueta'],
        orElse: () => TipoEtiqueta.c,
      ),
      precio: json['precio'].toDouble(),
      ubicacion: json['ubicacion'],
      descripcion: json['descripcion'],
      imagenes: List<String>.from(json['imagenes'] ?? []),
      destacado: json['destacado'] ?? false,
      verificado: json['verificado'] ?? false,
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      fechaActualizacion: DateTime.parse(json['fecha_actualizacion']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_vehiculo': idVehiculo,
      'id_usuario': idUsuario,
      'titulo' : titulo,
      'marca': marca,
      'modelo': modelo,
      'anio': anio,
      'kilometros': kilometros,
      'tipo_combustible': tipoCombustible.name,
      'cv': cv,
      'tipo_etiqueta': tipoEtiqueta.name,
      'precio': precio,
      'ubicacion': ubicacion ?? '',
      'descripcion': descripcion ?? '',
      'imagenes': imagenes ?? '',
      'destacado': destacado ?? false,
      'verificado': verificado ?? false,
    };
  }

  factory VehiculoModel.fromEntity(Vehiculo vehiculo) {
    return VehiculoModel(
      idVehiculo: vehiculo.idVehiculo,
      idUsuario: vehiculo.idUsuario,
      titulo: vehiculo.titulo,
      marca: vehiculo.marca,
      modelo: vehiculo.modelo,
      anio: vehiculo.anio,
      kilometros: vehiculo.kilometros,
      tipoCombustible: vehiculo.tipoCombustible,
      cv: vehiculo.cv,
      tipoEtiqueta: vehiculo.tipoEtiqueta,
      precio: vehiculo.precio,
      ubicacion: vehiculo.ubicacion,
      descripcion: vehiculo.descripcion,
      imagenes: vehiculo.imagenes,
      destacado: vehiculo.destacado,
      verificado: vehiculo.verificado,
      fechaCreacion: vehiculo.fechaCreacion,
      fechaActualizacion: vehiculo.fechaActualizacion,
    );
  }
}
