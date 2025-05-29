import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTheme {
  static TextTheme textTheme = GoogleFonts.robotoTextTheme(
    TextTheme(
      displayLarge: TextStyle(fontSize: 96.0, fontWeight: FontWeight.w300, letterSpacing: -1.5),
      displayMedium: TextStyle(fontSize: 60.0, fontWeight: FontWeight.w300, letterSpacing: -0.5),
      displaySmall: TextStyle(fontSize: 48.0, fontWeight: FontWeight.w400),
      headlineLarge: TextStyle(fontSize: 34.0, fontWeight: FontWeight.w400, letterSpacing: 0.25),
      headlineMedium: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w400),
      headlineSmall: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500, letterSpacing: 0.15),
      titleLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, letterSpacing: 0.15),
      titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, letterSpacing: 0.1),
      bodyLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
      bodySmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400),
      labelLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
      labelMedium: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
      labelSmall: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w500),
    ),
  );
  static final lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF417AA1),
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFB8D9F6),
    onPrimaryContainer: Color(0xFF0C2C3F),

    secondary: Color(0xFF5B7284),
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFD6E4F0),
    onSecondaryContainer: Color(0xFF1B2E3A),

    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF1A1C1E),
    surfaceContainer: Color(0xFFF5F5F5),

    outline: Color(0xFFB0B0B0),

    error: Color(0xFFB3261E),
    onError: Colors.white,
    errorContainer: Color(0xFFF9DEDC),
    onErrorContainer: Color(0xFF410E0B),
  );
  static final darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF9ACDF0),
    onPrimary: Color(0xFF00334F),
    primaryContainer: Color(0xFF2B5D7B),
    onPrimaryContainer: Color(0xFFB8D9F6),

    secondary: Color(0xFFBBC8D6),
    onSecondary: Color(0xFF263A47),
    secondaryContainer: Color(0xFF3E5364),
    onSecondaryContainer: Color(0xFFD6E4F0),

    surface: Color(0xFF1C1F23),
    onSurface: Color(0xFFE1E1E5),
    surfaceContainer: Color(0xFF2A2D31),

    outline: Color(0xFF8A8A8A),

    error: Color(0xFFF2B8B5),
    onError: Color(0xFF601410),
    errorContainer: Color(0xFF8C1D18),
    onErrorContainer: Color(0xFFF9DEDC),
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    textTheme: textTheme.apply(bodyColor: Colors.black, displayColor: Colors.black),
    appBarTheme: AppBarTheme(
      color: lightColorScheme.surface,
      iconTheme: IconThemeData(color: lightColorScheme.onSurface),
      titleTextStyle: textTheme.headlineSmall?.copyWith(color: lightColorScheme.onSurface),
    ),
    scaffoldBackgroundColor: lightColorScheme.surface,
    cardColor: lightColorScheme.surfaceContainer,
    dividerColor: lightColorScheme.outline,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightColorScheme.primary,
        foregroundColor: lightColorScheme.onPrimary,
        textStyle: textTheme.labelLarge,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: lightColorScheme.primaryContainer,
      foregroundColor: lightColorScheme.onPrimaryContainer,
      extendedTextStyle: textTheme.labelLarge?.copyWith(color: lightColorScheme.onPrimary),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: lightColorScheme.onPrimary,
      unselectedItemColor: lightColorScheme.onSurface,
      selectedLabelStyle: textTheme.labelLarge?.copyWith(color: lightColorScheme.primary),
      unselectedLabelStyle: textTheme.labelLarge?.copyWith(color: lightColorScheme.onSurface),
    ),
    searchBarTheme: SearchBarThemeData(
      backgroundColor: WidgetStateProperty.all(lightColorScheme.surfaceContainer),
      textStyle: WidgetStateProperty.all(textTheme.bodyLarge?.copyWith(color: lightColorScheme.onSurface)),
      hintStyle: WidgetStateProperty.all(
        textTheme.bodyMedium?.copyWith(color: lightColorScheme.onSurface.withValues(alpha: 0.6)),
      ),
      elevation: WidgetStateProperty.all(2),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(color: lightColorScheme.outline, width: 1.0),
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: lightColorScheme.surfaceContainer,
      selectedColor: lightColorScheme.primaryContainer,
      secondarySelectedColor: lightColorScheme.secondaryContainer,
      iconTheme: IconThemeData(color: lightColorScheme.onSurface),
      deleteIconColor: lightColorScheme.error,
      labelStyle: textTheme.labelLarge?.copyWith(color: lightColorScheme.onSurface),
      secondaryLabelStyle: textTheme.labelLarge?.copyWith(color: lightColorScheme.onSecondary),
      padding: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: textTheme.bodyLarge?.copyWith(color: lightColorScheme.onSurface),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightColorScheme.surfaceContainer,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: lightColorScheme.outline, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: lightColorScheme.primary, width: 2.0),
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: lightColorScheme.onSurface.withValues(alpha: 0.6)),
      ),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(lightColorScheme.surfaceContainer),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: BorderSide(color: lightColorScheme.outline, width: 1.0),
          ),
        ),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: lightColorScheme.surfaceContainer,
      titleTextStyle: textTheme.headlineSmall?.copyWith(color: lightColorScheme.onSurface),
      contentTextStyle: textTheme.bodyLarge?.copyWith(color: lightColorScheme.onSurface),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: lightColorScheme.surfaceContainer, width: 1.0),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightColorScheme.surfaceContainer,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: BorderSide(color: lightColorScheme.outline, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: BorderSide(color: lightColorScheme.primary, width: 2.0),
      ),
      hintStyle: textTheme.bodyMedium?.copyWith(color: lightColorScheme.onSurface.withValues(alpha: 0.6)),
    ),
    colorScheme: lightColorScheme,
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    textTheme: textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white),
    appBarTheme: AppBarTheme(
      color: darkColorScheme.surface,
      iconTheme: IconThemeData(color: darkColorScheme.onSurface),
      titleTextStyle: textTheme.headlineSmall?.copyWith(color: darkColorScheme.onSurface),
    ),
    scaffoldBackgroundColor: darkColorScheme.surface,
    cardColor: darkColorScheme.surfaceContainer,
    dividerColor: darkColorScheme.outline,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkColorScheme.primary,
        foregroundColor: darkColorScheme.onPrimary,
        textStyle: textTheme.labelLarge,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: darkColorScheme.primaryContainer,
      foregroundColor: darkColorScheme.onPrimaryContainer,
      extendedTextStyle: textTheme.labelLarge?.copyWith(color: darkColorScheme.onPrimary),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: darkColorScheme.onPrimary,
      unselectedItemColor: darkColorScheme.onSurface,
      selectedLabelStyle: textTheme.labelLarge?.copyWith(color: darkColorScheme.primary),
      unselectedLabelStyle: textTheme.labelLarge?.copyWith(color: darkColorScheme.onSurface),
    ),
    searchBarTheme: SearchBarThemeData(
      backgroundColor: WidgetStateProperty.all(darkColorScheme.surfaceContainer),
      textStyle: WidgetStateProperty.all(textTheme.bodyLarge?.copyWith(color: darkColorScheme.onSurface)),
      hintStyle: WidgetStateProperty.all(
        textTheme.bodyMedium?.copyWith(color: darkColorScheme.onSurface.withValues(alpha: 0.6)),
      ),
      elevation: WidgetStateProperty.all(2),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(color: darkColorScheme.outline, width: 1.0),
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: darkColorScheme.surfaceContainer,
      selectedColor: darkColorScheme.primaryContainer,
      secondarySelectedColor: darkColorScheme.secondaryContainer,
      iconTheme: IconThemeData(color: darkColorScheme.onSurface),
      deleteIconColor: darkColorScheme.error,
      labelStyle: textTheme.labelLarge?.copyWith(color: darkColorScheme.onSurface),
      secondaryLabelStyle: textTheme.labelLarge?.copyWith(color: darkColorScheme.onSecondary),
      padding: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: textTheme.bodyLarge?.copyWith(color: darkColorScheme.onSurface),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkColorScheme.surfaceContainer,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: darkColorScheme.outline, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: darkColorScheme.primary, width: 2.0),
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: darkColorScheme.onSurface.withValues(alpha: 0.6)),
      ),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(darkColorScheme.surfaceContainer),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: BorderSide(color: darkColorScheme.outline, width: 1.0),
          ),
        ),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: darkColorScheme.surfaceContainer,
      titleTextStyle: textTheme.headlineSmall?.copyWith(color: darkColorScheme.onSurface),
      contentTextStyle: textTheme.bodyLarge?.copyWith(color: darkColorScheme.onSurface),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: darkColorScheme.surfaceContainer, width: 1.0),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkColorScheme.surfaceContainer,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: BorderSide(color: darkColorScheme.outline, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: BorderSide(color: darkColorScheme.primary, width: 2.0),
      ),
      hintStyle: textTheme.bodyMedium?.copyWith(color: darkColorScheme.onSurface.withValues(alpha: 0.6)),
    ),
    colorScheme: darkColorScheme,
  );
}
