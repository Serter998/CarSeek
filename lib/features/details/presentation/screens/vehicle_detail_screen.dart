import 'package:car_seek/core/widgets/favorite_button.dart';
import 'package:car_seek/features/details/presentation/widgets/vehicle_image_slider.dart';
import 'package:car_seek/features/details/presentation/widgets/vehicle_info_chip.dart';
import 'package:car_seek/features/navigation/presentation/main_scrreen.dart';
import 'package:car_seek/share/domain/repositories/conversacion_repository.dart';
import 'package:flutter/material.dart';
import 'package:car_seek/share/domain/entities/vehiculo.dart';
import 'package:car_seek/core/constants/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_seek/features/favorites/presentation/blocs/favorite_vehicles_bloc.dart';
import 'package:get_it/get_it.dart';

import '../blocs/vehicle_detail_bloc.dart';

class VehicleDetailScreen extends StatefulWidget {
  final Vehiculo vehiculo;

  const VehicleDetailScreen({super.key, required this.vehiculo});

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (_) => VehicleDetailBloc(
          conversacionRepository: GetIt.instance.get<ConversacionRepository>()),
      child: BlocConsumer<VehicleDetailBloc, VehicleDetailState>(
        listener: (context, state) {
          if (state is VehicleDetailError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColors.primary,));
          } else if (state is VehicleDetailNavigateToChat) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MainScreen(
                  initialIndex: 2,
                  initialConversacion: state.conversacion,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return BlocBuilder<FavoriteVehiclesBloc, FavoriteVehiclesState>(
            builder: (context, favState) {
              bool isFavorite = false;
              if (favState is FavoriteVehiclesLoaded) {
                isFavorite = favState.favoritos
                    .any((f) => f.idVehiculo == widget.vehiculo.idVehiculo);
              }

              void toggleFavorite() {
                context.read<FavoriteVehiclesBloc>().add(
                    ToggleVehiculoFavoritoEvent(vehiculo: widget.vehiculo));
              }

              return Scaffold(
                appBar: isWide
                    ? null
                    : AppBar(
                  backgroundColor: AppColors.primary,
                  iconTheme: const IconThemeData(color: Colors.black),
                  title: Text(
                    widget.vehiculo.titulo,
                    style:
                    const TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  actions: [
                    FavoriteButton(
                      isFavorite: isFavorite,
                      onPressed: toggleFavorite,
                    ),
                  ],
                ),
                body: SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(isWide ? 32 : 16),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 900),
                        child: Card(
                          elevation: isWide ? 2 : 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (isWide) ...[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: TextButton.icon(
                                      onPressed: () => Navigator.of(context).pop(),
                                      icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.white : Colors.black),
                                      label: Text(
                                        'Volver',
                                        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],

                                if (widget.vehiculo.imagenes.isNotEmpty)
                                  isWide
                                      ? Stack(
                                    children: [
                                      VehicleImageSlider(
                                        imagenes: widget.vehiculo.imagenes,
                                        currentPage: currentPage,
                                        onPageChanged: (index) {
                                          setState(() {
                                            currentPage = index;
                                          });
                                        },
                                        pageController: _pageController,
                                      ),
                                      Positioned(
                                        top: 16,
                                        right: 16,
                                        child: FavoriteButton(
                                          isFavorite: isFavorite,
                                          onPressed: toggleFavorite,
                                        ),
                                      ),
                                    ],
                                  )
                                      : VehicleImageSlider(
                                    imagenes: widget.vehiculo.imagenes,
                                    currentPage: currentPage,
                                    onPageChanged: (index) {
                                      setState(() {
                                        currentPage = index;
                                      });
                                    },
                                    pageController: _pageController,
                                  ),
                                const SizedBox(height: 20),

                                Text(
                                  widget.vehiculo.titulo,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${widget.vehiculo.marca} ${widget.vehiculo.modelo}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  '${widget.vehiculo.anio} • ${widget.vehiculo.kilometros} km',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '${widget.vehiculo.precio.toStringAsFixed(2)}€',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  children: [
                                    VehicleInfoChip(
                                        icon: Icons.speed,
                                        text: '${widget.vehiculo.cv} CV'),
                                    VehicleInfoChip(
                                      icon: Icons.local_gas_station,
                                      text: widget.vehiculo.tipoCombustible.name
                                          .toUpperCase(),
                                    ),
                                    VehicleInfoChip(
                                      icon: Icons.eco,
                                      text: 'Etiqueta ${widget.vehiculo.tipoEtiqueta.name.toUpperCase()}',
                                    ),
                                    if (widget.vehiculo.ubicacion != null)
                                      VehicleInfoChip(
                                        icon: Icons.location_on,
                                        text: widget.vehiculo.ubicacion!,
                                      ),
                                  ],
                                ),

                                const SizedBox(height: 24),

                                if (widget.vehiculo.descripcion != null &&
                                    widget.vehiculo.descripcion!.isNotEmpty)
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    margin: const EdgeInsets.only(top: 12),
                                    decoration: BoxDecoration(
                                      color: isDarkMode
                                          ? Colors.white.withOpacity(0.05)
                                          : Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Descripción del vehículo',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          widget.vehiculo.descripcion!,
                                          style: TextStyle(
                                            fontSize: 16,
                                            height: 1.5,
                                            color: isDarkMode
                                                ? Colors.white70
                                                : Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                const SizedBox(height: 32),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    minimumSize: const Size.fromHeight(50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(12)),
                                  ),
                                  icon: const Icon(Icons.chat),
                                  label: const Text('Contactar con el vendedor'),
                                  onPressed: () {
                                    context.read<VehicleDetailBloc>().add(
                                        ContactSellerEvent(
                                            vehiculo: widget.vehiculo));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
