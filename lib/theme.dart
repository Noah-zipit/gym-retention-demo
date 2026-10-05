import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// RetainFit design system — dark, premium, high-energy gym aesthetic.
class AppTheme {
  // Palette
  static const bg = Color(0xFF0A0D12);
  static const bgDeep = Color(0xFF06080C);
  static const surface = Color(0xFF121823);
  static const card = Color(0xFF151D2A);
  static const cardEdge = Color(0x26FFFFFF); // hairline
  static const volt = Color(0xFFC8FF3D); // primary energy accent
  static const voltDim = Color(0xFF9DC22E);
  static const danger = Color(0xFFFF5D5D);
  static const warning = Color(0xFFFFB224);
  static const success = Color(0xFF3ED598);
  static const info = Color(0xFF5AA9FF);
  static const textPrimary = Color(0xFFF4F7F2);
  static const textSecondary = Color(0xFF8B95A9);
  static const textFaint = Color(0xFF5A6478);

  static TextStyle display(double size, {Color? color, double? height}) =>
      GoogleFonts.archivo(
        fontSize: size,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        height: height ?? 1.05,
        color: color ?? textPrimary,
      );

  static TextStyle title(double size, {Color? color}) => GoogleFonts.archivo(
        fontSize: size,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        color: color ?? textPrimary,
      );

  static TextStyle body(double size,
          {Color? color, FontWeight? weight, double? height}) =>
      GoogleFonts.inter(
        fontSize: size,
        fontWeight: weight ?? FontWeight.w400,
        height: height ?? 1.45,
        color: color ?? textSecondary,
      );

  static TextStyle mono(double size, {Color? color}) => GoogleFonts.inter(
        fontSize: size,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
        color: color ?? textPrimary,
      );

  static ThemeData theme() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: bg,
      colorScheme: base.colorScheme.copyWith(
        primary: volt,
        secondary: volt,
        surface: surface,
        error: danger,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xE60D1119),
        selectedItemColor: volt,
        unselectedItemColor: textFaint,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: card,
        contentTextStyle: body(14, color: textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
