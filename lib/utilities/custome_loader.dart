// lib/widgets/custom_loader.dart
import 'package:flutter/material.dart';

class CustomLoader extends StatelessWidget {
  final double size;
  final Color? color;
  final String? message;
  final bool isOverlay;

  const CustomLoader({
    super.key,
    this.size = 40.0,
    this.color,
    this.message,
    this.isOverlay = false,
  });

  @override
  Widget build(BuildContext context) {
    final loader = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _AnimatedLoader(
          size: size,
          color: color ?? Theme.of(context).primaryColor,
        ),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: TextStyle(
              color: color ?? Theme.of(context).primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );

    if (isOverlay) {
      return Stack(
        children: [
          const Opacity(
            opacity: 0.5,
            child: ModalBarrier(
              dismissible: false,
              color: Colors.black,
            ),
          ),
          Center(child: loader),
        ],
      );
    }

    return Center(child: loader);
  }
}

class _AnimatedLoader extends StatefulWidget {
  final double size;
  final Color color;

  const _AnimatedLoader({
    required this.size,
    required this.color,
  });

  @override
  State<_AnimatedLoader> createState() => _AnimatedLoaderState();
}

class _AnimatedLoaderState extends State<_AnimatedLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _radiusAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    _radiusAnimation =
        Tween(begin: widget.size * 0.2, end: widget.size * 0.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(widget.size * 0.2),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            children: List.generate(8, (index) {
              final rotation = (index * (360 / 8)) * (3.14159 / 180);
              final position = _rotationAnimation.value * 2 * 3.14159;
              final delta = (position + rotation) % (2 * 3.14159);
              final opacity = (1 - (delta / (2 * 3.14159))) * 0.8;

              return Positioned.fill(
                child: Transform.rotate(
                  angle: rotation,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: _radiusAnimation.value,
                      height: _radiusAnimation.value,
                      decoration: BoxDecoration(
                        color: widget.color.withOpacity(opacity),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
