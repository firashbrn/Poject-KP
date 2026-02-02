
import 'package:flutter/material.dart';
import 'package:presensi_application_1/core/theme/app_pallet.dart';

class AppTheme {
  static _border([Color color = AppPallete.borderColor]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(
          color: color,
          width: 3,
        ),
      );
  static final lightThemeMode = ThemeData.light(
    useMaterial3: true
  ).copyWith(
      scaffoldBackgroundColor: AppPallete.backgroundColor,
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        border: _border(),
        enabledBorder: _border(),
        focusedBorder: _border(AppPallete.gradient2),
        errorBorder: _border(Colors.red),
        focusedErrorBorder: _border(Colors.red),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppPallete.backgroundColor,
      ));
}