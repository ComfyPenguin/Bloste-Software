// ============================================
// MAIN APP ENTRY POINT
// ============================================
// Sets up Material Design 3 theme with dynamic colors
// Initializes the app with LaunchScreen as home

import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:frontend/presentation/screens/launch_screen.dart';

// ============================================
// THEME SEED COLOR
// ============================================
// Used to generate Material Design 3 color scheme
// Can be dynamically overridden by system colors
const seed = Color(0xFF6750A4); // Purple seed color

/**
 * Main entry point of the application
 * Creates the root widget
 */
void main() => runApp(BlosteflixApp());

/**
 * Root widget - Sets up theme and navigation
 * Uses DynamicColorBuilder for Material You support
 */
class BlosteflixApp extends StatelessWidget {
  const BlosteflixApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ============================================
    // DYNAMIC COLOR SETUP (Material You)
    // ============================================
    // Reads system color scheme if available
    // Falls back to seed-based colors if not
    // Supports light and dark themes
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDyn, ColorScheme? darkDyn) {
        // Create light color scheme from system or seed
        final ColorScheme light =
            (lightDyn?.harmonized()) ??
            ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light);

        // Create dark color scheme from system or seed
        final ColorScheme dark =
            (darkDyn?.harmonized()) ??
            ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark);

        // ============================================
        // MATERIAL APP CONFIGURATION
        // ============================================
        return MaterialApp(
          debugShowCheckedModeBanner: false, // Hide debug banner
          themeMode: ThemeMode.system, // Use system theme preference
          theme: ThemeData(useMaterial3: true, colorScheme: light),
          darkTheme: ThemeData(useMaterial3: true, colorScheme: dark),
          home: LaunchScreen(), // First screen to show
        );
      },
    );
  }
}
