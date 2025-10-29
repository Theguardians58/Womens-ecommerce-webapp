import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LightModeColors {
  static const lightPrimary = Color(0xFF8B6F9E);
  static const lightOnPrimary = Color(0xFFFFFFFF);
  static const lightPrimaryContainer = Color(0xFFF8F3FA);
  static const lightOnPrimaryContainer = Color(0xFF2D1B3D);
  static const lightSecondary = Color(0xFFD4A5A5);
  static const lightOnSecondary = Color(0xFFFFFFFF);
  static const lightTertiary = Color(0xFFB8936E);
  static const lightOnTertiary = Color(0xFFFFFFFF);
  static const lightError = Color(0xFFD45D79);
  static const lightOnError = Color(0xFFFFFFFF);
  static const lightErrorContainer = Color(0xFFFFE8EC);
  static const lightOnErrorContainer = Color(0xFF5A1828);
  static const lightInversePrimary = Color(0xFFD9C4E8);
  static const lightShadow = Color(0xFF000000);
  static const lightSurface = Color(0xFFFFFBFF);
  static const lightOnSurface = Color(0xFF1F1A1E);
  static const lightAppBarBackground = Color(0xFFFFFBFF);
}

class DarkModeColors {
  static const darkPrimary = Color(0xFFD9C4E8);
  static const darkOnPrimary = Color(0xFF3D2A4F);
  static const darkPrimaryContainer = Color(0xFF6D5380);
  static const darkOnPrimaryContainer = Color(0xFFF3E9FF);
  static const darkSecondary = Color(0xFFE8C5C5);
  static const darkOnSecondary = Color(0xFF4A3535);
  static const darkTertiary = Color(0xFFD4B89E);
  static const darkOnTertiary = Color(0xFF3E2F1F);
  static const darkError = Color(0xFFFFB3C1);
  static const darkOnError = Color(0xFF5E1528);
  static const darkErrorContainer = Color(0xFF8A2C40);
  static const darkOnErrorContainer = Color(0xFFFFDAE0);
  static const darkInversePrimary = Color(0xFF8B6F9E);
  static const darkShadow = Color(0xFF000000);
  static const darkSurface = Color(0xFF15111A);
  static const darkOnSurface = Color(0xFFE9E1E8);
  static const darkAppBarBackground = Color(0xFF15111A);
}

class FontSizes {
  static const double displayLarge = 57.0;
  static const double displayMedium = 45.0;
  static const double displaySmall = 36.0;
  static const double headlineLarge = 32.0;
  static const double headlineMedium = 24.0;
  static const double headlineSmall = 22.0;
  static const double titleLarge = 22.0;
  static const double titleMedium = 18.0;
  static const double titleSmall = 16.0;
  static const double labelLarge = 16.0;
  static const double labelMedium = 14.0;
  static const double labelSmall = 12.0;
  static const double bodyLarge = 16.0;
  static const double bodyMedium = 14.0;
  static const double bodySmall = 12.0;
}

ThemeData get lightTheme => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    primary: LightModeColors.lightPrimary,
    onPrimary: LightModeColors.lightOnPrimary,
    primaryContainer: LightModeColors.lightPrimaryContainer,
    onPrimaryContainer: LightModeColors.lightOnPrimaryContainer,
    secondary: LightModeColors.lightSecondary,
    onSecondary: LightModeColors.lightOnSecondary,
    tertiary: LightModeColors.lightTertiary,
    onTertiary: LightModeColors.lightOnTertiary,
    error: LightModeColors.lightError,
    onError: LightModeColors.lightOnError,
    errorContainer: LightModeColors.lightErrorContainer,
    onErrorContainer: LightModeColors.lightOnErrorContainer,
    inversePrimary: LightModeColors.lightInversePrimary,
    shadow: LightModeColors.lightShadow,
    surface: LightModeColors.lightSurface,
    onSurface: LightModeColors.lightOnSurface,
  ),
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
    backgroundColor: LightModeColors.lightAppBarBackground,
    foregroundColor: LightModeColors.lightOnPrimaryContainer,
    elevation: 0,
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.playfairDisplay(fontSize: FontSizes.displayLarge, fontWeight: FontWeight.w600),
    displayMedium: GoogleFonts.playfairDisplay(fontSize: FontSizes.displayMedium, fontWeight: FontWeight.w600),
    displaySmall: GoogleFonts.playfairDisplay(fontSize: FontSizes.displaySmall, fontWeight: FontWeight.w600),
    headlineLarge: GoogleFonts.playfairDisplay(fontSize: FontSizes.headlineLarge, fontWeight: FontWeight.w600),
    headlineMedium: GoogleFonts.playfairDisplay(fontSize: FontSizes.headlineMedium, fontWeight: FontWeight.w500),
    headlineSmall: GoogleFonts.playfairDisplay(fontSize: FontSizes.headlineSmall, fontWeight: FontWeight.w500),
    titleLarge: GoogleFonts.inter(fontSize: FontSizes.titleLarge, fontWeight: FontWeight.w600),
    titleMedium: GoogleFonts.inter(fontSize: FontSizes.titleMedium, fontWeight: FontWeight.w500),
    titleSmall: GoogleFonts.inter(fontSize: FontSizes.titleSmall, fontWeight: FontWeight.w500),
    labelLarge: GoogleFonts.inter(fontSize: FontSizes.labelLarge, fontWeight: FontWeight.w500),
    labelMedium: GoogleFonts.inter(fontSize: FontSizes.labelMedium, fontWeight: FontWeight.w500),
    labelSmall: GoogleFonts.inter(fontSize: FontSizes.labelSmall, fontWeight: FontWeight.w400),
    bodyLarge: GoogleFonts.inter(fontSize: FontSizes.bodyLarge, fontWeight: FontWeight.normal),
    bodyMedium: GoogleFonts.inter(fontSize: FontSizes.bodyMedium, fontWeight: FontWeight.normal),
    bodySmall: GoogleFonts.inter(fontSize: FontSizes.bodySmall, fontWeight: FontWeight.normal),
  ),
);

