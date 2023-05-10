// ignore_for_file: overridden_fields, annotate_overrides

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shared_preferences/shared_preferences.dart';

const kThemeModeKey = '__theme_mode__';
SharedPreferences? _prefs;

abstract class FlutterFlowTheme {
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();
  static ThemeMode get themeMode {
    final darkMode = _prefs?.getBool(kThemeModeKey);
    return darkMode == null
        ? ThemeMode.system
        : darkMode
            ? ThemeMode.dark
            : ThemeMode.light;
  }

  static void saveThemeMode(ThemeMode mode) => mode == ThemeMode.system
      ? _prefs?.remove(kThemeModeKey)
      : _prefs?.setBool(kThemeModeKey, mode == ThemeMode.dark);

  static FlutterFlowTheme of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? DarkModeTheme()
          : DarkModeTheme();
//TODO - explore light mode
  ///LightModeTheme();

  late Color primaryColor;
  late Color primaryColorDark;
  late Color primaryColorLight;
  late Color secondaryColor;
  late Color secondaryColorDark;
  late Color secondaryColorLight;
  late Color tertiaryColor;
  late Color tertiaryColorDark;
  late Color tertiaryColorLight;
  late Color alternate;
  late Color alternateDark;
  late Color alternateLight;
  late Color primaryBackground;
  late Color primaryBackgroundDark;
  late Color primaryBackgroundLight;
  late Color secondaryBackground;
  late Color secondaryBackgroundDark;
  late Color secondaryBackgroundLight;
  late Color primaryText;
  late Color primaryTextDark;
  late Color primaryTextLight;
  late Color secondaryText;
  late Color secondaryTextDark;
  late Color secondaryTextLight;
  late Color primaryBtnText;
  late Color lineColor;
  late Color grayIcon;
  late Color grayIconDark;
  late Color grayIconLight;
  late Color gray200;
  late Color gray200Dark;
  late Color gray200Light;
  late Color gray600;
  late Color gray600Dark;
  late Color gray600Light;
  late Color black600;
  late Color black600Dark;
  late Color black600Light;
  late Color tertiary400;
  late Color tertiary400Dark;
  late Color tertiary400Light;
  late Color textColor;
  late Color textColorDark;
  late Color textColorLight;
  late Color backgroundComponents;
  late Color backgroundComponentsDark;
  late Color backgroundComponentsLight;
  late Color buttonGreen;
  late Color buttonRed;

  String get title1Family => typography.title1Family;
  TextStyle get title1 => typography.title1;
  String get title2Family => typography.title2Family;
  TextStyle get title2 => typography.title2;
  String get title3Family => typography.title3Family;
  TextStyle get title3 => typography.title3;
  String get subtitle1Family => typography.subtitle1Family;
  TextStyle get subtitle1 => typography.subtitle1;
  String get subtitle2Family => typography.subtitle2Family;
  TextStyle get subtitle2 => typography.subtitle2;
  String get bodyText1Family => typography.bodyText1Family;
  TextStyle get bodyText1 => typography.bodyText1;
  String get bodyText2Family => typography.bodyText2Family;
  TextStyle get bodyText2 => typography.bodyText2;

  Typography get typography => ThemeTypography(this);
}

class LightModeTheme extends FlutterFlowTheme {
  late Color primaryColor = const Color(0xFF96669E);
  late Color primaryColorDark = const Color(0xFF684162);
  late Color primaryColorLight = const Color(0xFFC29FB8);

  late Color secondaryColor = const Color(0xFF39D2C0);
  late Color secondaryColorDark = const Color(0xFF1D8C84);
  late Color secondaryColorLight = const Color(0xFF8BE9DE);

  late Color tertiaryColor = const Color(0xFFEE8B60);
  late Color tertiaryColorDark = const Color(0xFFD66E41);
  late Color tertiaryColorLight = const Color(0xFFFFA17C);

