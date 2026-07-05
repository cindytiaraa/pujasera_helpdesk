import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryColor = Color(0xFF1A73E8);
  static const Color primaryDark = Color(0xFF1558B0);
  static const Color accentColor = Color(0xFFFF6B35);
  static const Color successColor = Color(0xFF34A853);
  static const Color warningColor = Color(0xFFFBBC05);
  static const Color errorColor = Color(0xFFEA4335);
  static const Color infoColor = Color(0xFF4FC3F7);

  // Status Colors
  static const Color pendingColor = Color(0xFFFBBC05);
  static const Color processColor = Color(0xFF1A73E8);
  static const Color doneColor = Color(0xFF34A853);
  static const Color cancelledColor = Color(0xFFEA4335);

  // Priority Colors
  static const Color priorityLow = Color(0xFF34A853);
  static const Color priorityMedium = Color(0xFFFBBC05);
  static const Color priorityHigh = Color(0xFFEA4335);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
      primary: primaryColor,
      secondary: accentColor,
      error: errorColor,
      surface: Colors.white,
      background: const Color(0xFFF5F7FB),
    ),
    scaffoldBackgroundColor: const Color(0xFFF5F7FB),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF1A1A2E),
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Color(0xFF1A1A2E),
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      iconTheme: IconThemeData(color: Color(0xFF1A1A2E)),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade100),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor, width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
    ),
    dividerTheme: DividerThemeData(
      color: Colors.grey.shade100,
      thickness: 1,
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: Color(0xFF9E9E9E),
      elevation: 8,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontSize: 11),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
      primary: const Color(0xFF4D9FFF),
      secondary: accentColor,
      error: errorColor,
      surface: const Color(0xFF1E1E2E),
      background: const Color(0xFF12121E),
    ),
    scaffoldBackgroundColor: const Color(0xFF12121E),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E2E),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1E1E2E),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF2A2A3E)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4D9FFF),
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF4D9FFF),
        side: const BorderSide(color: Color(0xFF4D9FFF), width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2A2A3E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF3A3A4E)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF3A3A4E)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF4D9FFF), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: const TextStyle(color: Color(0xFF9E9EB8), fontSize: 14),
      hintStyle: const TextStyle(color: Color(0xFF6E6E8E), fontSize: 14),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF2A2A3E),
      thickness: 1,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E2E),
      selectedItemColor: Color(0xFF4D9FFF),
      unselectedItemColor: Color(0xFF6E6E8E),
      elevation: 8,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontSize: 11),
    ),
  );

  // Helper: get status color
  static Color getStatusColor(String status) {
    switch (status) {
      // Status baru (business flow)
      case 'Open':
        return pendingColor;
      case 'Assigned':
        return const Color(0xFF9C27B0); // purple
      case 'In Progress':
        return processColor;
      case 'Close':
        return doneColor;
      // Status lama (backward compatibility)
      case 'Pending':
        return pendingColor;
      case 'Diproses':
        return processColor;
      case 'Selesai':
        return doneColor;
      case 'Dibatalkan':
        return cancelledColor;
      default:
        return Colors.grey;
    }
  }

  // Helper: get priority color
  static Color getPriorityColor(String priority) {
    switch (priority) {
      case 'Rendah':
        return priorityLow;
      case 'Sedang':
        return priorityMedium;
      case 'Tinggi':
        return priorityHigh;
      default:
        return Colors.grey;
    }
  }
}
