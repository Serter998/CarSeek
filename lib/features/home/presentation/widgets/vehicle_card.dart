import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
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
  bool _isVisible = false;

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
    if (!_isVisible) return;
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
    if (!_isVisible) return;
    if (_currentImageIndex > 0) {
      setState(() => _currentImageIndex--);
      _pageController.animateToPage(
        _currentImageIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleToggleFavorite() {
    widget.onToggleFavorite();
    final isNowFavorite = !widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('marketplace-vehicle-card-${widget.vehiculo.idVehiculo}'),
      onVisibilityChanged: (visibilityInfo) {
        final visiblePercentage = visibilityInfo.visibleFraction * 100;
        bool currentlyVisible = visiblePercentage > 0;
        if (currentlyVisible != _isVisible) {
          if(!mounted) return;
          setState(() {
            _isVisible = currentlyVisible;
          });
        }
      },
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        elevation: 1,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: widget.onTap,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: _isVisible
                      ? CachedNetworkImage(
                    imageUrl: widget.vehiculo.imagenes[_currentImageIndex],
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                    errorWidget: (_, __, ___) => Container(
                      color: Colors.grey[200],
                      child: const Center(child: Icon(Icons.directions_car, size: 40)),
                    ),
                  )
                      : Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.image, size: 40, color: Colors.grey),
                    ),
                  ),
                ),
              ),
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
                            onTap: _handleToggleFavorite,
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
      ),
    );
  }
}
