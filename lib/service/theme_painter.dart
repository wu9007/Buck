import 'package:flutter/material.dart';

/// @author wujianchuan
/// @date 2019/12/28 19:11
class ThemePainter {
  static ThemePainter _instance = ThemePainter._();
  static ThemeData _lightTheme = ThemeData(
    backgroundColor: Colors.grey[100],
    primaryColorLight: Colors.black54,
    cardColor: Colors.white,
  );
  static ThemeData _darkTheme = ThemeData.dark();

  Map<String, ThemeData> _themeMap = {
    ThemeType.light: _lightTheme,
    ThemeType.dark: _darkTheme,
  };

  ThemePainter._();

  static ThemePainter getInstance() {
    return _instance;
  }

  add(ThemeData themeData) {
    _themeMap.putIfAbsent(ThemeType.common, () => themeData);
  }

  getThemeData(String themeType) {
    return _themeMap[themeType];
  }

  Map<String, ThemeData> get themeMap => _themeMap;
}

class ThemeType {
  static final String light = 'LIGHT';
  static final String dark = 'DARK';
  static final String common = 'COMMON';
}