  late Color alternate = const Color(0xFFFF5963);
  late Color alternateDark = const Color(0xFFD43542);
  late Color alternateLight = const Color(0xFFFF8493);

  late Color primaryBackground = const Color(0xFFFFFFFF);
  late Color primaryBackgroundDark = const Color(0xFFE8E8E8);
  late Color primaryBackgroundLight = const Color(0xFFFFFFFF);

  late Color secondaryBackground = const Color(0xFFF5F5F5);
  late Color secondaryBackgroundDark = const Color(0xFFE1E1E1);
  late Color secondaryBackgroundLight = const Color(0xFFF8F8F8);

  late Color primaryText = const Color(0xFF1E2429);
  late Color primaryTextDark = const Color(0xFF1E2429);
  late Color primaryTextLight = const Color(0xFFFFFFFF);

  late Color secondaryText = const Color(0xFF95A1AC);
  late Color secondaryTextDark = const Color(0xFF74808A);
  late Color secondaryTextLight = const Color(0xFFA9B9C2);

  late Color buttonGreen = Color(0xFF80D3A2);
  late Color buttonRed = Color(0xFFC9685D);

  late Color primaryBtnText = Color(0xFFFFFFFF);
  late Color lineColor = Color(0xFF22282F);
  late Color grayIcon = Color(0xFFC9D0D6);
  late Color grayIconDark = Color(0xFF95A1AC);
  late Color grayIconLight = Color(0xFFE0E6EB);
  late Color gray200 = Color(0xFFE7EEF3);
  late Color gray200Dark = Color(0xFFB6C3CC);
  late Color gray200Light = Color(0xFFF3F7FA);
  late Color gray600 = Color(0xFF363C44);
  late Color gray600Dark = Color(0xFF262D34);
  late Color gray600Light = Color(0xFF49545E);
  late Color black600 = Color(0xFF1E2429);
  late Color black600Dark = Color(0xFF090F13);
  late Color black600Light = Color(0xFF3E4852);
  late Color tertiary400 = Color(0xFF39D2C0);
  late Color tertiary400Dark = Color(0xFF1D8C84);
  late Color tertiary400Light = Color(0xFF8BE9DE);
  late Color textColor = Color(0xFF1E2429);
  late Color backgroundComponents = Color(0xFF1D2428);
}

class DarkModeTheme extends FlutterFlowTheme {
  late Color primaryColor = Color.fromARGB(255, 163, 120, 171);
  late Color primaryColorDark = const Color(0xFF684162);
  late Color primaryColorLight = Color.fromARGB(255, 209, 172, 199);

  late Color secondaryColor = const Color(0xFF39D2C0);
  late Color secondaryColorDark = const Color(0xFF1D8C84);
  late Color secondaryColorLight = Color.fromARGB(255, 181, 221, 216);

  late Color tertiaryColor = const Color(0xFFEE8B60);
  late Color tertiaryColorDark = const Color(0xFFD66E41);
  late Color tertiaryColorLight = const Color(0xFFFFA17C);

  late Color alternate = const Color(0xFFFF5963);
  late Color alternateDark = const Color(0xFFD43542);
  late Color alternateLight = const Color(0xFFFF8493);

  late Color primaryBackground = const Color(0xFF1E1E1E);
  late Color primaryBackgroundDark = const Color(0xFF141414);
  late Color primaryBackgroundLight = const Color(0xFF272727);

  late Color secondaryBackground = const Color(0xFF313131);
  late Color secondaryBackgroundDark = const Color(0xFF252525);
  late Color secondaryBackgroundLight = const Color(0xFF3B3B3B);

  late Color primaryText = const Color(0xFFFFFFFF);
  late Color primaryTextDark = const Color(0xFFE8E8E8);
  late Color primaryTextLight = const Color(0xFFFFFFFF);

  late Color secondaryText = const Color(0xFF95A1AC);
  late Color secondaryTextDark = const Color(0xFF74808A);
  late Color secondaryTextLight = const Color(0xFFA9B9C2);

