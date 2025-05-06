part of 'sell_bloc.dart';

sealed class SellState{}

final class SellCreate extends SellState{
  final String? titulo;

  SellCreate({this.titulo});
}

final class SellCreateTitulo extends SellState{
  final String titulo;
  final String? marca;
  final String? modelo;
  final int? anio;
  final int? km;
  final TipoCombustible? combustibleSeleccionado;
  final int? cv;
  final TipoEtiqueta? tipoEtiqueta;
  final String? descripcion;

  SellCreateTitulo({
    required this.titulo,
    this.marca,
    this.modelo,
    this.anio,
    this.km,
    this.combustibleSeleccionado,
    this.cv,
    this.tipoEtiqueta,
    this.descripcion,
  });
}

class SellCreateCaracteristicas extends SellState {
  final String titulo;
  final String marca;
  final String modelo;
  final int anio;
  final int km;
  final TipoCombustible combustibleSeleccionado;
  final int cv;
  final TipoEtiqueta tipoEtiqueta;
  final String descripcion;

  SellCreateCaracteristicas({
    required this.titulo,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.km,
    required this.combustibleSeleccionado,
    required this.cv,
    required this.tipoEtiqueta,
    required this.descripcion,
  });
}

final class SellLoading extends SellState{}

final class SellError extends SellState{
  final Failure failure;

  SellError({required this.failure});
}

final class SellCreateSuccess extends SellState{}