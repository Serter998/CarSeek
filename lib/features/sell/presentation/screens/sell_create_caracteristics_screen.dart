import 'package:car_seek/core/widgets/custom_snack_bar.dart';
import 'package:car_seek/features/sell/presentation/blocs/sell_bloc.dart';
import 'package:car_seek/features/sell/presentation/widgets/sell_create_caracteristicas_widget.dart';
import 'package:car_seek/share/domain/enums/tipo_combustible.dart';
import 'package:car_seek/share/domain/enums/tipo_etiqueta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SellCreateCaracteristicsScreen extends StatefulWidget {
  final String titulo;
  final String? marca;
  final String? modelo;
  final int? anio;
  final int? km;
  final TipoCombustible? tipoCombustible;
  final int? cv;
  final TipoEtiqueta? tipoEtiqueta;
  final String? descripcion;

  const SellCreateCaracteristicsScreen({super.key, required this.titulo, this.marca, this.modelo, this.anio, this.km, this.tipoCombustible, this.cv, this.tipoEtiqueta, this.descripcion});

  @override
  State<SellCreateCaracteristicsScreen> createState() =>
      _SellCreateCaracteristicsScreenState();
}

class _SellCreateCaracteristicsScreenState
    extends State<SellCreateCaracteristicsScreen> {
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _anioController = TextEditingController();
  final TextEditingController _kmController = TextEditingController();
  TipoCombustible? _combustibleSeleccionado;
  final TextEditingController _cvController = TextEditingController();
  TipoEtiqueta? _etiquetaSeleccionada;
  final TextEditingController _descripcionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.marca != null) _marcaController.text = widget.marca!;
    if (widget.modelo != null) _modeloController.text = widget.modelo!;
    if (widget.anio != null) _anioController.text = widget.anio!.toString();
    if (widget.km != null) _kmController.text = widget.km!.toString();
    if (widget.tipoCombustible != null) _combustibleSeleccionado = widget.tipoCombustible;
    if (widget.cv != null) _cvController.text = widget.cv!.toString();
    if (widget.tipoEtiqueta != null) _etiquetaSeleccionada = widget.tipoEtiqueta;
    if (widget.descripcion != null) _descripcionController.text = widget.descripcion!;
  }

  @override
  void dispose() {
    super.dispose();
    _marcaController.dispose();
    _modeloController.dispose();
    _anioController.dispose();
    _kmController.dispose();
    _cvController.dispose();
    _descripcionController.dispose();
  }

  void _volver() {
    context.read<SellBloc>().add(OnVolverTitleSellEvent(widget.titulo));
  }

  void _continuar() {
    final titulo = widget.titulo;
    final marca = _marcaController.text.trim();
    final modelo = _modeloController.text.trim();
    final anioTexto = _anioController.text.trim();
    final kmTexto = _kmController.text.trim();
    final combustibleSeleccionado = _combustibleSeleccionado;
    final cvTexto = _cvController.text.trim();
    final tipoEtiqueta = _etiquetaSeleccionada;
    final descripcion = _descripcionController.text.trim();

    if (isDataNotEmpty(
      marca,
      modelo,
      anioTexto,
      kmTexto,
      combustibleSeleccionado,
      cvTexto,
      tipoEtiqueta,
    )) {

      try {
        final anio = int.parse(anioTexto);
        final km = int.parse(kmTexto);
        final cv = int.parse(cvTexto);
        if (anio > 1900 && anio < DateTime.now().year + 1) {
          context.read<SellBloc>().add(
            OnSetCaracteristicasEvent(
              titulo: titulo,
              marca: marca,
              modelo: modelo,
              anio: anio,
              km: km,
              combustibleSeleccionado: combustibleSeleccionado!,
              cv: cv,
              tipoEtiqueta: tipoEtiqueta!,
              descripcion: descripcion,
            ),
          );
        } else {
          CustomSnackBar.showWarning(
            context: context,
            message: "Debes introducir un año entre 1901 y el ${DateTime.now().year}.",
          );
        }
      } catch (e) {
        CustomSnackBar.showError(
          context: context,
          message: "Error al parsear los datos. Contacte con soporte.",
        );
      }
    } else {
      CustomSnackBar.showWarning(
        context: context,
        message: "Por favor, rellena todos los campos con *.",
      );
    }
  }

  bool isDataNotEmpty(
    String marca,
    String modelo,
    String anio,
    String km,
    TipoCombustible? combustibleSeleccionado,
    String cv,
    TipoEtiqueta? tipoEtiqueta,
  ) {
    return marca.isNotEmpty &&
        modelo.isNotEmpty &&
        anio.isNotEmpty &&
        km.isNotEmpty &&
        combustibleSeleccionado != null &&
        cv.isNotEmpty &&
        tipoEtiqueta != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SellCreateCaracteristicsCard(
                marcaController: _marcaController,
                modeloController: _modeloController,
                anioController: _anioController,
                kmController: _kmController,
                combustibleSeleccionado: _combustibleSeleccionado,
                cvController: _cvController,
                etiquetaSeleccionada: _etiquetaSeleccionada,
                descripcionController: _descripcionController,
                onCombustibleChanged: (newValue) {
                  setState(() {
                    _combustibleSeleccionado = newValue;
                  });
                },
                onEtiquetaChanged: (newValue) {
                  setState(() {
                    _etiquetaSeleccionada = newValue;
                  });
                },
                onVolver: _volver,
                onSave: _continuar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
