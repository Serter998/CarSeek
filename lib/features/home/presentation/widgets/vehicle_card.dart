import 'package:car_seek/features/home/presentation/widgets/vehicle_image_carousel.dart';
import 'package:flutter/material.dart';
import 'package:car_seek/share/domain/entities/vehiculo.dart';
import 'package:car_seek/core/constants/app_colors.dart';

class MarketplaceVehicleCard extends StatefulWidget {
  final Vehiculo vehiculo;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onTap;

  const MarketplaceVehicleCard({
    super.key,
    required this.vehiculo,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onTap,
  });

  @override
  State<MarketplaceVehicleCard> createState() => _MarketplaceVehicleCardState();
}

class _MarketplaceVehicleCardState extends State<MarketplaceVehicleCard> {
  int _currentImageIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextImage() {
    if (_currentImageIndex < widget.vehiculo.imagenes.length - 1) {
      setState(() => _currentImageIndex++);
      _pageController.animateToPage(
        _currentImageIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevImage() {
    if (_currentImageIndex > 0) {
      setState(() => _currentImageIndex--);
      _pageController.animateToPage(
        _currentImageIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: widget.onTap,
        child: Column(
          children: [
            VehicleImageCarousel(
              images: widget.vehiculo.imagenes,
              controller: _pageController,
              currentIndex: _currentImageIndex,
              onNext: _nextImage,
              onPrevious: _prevImage,
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.vehiculo.titulo,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        if (widget.vehiculo.verificado == true)
                          const Icon(Icons.verified, color: Colors.blueAccent, size: 16),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.vehiculo.marca} ${widget.vehiculo.modelo}',
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${widget.vehiculo.kilometros} km · ${widget.vehiculo.anio}',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.vehiculo.precio.toStringAsFixed(0)} €',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.onToggleFavorite();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  widget.isFavorite
                                      ? '¡Vehículo eliminado de favoritos!'
                                      : '¡Vehículo añadido a favoritos!',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                backgroundColor: AppColors.primary,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Icon(
                            widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: widget.isFavorite ? Colors.red : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
