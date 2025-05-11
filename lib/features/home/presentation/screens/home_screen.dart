import 'package:car_seek/core/constants/app_colors.dart';
import 'package:car_seek/core/navigation/navigation_widget.dart';
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
  final Set<String> _favorites = {};
  FiltroVehiculo? _filtroSeleccionado;

  @override
  void initState() {
    super.initState();
    context.read<VehicleListBloc>().add(LoadAllVehiculosEvent());
  }

  void _onSearch(String value) {
    context.read<VehicleListBloc>().add(FilterVehiculosEvent(
      query: value,
      filtro: _filtroSeleccionado,
    ));
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
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.car_rental),
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
            child: BlocBuilder<VehicleListBloc, VehicleListState>(
              builder: (context, state) {
                if (state is VehicleListLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is VehicleListLoaded) {
                  return ResponsiveVehicleGrid(
                    vehiculos: state.vehiculos,
                    itemBuilder: (vehiculo) => MarketplaceVehicleCard(
                      vehiculo: vehiculo,
                      isFavorite: _favorites.contains(vehiculo.idVehiculo),
                      onToggleFavorite: () {
                        setState(() {
                          if (_favorites.contains(vehiculo.idVehiculo)) {
                            _favorites.remove(vehiculo.idVehiculo);
                          } else {
                            _favorites.add(vehiculo.idVehiculo);
                          }
                        });
                      },
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => VehicleDetailScreen(vehiculo: vehiculo),
                            ),
                        );
                      },
                    ),
                  );
                } else if (state is VehicleListError) {
                  return Center(child: Text('Error: ${state.failure.message}'));
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationWidget.customBottonNavigationBar(context, 0),
    );
  }
}
