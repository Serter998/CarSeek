import 'package:car_seek/share/domain/enums/tipo_combustible.dart';
import 'package:car_seek/share/domain/enums/tipo_etiqueta.dart';

class Vehiculo {
  final String idVehiculo;
  final String idUsuario;
  final String titulo;
  final String marca;
  final String modelo;
  final int anio;
  final int kilometros;
  final TipoCombustible tipoCombustible;
  final int cv;
  final TipoEtiqueta tipoEtiqueta;
  final double precio;
  final String? ubicacion;
  final String? descripcion;
  final List<String> imagenes;
  final bool? destacado;
  final bool? verificado;
  final DateTime? fechaCreacion;
  final DateTime? fechaActualizacion;

  Vehiculo({
    required this.idVehiculo,
    required this.idUsuario,
    required this.titulo,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.kilometros,
    required this.tipoCombustible,
    required this.cv,
    required this.tipoEtiqueta,
    required this.precio,
    this.ubicacion,
    this.descripcion,
    required this.imagenes,
    this.destacado,
    this.verificado,
    this.fechaCreacion,
    this.fechaActualizacion,
  });
}