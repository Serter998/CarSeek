import 'package:car_seek/core/themes/text_styles.dart';
import 'package:car_seek/core/widgets/custom_snack_bar.dart';
import 'package:car_seek/features/sell/presentation/blocs/sell_bloc.dart';
import 'package:car_seek/features/sell/presentation/widgets/continue_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SellCreateTitleScreen extends StatefulWidget {
  final String? titulo;
  const SellCreateTitleScreen({super.key, this.titulo});

  @override
  State<SellCreateTitleScreen> createState() => _SellCreateTitleScreenState();
}

class _SellCreateTitleScreenState extends State<SellCreateTitleScreen> {
  final TextEditingController _tituloController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.titulo != null && widget.titulo!.isNotEmpty) {
      _tituloController.text = widget.titulo!;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tituloController.dispose();
  }

  void _continuar() {
    final titulo = _tituloController.text.trim();

    if (titulo.isNotEmpty) {
      context.read<SellBloc>().add(OnSetTituloEvent(titulo: titulo));
    } else {
      CustomSnackBar.showWarning(
        context: context,
        message: "Por favor, rellena todos los campos con *.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 20),
          child: Center(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        "assets/images/VentaVehiculo.png",
                        height: 220,
                        width: 240,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "¿Cuál es el título de la venta de tu vehículo?",
                      style: TextStyles.titleText,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Un buen título es breve, claro y atractivo para los compradores.",
                      style: TextStyles.subtitleText,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _tituloController,
                      decoration: InputDecoration(
                        labelText: 'Titulo*',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        ContinueButton(onPressed: _continuar, text: "Continuar"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
