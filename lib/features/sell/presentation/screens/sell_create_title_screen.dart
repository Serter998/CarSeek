import 'package:car_seek/core/services/navigation_service.dart';
import 'package:car_seek/core/themes/text_styles.dart';
import 'package:car_seek/core/widgets/custom_snack_bar.dart';
import 'package:car_seek/features/sell/presentation/blocs/sell_bloc.dart';
import 'package:car_seek/features/sell/presentation/screens/sell_create_caracteristics_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SellCreateTitleScreen extends StatefulWidget {
  const SellCreateTitleScreen({super.key});

  @override
  State<SellCreateTitleScreen> createState() => _SellCreateTitleScreenState();
}

class _SellCreateTitleScreenState extends State<SellCreateTitleScreen> {
  final TextEditingController _tituloController = TextEditingController();

  void _continuar() {
    final titulo = _tituloController.text.trim();

    if (titulo.isNotEmpty) {
      context.read<SellBloc>().add(OnSetTituloEvent(titulo: titulo));
      /*NavigationService.navigateToWidget(
        context,
        SellCreateCaracteristicsScreen(titulo: titulo),
      );*/
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    height: 180,
                    child: Image.asset(
                      "assets/images/VentaVehiculo.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: Column(
                  children: [
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
                  ],
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _tituloController,
                decoration: InputDecoration(
                  labelText: 'Escribe el título aquí*',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _continuar,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Continuar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
