import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'model_theme.dart';
import 'themes.dart';

enum CustomMode { light, dark }

String getThemeModeString(CustomMode mode) {
  switch (mode) {
    case CustomMode.dark:
      return "Dark";
    case CustomMode.light:
      return "Light";
    }
}

CustomMode getThemeMode(String mode) {
  switch (mode) {
    case "Dark":
      return CustomMode.dark;
    case "Light":
      return CustomMode.light;
    default:
      return CustomMode.light;
  }
}

SystemUiOverlayStyle lightTheme = SystemUiOverlayStyle.light.copyWith(
    systemNavigationBarColor: lightModel.backgroundPrimary,
    systemNavigationBarDividerColor: lightModel.backgroundPrimary,
    statusBarColor: lightModel.backgroundPrimary,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarContrastEnforced: true,
    systemStatusBarContrastEnforced: true);

SystemUiOverlayStyle darkTheme = SystemUiOverlayStyle.dark.copyWith(
    systemNavigationBarColor: darkModel.backgroundPrimary,
    systemNavigationBarDividerColor: darkModel.backgroundPrimary,
    statusBarColor: darkModel.backgroundPrimary,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light,
    systemNavigationBarContrastEnforced: true,
    systemStatusBarContrastEnforced: true);

class CustomTheme extends ChangeNotifier {
  CustomMode themeMode = CustomMode.dark;
  ThemeData currentTheme = light();
  static ModelTheme modelTheme = lightModel;

  CustomTheme({required this.themeMode}) {
    toggleTheme(themeMode);
  }

  toggleTheme(CustomMode themeType) {
    switch (themeType) {
      case CustomMode.dark:
        {
          currentTheme = dark();
          themeType = themeType;
          modelTheme = darkModel;
          return notifyListeners();
        }
      case CustomMode.light:
        {
          currentTheme = light();
          themeType = themeType;
          modelTheme = lightModel;
          return notifyListeners();
        }
      }
  }
}
