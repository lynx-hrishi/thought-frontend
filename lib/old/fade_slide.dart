import 'package:flutter/material.dart';

class FadeSlide extends StatefulWidget {
  final Widget child;
  const FadeSlide({super.key, required this.child});

  @override
  State<FadeSlide> createState() => _FadeSlideState();
}

class _FadeSlideState extends State<FadeSlide>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> fade;
  late Animation<Offset> slide;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    fade = Tween(begin: 0.0, end: 1.0).animate(controller);
    slide =
        Tween(begin: const Offset(0, 0.08), end: Offset.zero).animate(controller);
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fade,
      child: SlideTransition(position: slide, child: widget.child),
    );
  }
}