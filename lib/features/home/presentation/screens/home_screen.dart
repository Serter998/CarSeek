import 'dart:async';
import 'package:car_seek/core/constants/app_colors.dart';
import 'package:car_seek/core/navigation/navigation_widget.dart';
import 'package:car_seek/features/%20favorites/presentation/blocs/favorite_vehicles_bloc.dart';
import 'package:car_seek/features/home/presentation/blocs/vehicle_list_bloc.dart';
import 'package:car_seek/features/home/presentation/screens/vehicle_detail_screen.dart';
import 'package:car_seek/features/home/presentation/widgets/filtro_activo_widget.dart';
import 'package:car_seek/features/home/presentation/widgets/filtro_dropdown.dart';
import 'package:car_seek/features/home/presentation/widgets/responsive_vehicle_grid.dart';
import 'package:car_seek/features/home/presentation/widgets/vehicle_card.dart';
import 'package:car_seek/share/domain/enums/filtro_vehiculo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  FiltroVehiculo? _filtroSeleccionado;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VehicleListBloc>().add(LoadAllVehiculosEvent());
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if(!mounted) return;
      context.read<VehicleListBloc>().add(FilterVehiculosEvent(
        query: value,
        filtro: _filtroSeleccionado,
      ));
    });
  }

  void _onFiltroSeleccionado(FiltroVehiculo filtro) {
    setState(() => _filtroSeleccionado = filtro);
    context.read<VehicleListBloc>().add(FilterVehiculosEvent(
      query: _searchController.text,
      filtro: filtro,
    ));
  }

  void _quitarFiltro() {
    setState(() => _filtroSeleccionado = null);
    context.read<VehicleListBloc>().add(FilterVehiculosEvent(
      query: _searchController.text,
      filtro: null,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
           (Icons.car_rental),
        ),
        title: const Text('CarSeek'),
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearch,
                    decoration: InputDecoration(
                      hintText: 'Buscar vehículos...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FiltroDropdown(
                  selectedFiltro: _filtroSeleccionado,
                  onFiltroSeleccionado: _onFiltroSeleccionado,
                ),
              ],
            ),
          ),

          if (_filtroSeleccionado != null)
            FiltroActivoWidget(
              filtro: _filtroSeleccionado!,
              onClear: _quitarFiltro,
            ),

          Expanded(
            child: MultiBlocListener(
              listeners: [
                BlocListener<FavoriteVehiclesBloc, FavoriteVehiclesState>(
                  listener: (context, state) {
                    if (state is FavoriteVehiclesError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error favoritos: ${state.failure.message}')),
                      );
                    }
                  },
                ),
                BlocListener<VehicleListBloc, VehicleListState>(
                  listener: (context, state) {
                    if (state is VehicleListError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error vehículos: ${state.failure.message}')),
                      );
                    }
                  },
                ),
              ],
              child: BlocBuilder<VehicleListBloc, VehicleListState>(
                builder: (context, vehicleState) {
                  if (vehicleState is VehicleListLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (vehicleState is VehicleListLoaded) {
                    final vehiculos = vehicleState.vehiculos;
                    return BlocBuilder<FavoriteVehiclesBloc, FavoriteVehiclesState>(
                      builder: (context, favState) {
                        final favoriteIds = <String>{};
                        if (favState is FavoriteVehiclesLoaded) {
                          favoriteIds.addAll(favState.favoritos.map((v) => v.idVehiculo));
                        }

                        return ResponsiveVehicleGrid(
                          vehiculos: vehiculos,
                          itemBuilder: (vehiculo) => MarketplaceVehicleCard(
                            vehiculo: vehiculo,
                            isFavorite: favoriteIds.contains(vehiculo.idVehiculo),
                            onToggleFavorite: () {
                              context.read<FavoriteVehiclesBloc>().add(ToggleFavoriteEvent(vehiculo));
                            },
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => VehicleDetailScreen(vehiculo: vehiculo),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationWidget.customBottonNavigationBar(context, 0),
    );
  }
}
