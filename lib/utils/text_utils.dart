import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colour_theme.dart';

class TextUtil {
  static TextStyle getTextStyle(TextStyleType styleType,
      {Color? color, double? fontSize, FontWeight? fontWeight}) {
    switch (styleType) {
      case TextStyleType.pageMainHeading:
        return GoogleFonts.orbitron(
          fontSize: fontSize ?? 42.0,
          fontWeight: fontWeight ?? FontWeight.bold,
          color: color ?? const Color(0xFF00E5FF), // Neon cyan
          letterSpacing: 1.5,
          shadows: [
            Shadow(
              blurRadius: 12.0,
              color: color ?? const Color(0xFF00E5FF), // Glow effect
              offset: const Offset(0, 0),
            ),
          ],
        );
      case TextStyleType.mainHeading:
        return GoogleFonts.orbitron(
          fontSize: fontSize ?? 34.0,
          fontWeight: fontWeight ?? FontWeight.bold,
          color: color ?? const Color(0xFF4DD0E1), // Electric Blue
          letterSpacing: 1.2,
          shadows: [
            Shadow(
              blurRadius: 9.0,
              color: color ?? const Color(0xFF4DD0E1),
              offset: const Offset(0, 0),
            ),
          ],
        );
      case TextStyleType.textFieldsHeading:
        return GoogleFonts.rajdhani(
          fontSize: fontSize ?? 22.0,
          fontWeight: fontWeight ?? FontWeight.w700,
          color: color ?? const Color(0xFFB0BEC5), // Subtle Gray-Blue
          letterSpacing: 1.5,
        );
      case TextStyleType.textFieldsInput:
        return GoogleFonts.robotoMono(
          fontSize: fontSize ?? 18.0,
          fontWeight: fontWeight ?? FontWeight.normal,
          color: color ?? const Color(0xFFE0E0E0), // Light Grayish-White
          letterSpacing: 1.2,
        );
      case TextStyleType.tableHeading:
        return GoogleFonts.robotoMono(
          fontSize: fontSize ?? 16.50,
          fontWeight: fontWeight ?? FontWeight.normal,
          color: color ?? const Color(0xFFE0E0E0), // Light Grayish-White
          letterSpacing: 1.2,
        );
      case TextStyleType.loginButton:
        return GoogleFonts.orbitron(
          fontSize: fontSize ?? 18.0,
          fontWeight: FontWeight.bold,
          color: color ?? Colors.white,
          letterSpacing: 2.0,
        );
      case TextStyleType.logoutButton:
        return GoogleFonts.roboto(
          fontSize: fontSize ?? 18.0,
          fontWeight: FontWeight.bold,
          color: color ?? Colors.white,
          letterSpacing: 2.0,
        );
      case TextStyleType.loginFormField:
        return GoogleFonts.robotoMono(
          fontSize: fontSize ?? 16.0,
          fontWeight: fontWeight ?? FontWeight.normal,
          color: color ?? ColorTheme.textColorPrimary,
        );
      case TextStyleType.custom:
      default:
        return GoogleFonts.roboto(
          fontSize: fontSize ?? 16.0,
          fontWeight: fontWeight ?? FontWeight.normal,
          color: color ?? ColorTheme.textColorPrimary,
        );
    }
  }

  static Widget getTextWidget(String text, TextStyleType styleType,
      {Color? color,
      double? fontSize,
      FontWeight? fontWeight,
      TextAlign textAlign = TextAlign.center}) {
    return Text(
      text,
      textAlign: textAlign,
      style: getTextStyle(styleType,
          color: color, fontSize: fontSize, fontWeight: fontWeight),
    );
  }
}

enum TextStyleType {
  pageMainHeading,
  mainHeading,
  textFieldsHeading,
  textFieldsInput,
  tableHeading,
  loginButton,
  logoutButton,
  loginFormField,
  custom,
}
