import 'package:flutter/material.dart';

import 'custom_theme.dart';
import 'model_theme.dart';


enum FontColor { White, FontPrimary, FontSecondary, PacificBlue, grey, red }

enum FontStyle {
  HeaderL_SemiBold,
  HeaderM_SemiBold,
  HeaderS_SemiBold,
  HeaderXS_SemiBold,
  BodyXL_SemiBold,
  BodyL_SemiBold,
  BodyM_SemiBold,
  BodyS_SemiBold,
  TagNameL_SemiBold,
  TagNameS_SemiBold,
  BodyL_ItalicBold,
}

ModelTheme customColors() {
  return CustomTheme.modelTheme;
}

TextStyle customTextStyle({required FontStyle fontStyle, FontColor? color}) {
  switch (fontStyle) {
    case FontStyle.HeaderL_SemiBold:
      return TextStyle(
        fontSize: 48,
        color: getFontColor(color),
        letterSpacing: 0,
        fontFamily: "DMSansSemiBold",
        fontWeight: FontWeight.w600,
      );

    case FontStyle.HeaderM_SemiBold:
      return TextStyle(
        fontSize: 40,
        color: getFontColor(color),
        letterSpacing: 0,
        fontFamily: "DMSansSemiBold",
        fontWeight: FontWeight.w600,
      );
    case FontStyle.BodyXL_SemiBold:
      return TextStyle(
        fontSize: 24,
        color: getFontColor(color),
        letterSpacing: 0,
        fontFamily: "DMSansSemiBold",
        fontWeight: FontWeight.w600,
      );
    case FontStyle.HeaderS_SemiBold:
      return TextStyle(
        fontSize: 20,
        color: getFontColor(color),
        letterSpacing: 0,
        fontFamily: "DMSansSemiBold",
        fontWeight: FontWeight.w600,
      );

    case FontStyle.HeaderXS_SemiBold:
      return TextStyle(
        fontSize: 16,
        color: getFontColor(color),
        letterSpacing: 0,
        fontFamily: "DMSansSemiBold",
        fontWeight: FontWeight.w600,
      );

    case FontStyle.BodyL_SemiBold:
      return TextStyle(
        fontSize: 14,
        color: getFontColor(color),
        letterSpacing: 0,
        fontFamily: "DMSansSemiBold",
        fontWeight: FontWeight.w600,
      );

    case FontStyle.BodyM_SemiBold:
      return TextStyle(
        fontSize: 12,
        color: getFontColor(color),
        letterSpacing: 0,
        fontFamily: "DMSansSemiBold",
        fontWeight: FontWeight.w600,
      );

    case FontStyle.BodyS_SemiBold:
      return TextStyle(
        fontSize: 10,
        color: getFontColor(color),
        letterSpacing: 0,
        fontFamily: "DMSansSemiBold",
        fontWeight: FontWeight.w600,
      );

    case FontStyle.TagNameL_SemiBold:
      return TextStyle(
        fontSize: 10,
        color: getFontColor(color),
        letterSpacing: 0,
        fontFamily: "DMSansSemiBold",
        fontWeight: FontWeight.w600,
      );

    case FontStyle.TagNameS_SemiBold:
      return TextStyle(
        fontSize: 9,
        color: getFontColor(color),
        letterSpacing: 0,
        fontFamily: "DMSansSemiBold",
        fontWeight: FontWeight.w600,
      );
    case FontStyle.BodyL_ItalicBold:
      return TextStyle(
        fontSize: 14,
        color: getFontColor(color),
        letterSpacing: 0,
        fontFamily: "DMSansSemiBold",
        fontWeight: FontWeight.w700,
      );
  }
}

getFontColor(FontColor? color) {
  switch (color) {
    case FontColor.White:
      return Colors.white;
    case FontColor.FontPrimary:
      return CustomTheme.modelTheme.fontPrimary;
    case FontColor.FontSecondary:
      return CustomTheme.modelTheme.fontSecondary;
    case FontColor.PacificBlue:
      return CustomTheme.modelTheme.pacificBlue;
    case FontColor.grey:
      return CustomTheme.modelTheme.grey;
    case FontColor.red:
      return Colors.red;

    default:
      return CustomTheme.modelTheme.fontPrimary;
  }
}

const Color transparent = Color(0x00FFFFFF);
const Color white = Color(0xFFFFFFFF);
const success = Color(0xFF0BAA60);
const danger = Color(0xFFF64E4B);
const warning = Color(0xFFE7C160);
