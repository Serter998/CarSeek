import 'dart:async';
import 'package:car_seek/features/favorites/presentation/widgets/favorites_count_banner.dart';
import 'package:car_seek/features/favorites/presentation/widgets/favorites_vehicle_list.dart';
import 'package:car_seek/features/favorites/presentation/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:car_seek/core/constants/app_colors.dart';
import 'package:car_seek/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:car_seek/features/favorites/presentation/blocs/favorite_vehicles_bloc.dart';
import 'package:car_seek/features/home/presentation/screens/vehicle_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String _searchQuery = '';
  FavoriteVehiclesBloc? _favoriteBloc;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthLoginSuccess) {
        final userId = authState.user.id;
        final bloc = GetIt.I<FavoriteVehiclesBloc>(param1: userId);
        bloc.add(LoadFavoritosConVehiculosEvent(userId: userId));
        setState(() {
          _favoriteBloc = bloc;
        });
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _favoriteBloc?.close();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() {
        _searchQuery = value.trim().toLowerCase();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_favoriteBloc == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return BlocProvider.value(
      value: _favoriteBloc!,
      child: _FavoritesContent(
        searchController: _searchController,
        onSearchChanged: _onSearchChanged,
        searchQuery: _searchQuery,
      ),
    );
  }
}

class _FavoritesContent extends StatelessWidget {
  final TextEditingController searchController;
  final void Function(String) onSearchChanged;
  final String searchQuery;

  const _FavoritesContent({
    required this.searchController,
    required this.onSearchChanged,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.favorite_border, color: Colors.white),
        title: const Text('Mis Favoritos'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          SearchBarWidget(
            controller: searchController,
            onChanged: onSearchChanged,
          ),

          BlocBuilder<FavoriteVehiclesBloc, FavoriteVehiclesState>(
            builder: (context, favState) {
              if (favState is FavoriteVehiclesLoaded) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: FavoritesCountWidget(
                    count: favState.vehiculosFavoritos.where((vehiculo) {
                      final title = vehiculo.titulo?.toLowerCase() ?? '';
                      final description = vehiculo.descripcion?.toLowerCase() ?? '';
                      return title.contains(searchQuery) || description.contains(searchQuery);
                    }).length,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          Expanded(
            child: BlocListener<FavoriteVehiclesBloc, FavoriteVehiclesState>(
              listener: (context, state) {
                if (state is FavoriteError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${state.message}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (state is FavoriteVehiclesLoaded && state.message != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message!),
                      backgroundColor: AppColors.primary,
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: BlocBuilder<FavoriteVehiclesBloc, FavoriteVehiclesState>(
                builder: (context, favState) {
                  if (favState is FavoriteLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (favState is FavoriteError) {
                    return Center(child: Text('Error cargando favoritos: ${favState.failure.message}'));
                  }

                  if (favState is FavoriteVehiclesLoaded) {
                    return FavoritesVehicleList(
                      vehiculos: favState.vehiculosFavoritos,
                      searchQuery: searchQuery,
                      onToggleFavorite: (vehiculo) {
                        context.read<FavoriteVehiclesBloc>().add(
                          ToggleVehiculoFavoritoEvent(vehiculo: vehiculo),
                        );
                      },
                      onTapVehicle: (vehiculo) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: BlocProvider.of<FavoriteVehiclesBloc>(context),
                              child: VehicleDetailScreen(vehiculo: vehiculo),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}