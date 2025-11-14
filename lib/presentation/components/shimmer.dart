// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

Widget shimmerContainer(double height, double width) {
  return CustomShimmer(
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    ),
  );
}

class CustomShimmer extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Color baseColor;
  final Color highlightColor;

  const CustomShimmer({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.baseColor = const Color(0xFFE0E0E0), // Default base color (light grey)
    this.highlightColor = const Color(0xFFF5F5F5), // Default highlight color
  });

  @override
  _CustomShimmerState createState() => _CustomShimmerState();
}

class _CustomShimmerState extends State<CustomShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
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
        return ShaderMask(
          shaderCallback: (bounds) {
            double shimmerWidth =
                bounds.width * .5; // Ensure smooth gradient width
            final gradient = LinearGradient(
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: const [0.2, 0.5, 0.8],
              begin: const Alignment(-1, -0.3),
              end: const Alignment(2, 0.3),
              transform: _SlidingGradientTransform(
                slidePercent: _controller.value,
              ),
            );
            return gradient.createShader(
              Rect.fromLTWH(0, 0, shimmerWidth, bounds.height),
            );
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Helper class to create smooth sliding effect for the gradient
class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform({required this.slidePercent});

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}
