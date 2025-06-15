import 'package:flutter/material.dart';

class ResponsiveLayout {
  // Screen size breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }

  // Get dynamic sizing based on screen width
  static double getResponsiveValue({
    required BuildContext context,
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= tabletBreakpoint) {
      return desktop ?? tablet ?? mobile;
    } else if (screenWidth >= mobileBreakpoint) {
      return tablet ?? mobile;
    } else {
      return mobile;
    }
  }

  // Get dynamic padding based on screen size
  static EdgeInsets getResponsivePadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: getResponsiveValue(
        context: context,
        mobile: 16.0,
        tablet: 24.0,
        desktop: 32.0,
      ),
      vertical: 16.0,
    );
  }

  // Responsive builder
  static Widget builder({
    required BuildContext context,
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= desktopBreakpoint) {
      return desktop ?? tablet ?? mobile;
    } else if (screenWidth >= tabletBreakpoint) {
      return tablet ?? mobile;
    } else {
      return mobile;
    }
  }

  // Get font size based on screen size
  static double getFontSize(BuildContext context, double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= desktopBreakpoint) {
      return baseFontSize * 1.2;
    } else if (screenWidth >= tabletBreakpoint) {
      return baseFontSize * 1.1;
    } else {
      return baseFontSize;
    }
  }

  // Safe area for bottom navigation
  static double getBottomNavHeight(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return 56.0 + (bottomPadding > 0 ? bottomPadding : 0);
  }
}
