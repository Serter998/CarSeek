import 'package:flutter/material.dart';

class InputText extends StatefulWidget {
  final String placeholder;
  final Icon icon;
  final TextEditingController? controller;
  final String? toolTip;
  final bool isPassword;
  final int? longitudMax;

  const InputText({
    super.key,
    required this.placeholder,
    required this.controller,
    required this.icon,
    required this.toolTip,
    required this.isPassword,
    required this.longitudMax,
  });

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText>
    with SingleTickerProviderStateMixin {
  late FocusNode _focusNode;
  OverlayEntry? _tooltipOverlay;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showTooltip(context);
      } else {
        _hideTooltip();
      }
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    if (!widget.isPassword) {
      _isPasswordVisible = true;
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _animationController.dispose();
    _tooltipOverlay?.remove();
    super.dispose();
  }

  void _showTooltip(BuildContext context) {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox?;
    final offset = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;

    _tooltipOverlay = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _focusNode.unfocus();
        },
        child: Stack(
          children: [
            Positioned(
              left: offset.dx + 40,
              top: offset.dy - 50,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(245, 7, 179, 167),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Text(
                      widget.toolTip ?? "",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    overlay.insert(_tooltipOverlay!);
    _animationController.forward();
  }

  void _hideTooltip() async {
    await _animationController.reverse();
    _tooltipOverlay?.remove();
    _tooltipOverlay = null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, right: 8, left: 8),
      child: TextField(
        controller: widget.controller,
        focusNode: widget.toolTip != null ? _focusNode : null,
        obscureText: !_isPasswordVisible,
        maxLength: widget.longitudMax,
        decoration: InputDecoration(
          hintText: widget.placeholder,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          prefixIcon: widget.icon,
          suffixIcon: widget.isPassword
              ? IconButton(
            icon: Icon(
              _isPasswordVisible
                  ? Icons.visibility_off
                  : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          )
              : null,
        ),
      ),
    );
  }
}
