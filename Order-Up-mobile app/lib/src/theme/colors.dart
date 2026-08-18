import 'package:flutter/material.dart';

class AppColor {
  static const Color primaryColor = Color(0xff22BB9B);
  static const Color accentColor = Color(0xFFFF9012);
  static const Color lightAccentColor = Color(0xFFFFD8BC);
  static const Color blueColor = Color.fromRGBO(93, 173, 226, 1);
  static const Color blackColor = Color(0xFF16161E);
  static const Color blackColor80 = Color(0xFF45454B);
  static const Color blackColor60 = Color(0xFF737378);
  static const Color blackColor40 = Color(0xFFA2A2A5);
  static const Color blackColor20 = Color(0xFFD0D0D2);
  static const Color blackColor10 = Color(0xFFE8E8E9);
  static const Color blackColor5 = Color(0xFFF3F3F4);
  static const Color bgColor = Color(0xff000029);
  static const Color successColor = Color(0xFF2ED573);
  static const Color warningColor = Color(0xFFFFBE21);
  static const Color errorColor = Color(0xFFEA5B5B);
  static const Color greyColor = Color(0xFFB8B5C3);
  static const Color scaleGreyColor = Color(0xFFF3F3F3);
  static const Color lightGreyColor = Color(0xFFF8F8F9);
  static const Color darkGreyColor = Color(0xFF1C1C25);
  static const Color kShadowColor = Color(0xFFE6E6E6);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color whiteColor50 = Color(0x88FFFFFF);
  static const Color greyDarkColor = Color(0xFFEAEAEA);
  static const Color textColor = Color(0xFF000000);
  static const Color textColor50 = Color(0x88000000);

  /// HexColor: #191919 - Lighter black for accent backgrounds
  static const Color lighterBlack = Color(0xFF191919);

  static Color getShade(Color color, {bool darker = false, double value = .1}) {
    assert(value >= 0 && value <= 1);

    final HSLColor hsl = HSLColor.fromColor(color);
    final HSLColor hslDark = hsl.withLightness(
        (darker ? (hsl.lightness - value) : (hsl.lightness + value))
            .clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static MaterialColor getMaterialColorFromColor(Color color) {
    final Map<int, Color> colorShades = {
      50: getShade(color, value: 0.5),
      100: getShade(color, value: 0.4),
      200: getShade(color, value: 0.3),
      300: getShade(color, value: 0.2),
      400: getShade(color, value: 0.1),
      500: color, //Primary value
      600: getShade(color, value: 0.1, darker: true),
      700: getShade(color, value: 0.15, darker: true),
      800: getShade(color, value: 0.2, darker: true),
      900: getShade(color, value: 0.25, darker: true),
    };
    return MaterialColor(color.value, colorShades);
  }
}
