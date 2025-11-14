import 'package:flutter/material.dart';

import 'custom_theme.dart';

class ModelTheme {
  final Color backgroundPrimary;
  final Color backgroundSecondary;
  final Color fontPrimary;
  final Color fontSecondary;
  final Color pacificBlue;
  final Color grey;
  final CustomMode mode;

  ModelTheme(
    this.mode, {
    required this.backgroundPrimary,
    required this.backgroundSecondary,
    required this.fontPrimary,
    required this.fontSecondary,
    required this.pacificBlue,
    required this.grey,
  });

  ModelTheme copyWith({
    Color? backgroundPrimary,
    Color? fontPrimary,
    Color? fontSecondary,
    Color? pacificBlue,
    Color? backgroundSecondary,
    Color? grey,
  }) {
    return ModelTheme(
      mode,
      backgroundPrimary: backgroundPrimary ?? this.backgroundPrimary,
      fontPrimary: fontPrimary ?? this.fontPrimary,
      fontSecondary: fontSecondary ?? this.fontSecondary,
      pacificBlue: pacificBlue ?? this.pacificBlue,
      backgroundSecondary: backgroundSecondary ?? this.backgroundSecondary,
      grey: grey ?? this.grey,
    );
  }
}

ModelTheme lightModel = ModelTheme(
  CustomMode.light,
  backgroundPrimary: const Color(0xFFFFFFFF),
  fontPrimary: const Color(0xFF000000),
  fontSecondary: const Color(0xFFFFFFFF),
  pacificBlue: const Color(0xFF0082FF),
  backgroundSecondary: Color(0xFFF5F5F5),
  grey: Color(0xFFD9D9D9),
);

ModelTheme darkModel = ModelTheme(
  CustomMode.dark,
  backgroundPrimary: const Color(0xFF0E0F12),
  fontPrimary: const Color(0xFFF1F1F1),
  fontSecondary: const Color(0xFF000000),
  pacificBlue: const Color(0xFF0082FF),
  backgroundSecondary: Color(0xFFF5F5F5),
  grey: Color(0xFFD9D9D9),
);
