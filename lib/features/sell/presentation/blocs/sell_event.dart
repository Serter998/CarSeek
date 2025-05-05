part of 'sell_bloc.dart';

sealed class SellEvent {}

class ResetSellEvent extends SellEvent {}

class OnCreateSellEvent extends SellEvent {
  final Vehiculo vehiculo;

  OnCreateSellEvent({required this.vehiculo});
}

class OnSetTituloEvent extends SellEvent {
  final String titulo;

  OnSetTituloEvent({required this.titulo});
}

class OnSetCaracteristicasEvent extends SellEvent {
  final String titulo;
  final String marca;
  final String modelo;
  final int anio;
  final int km;
  final TipoCombustible combustibleSeleccionado;
  final int cv;
  final TipoEtiqueta tipoEtiqueta;
  final String descripcion;

  OnSetCaracteristicasEvent({
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
