import 'package:flutter/material.dart';

class BlosteColors {
/*   // Colores principales
  static const Color primary = Color(0xFFEA580C);
  static const Color primaryContainer = Color(0xFFFFA726);

  static const Color secondary = Color(0xFF8B5CF6);
  static const Color secondaryContainer = Color(0xFFC4B5FD);

  static const Color tertiary = Color(0xFF7C3AED);
  static const Color tertiaryContainer = Color(0xFFDDD6FE);

  // Fondos y superficies
  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF121212);
  static const Color surfaceVariant = Color(0xFF1E1E1E);

  // Errores / contrastes
  static const Color error = Colors.red;
  static const Color onPrimary = Colors.black;
  static const Color onSecondary = Colors.black;
  static const Color onSurface = Colors.white;
  static const Color onBackground = Colors.white; */

  static final ColorScheme extraDark = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFEA580C),
  onPrimary: Colors.black,
  primaryContainer: Color(0xFFFFB74D),
  onPrimaryContainer: Colors.black,
  secondary: Color(0xFF8B5CF6),
  onSecondary: Colors.white,
  secondaryContainer: Color(0xFFC4B5FD),
  onSecondaryContainer: Colors.black,
  tertiary: Color(0xFF7C3AED),
  onTertiary: Colors.white,
  tertiaryContainer: Color(0xFFDDD6FE),
  onTertiaryContainer: Colors.black,
  surface: Color(0xFF121212),
  onSurface: Colors.white,
  surfaceContainerHighest: Color(0xFF1E1E1E),
  onSurfaceVariant: Colors.white70,
  error: Colors.red,
  onError: Colors.white,
  errorContainer: Colors.red.shade700,
  onErrorContainer: Colors.white,
  outline: Colors.grey,
  shadow: Colors.black,
  inverseSurface: Colors.white,
  onInverseSurface: Colors.black,
  inversePrimary: Color(0xFFFFB74D),
  );
  
  static final ColorScheme dark = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFFFA726), // naranja más claro
  onPrimary: Colors.black,
  primaryContainer: Color(0xFFFFD54F),
  onPrimaryContainer: Colors.black,
  secondary: Color(0xFF9D7EFE), // violeta más suave
  onSecondary: Colors.white,
  secondaryContainer: Color(0xFFD7BBFF),
  onSecondaryContainer: Colors.black,
  tertiary: Color(0xFF9C4DFF),
  onTertiary: Colors.white,
  tertiaryContainer: Color(0xFFE6D6FF),
  onTertiaryContainer: Colors.black,// oscuro pero no negro puro
  surface: Color(0xFF242424),
  surfaceContainerHighest: Color(0xFF1E1E1E),
  onSurface: Colors.white70,
  onSurfaceVariant: Colors.white60,
  error: Colors.redAccent,
  onError: Colors.white,
  errorContainer: Colors.red.shade400,
  onErrorContainer: Colors.white,
  outline: Colors.grey.shade500,
  shadow: Colors.black,
  inverseSurface: Colors.white,
  onInverseSurface: Colors.black,
  inversePrimary: Color(0xFFFFD54F),
);
  static final ColorScheme light = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFFEA580C),
  onPrimary: Colors.white,
  primaryContainer: Color(0xFFFFB74D),
  onPrimaryContainer: Colors.black,
  secondary: Color(0xFF8B5CF6),
  onSecondary: Colors.white,
  secondaryContainer: Color(0xFFC4B5FD),
  onSecondaryContainer: Colors.black,
  tertiary: Color(0xFF7C3AED),
  onTertiary: Colors.white,
  tertiaryContainer: Color(0xFFDDD6FE),
  onTertiaryContainer: Colors.black,
  surface: Colors.white,
  onSurface: Colors.black,
  surfaceContainerHighest: Color(0xFFF1F1F1),
  onSurfaceVariant: Colors.black54,
  error: Colors.red,
  onError: Colors.white,
  errorContainer: Colors.red.shade200,
  onErrorContainer: Colors.black,
  outline: Colors.grey,
  shadow: Colors.black,
  inverseSurface: Colors.black,
  onInverseSurface: Colors.white,
  inversePrimary: Color(0xFFFFA726),
);

}