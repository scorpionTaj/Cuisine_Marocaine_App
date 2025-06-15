import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryViolet = Color(0xFF7C3AED);
  static const Color secondaryBackground = Color(0xFFF5F5F5);
  static const Color darkBackground = Color(0xFF1A1A1A);
  static const Color lightText = Colors.white;
  static const Color darkText = Colors.black;

  static ThemeData getTheme(ThemeMode mode, Color primaryColor) {
    return mode == ThemeMode.dark
      ? getDarkTheme(primaryColor)
      : getLightTheme(primaryColor);
  }

  static ThemeData getLightTheme(Color primaryColor) {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: secondaryBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: lightText,
        elevation: 0,
        iconTheme: const IconThemeData(color: lightText),
        titleTextStyle: GoogleFonts.cairo(
          color: lightText,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: primaryColor,
        background: secondaryBackground,
        onPrimary: lightText,
        onSecondary: darkText,
        onBackground: darkText,
        onSurface: darkText,
      ),
      textTheme: GoogleFonts.cairoTextTheme().copyWith(
        bodyMedium: GoogleFonts.cairo(color: darkText),
        bodyLarge: GoogleFonts.cairo(color: darkText),
        titleLarge: GoogleFonts.cairo(color: primaryColor),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: lightText,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: lightText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: TextStyle(color: Colors.grey[400]),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                   TargetPlatform.iOS: CupertinoPageTransitionsBuilder()},
      ),
    );
  }

  static ThemeData getDarkTheme(Color primaryColor) {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: lightText,
        elevation: 0,
        iconTheme: const IconThemeData(color: lightText),
        titleTextStyle: GoogleFonts.cairo(
          color: lightText,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: primaryColor,
        background: darkBackground,
        onPrimary: lightText,
        onSecondary: lightText,
        onBackground: lightText,
        onSurface: lightText,
        error: Colors.redAccent,
        onError: lightText,
      ),
      textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme).copyWith(
        bodyMedium: GoogleFonts.cairo(color: lightText),
        bodyLarge: GoogleFonts.cairo(color: lightText),
        titleLarge: GoogleFonts.cairo(color: primaryColor),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkBackground,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
      cardTheme: CardThemeData(
        color: Color(0xFF232323),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: lightText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF2A2A2A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: TextStyle(color: Colors.grey[600]),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: Color(0xFF2A2A2A),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                   TargetPlatform.iOS: CupertinoPageTransitionsBuilder()},
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryColor;
          }
          return Colors.grey;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryColor.withOpacity(0.5);
          }
          return Colors.grey.withOpacity(0.5);
        }),
      ),
    );
  }

  // Legacy properties for backward compatibility
  static ThemeData get lightTheme => getLightTheme(primaryViolet);
  static ThemeData get darkTheme => getDarkTheme(primaryViolet);
}