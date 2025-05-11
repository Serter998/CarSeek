import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VehicleImageCarousel extends StatelessWidget {
  final List<String> images;
  final PageController controller;
  final int currentIndex;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const VehicleImageCarousel({
    super.key,
    required this.images,
    required this.controller,
    required this.currentIndex,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    final hasMultipleImages = images.length > 1;

    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: AspectRatio(
            aspectRatio: 4 / 3,
            child: PageView.builder(
              controller: controller,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: images[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: Colors.grey[200],
                    child: const Center(child: Icon(Icons.directions_car, size: 40)),
                  ),
                );
              },
            ),
          ),
        ),
        if (hasMultipleImages) ...[
          Positioned(
            left: 4,
            top: 0,
            bottom: 0,
            child: IconButton(
              icon: _arrowButton(Icons.chevron_left),
              onPressed: onPrevious,
            ),
          ),
          Positioned(
            right: 4,
            top: 0,
            bottom: 0,
            child: IconButton(
              icon: _arrowButton(Icons.chevron_right),
              onPressed: onNext,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                    (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentIndex == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _arrowButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}
