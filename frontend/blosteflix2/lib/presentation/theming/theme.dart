import 'package:blosteflix2/presentation/theming/thypography.dart';
import 'colors.dart';
import 'package:flutter/material.dart';

class BlosteTheme {
  static final ThemeData extraDarkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: BlosteColors.extraDark,
    scaffoldBackgroundColor: BlosteColors.extraDark.surface,
  );
}
