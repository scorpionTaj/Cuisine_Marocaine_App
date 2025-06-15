import 'package:flutter/material.dart';

class AppAnimations {
  // Page route animations
  static Route pageRouteBuilder(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  // Fade-in animation widget
  static Widget fadeIn({
    required Widget child,
    Duration duration = const Duration(milliseconds: 500),
    Duration delay = const Duration(milliseconds: 0),
    Curve curve = Curves.easeInOut,
  }) {
    return FutureBuilder<bool>(
      future: Future.delayed(delay, () => true),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        return TweenAnimationBuilder<double>(
          duration: duration,
          tween: Tween<double>(begin: 0.0, end: 1.0),
          curve: curve,
          builder: (context, value, _) {
            return Opacity(
              opacity: value,
              child: child,
            );
          },
        );
      }
    );
  }

  // Scale animation widget
  static Widget scaleIn({
    required Widget child,
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.easeOutBack,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween<double>(begin: 0.85, end: 1.0),
      curve: curve,
      builder: (context, value, _) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
    );
  }

  // Animated list item
  static Widget animatedListItem({
    required Widget child,
    required int index,
    Duration delay = const Duration(milliseconds: 50),
  }) {
    return AnimatedAppear(
      delay: Duration(milliseconds: delay.inMilliseconds * index),
      child: child,
    );
  }
}

class AnimatedAppear extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;

  const AnimatedAppear({
    Key? key,
    required this.child,
    this.delay = const Duration(milliseconds: 0),
    this.duration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  _AnimatedAppearState createState() => _AnimatedAppearState();
}

class _AnimatedAppearState extends State<AnimatedAppear> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
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
        return Opacity(
          opacity: _opacityAnimation.value,
          child: SlideTransition(
            position: _slideAnimation,
            child: widget.child,
          ),
        );
      },
    );
  }
}
