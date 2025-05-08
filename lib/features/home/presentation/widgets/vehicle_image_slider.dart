import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VehicleImageSlider extends StatefulWidget {
  final List<String> imagenes;
  final int currentPage;
  final ValueChanged<int> onPageChanged;

  const VehicleImageSlider({
    super.key,
    required this.imagenes,
    required this.currentPage,
    required this.onPageChanged,
  });

  @override
  State<VehicleImageSlider> createState() => _VehicleImageSliderState();
}

class _VehicleImageSliderState extends State<VehicleImageSlider> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;

    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: AspectRatio(
            aspectRatio: 4 / 3,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.imagenes.length,
              onPageChanged: widget.onPageChanged,
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: widget.imagenes[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 50, color: Colors.black54),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        if (widget.imagenes.length > 1 || isWide) ...[
          _navigationButton(
            icon: Icons.chevron_left,
            onPressed: () {
              if (widget.currentPage > 0) {
                widget.onPageChanged(widget.currentPage - 1);
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            alignment: Alignment.centerLeft,
          ),
          _navigationButton(
            icon: Icons.chevron_right,
            onPressed: () {
              if (widget.currentPage < widget.imagenes.length - 1) {
                widget.onPageChanged(widget.currentPage + 1);
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            alignment: Alignment.centerRight,
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.imagenes.length,
                    (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.currentPage == index
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

  Widget _navigationButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Alignment alignment,
  }) {
    return Positioned.fill(
      child: Align(
        alignment: alignment,
        child: IconButton(
          icon: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(4),
            child: Icon(icon, color: Colors.white),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