  late Color buttonGreen = Color(0xFF80D3A2);
  late Color buttonRed = Color(0xFFC9685D);

  late Color primaryBtnText = Color(0xFFFFFFFF);
  late Color lineColor = Color(0xFF22282F);
  late Color grayIcon = Color(0xFF95A1AC);
  late Color grayIconDark = Color(0xFF74808A);
  late Color grayIconLight = Color(0xFFA9B9C2);
  late Color gray200 = Color(0xFFDBE2E7);
  late Color gray200Dark = Color(0xFFB6C3CC);
  late Color gray200Light = Color(0xFFE7EEF3);
  late Color gray600 = Color(0xFF262D34);
  late Color gray600Dark = Color(0xFF1B2025);
  late Color gray600Light = Color(0xFF363C44);
  late Color black600 = Color(0xFF090F13);
  late Color black600Dark = Color(0xFF030405);
  late Color black600Light = Color(0xFF1E2429);
  late Color tertiary400 = Color(0xFF39D2C0);
  late Color tertiary400Dark = Color(0xFF1D8C84);
  late Color tertiary400Light = Color(0xFF8BE9DE);
  late Color textColor = Color(0xFF1E2429);
  late Color backgroundComponents = Color(0xFF1D2428);
}

abstract class Typography {
  String get title1Family;
  TextStyle get title1;
  String get title2Family;
  TextStyle get title2;
  String get title3Family;
  TextStyle get title3;
  String get subtitle1Family;
  TextStyle get subtitle1;
  String get subtitle2Family;
  TextStyle get subtitle2;
  String get bodyText1Family;
  TextStyle get bodyText1;
  String get bodyText2Family;
  TextStyle get bodyText2;
}

class ThemeTypography extends Typography {
  ThemeTypography(this.theme);

  final FlutterFlowTheme theme;

  String get title1Family => 'Poppins';
  TextStyle get title1 => GoogleFonts.getFont(
        'Poppins',
        color: theme.primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 40,
      );
  String get title2Family => 'Poppins';
  TextStyle get title2 => GoogleFonts.getFont(
        'Poppins',
        color: theme.secondaryText,
        fontWeight: FontWeight.w600,
        fontSize: 22,
      );
  String get title3Family => 'Poppins';
  TextStyle get title3 => GoogleFonts.getFont(
        'Poppins',
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      );
  String get subtitle1Family => 'Poppins';
  TextStyle get subtitle1 => GoogleFonts.getFont(
        'Poppins',
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      );
  String get subtitle2Family => 'Poppins';
  TextStyle get subtitle2 => GoogleFonts.getFont(
        'Poppins',
        color: theme.secondaryText,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      );
  String get bodyText1Family => 'Poppins';
  TextStyle get bodyText1 => GoogleFonts.getFont(
        'Poppins',
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      );
  String get bodyText2Family => 'Poppins';
  TextStyle get bodyText2 => GoogleFonts.getFont(
        'Poppins',
        color: theme.secondaryText,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      );
}

extension TextStyleHelper on TextStyle {
  TextStyle override({
    String? fontFamily,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    FontStyle? fontStyle,
    bool useGoogleFonts = true,
    TextDecoration? decoration,
    double? lineHeight,
  }) =>
      useGoogleFonts
          ? GoogleFonts.getFont(
              fontFamily!,
              color: color ?? this.color,
              fontSize: fontSize ?? this.fontSize,
              letterSpacing: letterSpacing ?? this.letterSpacing,
              fontWeight: fontWeight ?? this.fontWeight,
              fontStyle: fontStyle ?? this.fontStyle,
              decoration: decoration,
              height: lineHeight,
            )
          : copyWith(
              fontFamily: fontFamily,
              color: color,
              fontSize: fontSize,
              letterSpacing: letterSpacing,
              fontWeight: fontWeight,
              fontStyle: fontStyle,
              decoration: decoration,
              height: lineHeight,
            );
}