ThemeData get darkTheme => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    primary: DarkModeColors.darkPrimary,
    onPrimary: DarkModeColors.darkOnPrimary,
    primaryContainer: DarkModeColors.darkPrimaryContainer,
    onPrimaryContainer: DarkModeColors.darkOnPrimaryContainer,
    secondary: DarkModeColors.darkSecondary,
    onSecondary: DarkModeColors.darkOnSecondary,
    tertiary: DarkModeColors.darkTertiary,
    onTertiary: DarkModeColors.darkOnTertiary,
    error: DarkModeColors.darkError,
    onError: DarkModeColors.darkOnError,
    errorContainer: DarkModeColors.darkErrorContainer,
    onErrorContainer: DarkModeColors.darkOnErrorContainer,
    inversePrimary: DarkModeColors.darkInversePrimary,
    shadow: DarkModeColors.darkShadow,
    surface: DarkModeColors.darkSurface,
    onSurface: DarkModeColors.darkOnSurface,
  ),
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(
    backgroundColor: DarkModeColors.darkAppBarBackground,
    foregroundColor: DarkModeColors.darkOnPrimaryContainer,
    elevation: 0,
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.playfairDisplay(fontSize: FontSizes.displayLarge, fontWeight: FontWeight.w600),
    displayMedium: GoogleFonts.playfairDisplay(fontSize: FontSizes.displayMedium, fontWeight: FontWeight.w600),
    displaySmall: GoogleFonts.playfairDisplay(fontSize: FontSizes.displaySmall, fontWeight: FontWeight.w600),
    headlineLarge: GoogleFonts.playfairDisplay(fontSize: FontSizes.headlineLarge, fontWeight: FontWeight.w600),
    headlineMedium: GoogleFonts.playfairDisplay(fontSize: FontSizes.headlineMedium, fontWeight: FontWeight.w500),
    headlineSmall: GoogleFonts.playfairDisplay(fontSize: FontSizes.headlineSmall, fontWeight: FontWeight.w500),
    titleLarge: GoogleFonts.inter(fontSize: FontSizes.titleLarge, fontWeight: FontWeight.w600),
    titleMedium: GoogleFonts.inter(fontSize: FontSizes.titleMedium, fontWeight: FontWeight.w500),
    titleSmall: GoogleFonts.inter(fontSize: FontSizes.titleSmall, fontWeight: FontWeight.w500),
    labelLarge: GoogleFonts.inter(fontSize: FontSizes.labelLarge, fontWeight: FontWeight.w500),
    labelMedium: GoogleFonts.inter(fontSize: FontSizes.labelMedium, fontWeight: FontWeight.w500),
    labelSmall: GoogleFonts.inter(fontSize: FontSizes.labelSmall, fontWeight: FontWeight.w400),
    bodyLarge: GoogleFonts.inter(fontSize: FontSizes.bodyLarge, fontWeight: FontWeight.normal),
    bodyMedium: GoogleFonts.inter(fontSize: FontSizes.bodyMedium, fontWeight: FontWeight.normal),
    bodySmall: GoogleFonts.inter(fontSize: FontSizes.bodySmall, fontWeight: FontWeight.normal),
  ),
);
