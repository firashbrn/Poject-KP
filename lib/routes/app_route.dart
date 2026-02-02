import 'package:flutter/material.dart';
import 'package:presensi_application_1/features/auth/presentation/pages/login/login_view.dart';

import '../core/constants/api_constants.dart';
import '../features/auth/presentation/pages/forgot_password/forgotPassword_view.dart';

class AppRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case ApiConstants.Login:
        return MaterialPageRoute(
          builder: (_) => const LoginView(),
        );

        case ApiConstants.forgotPassword:
        return MaterialPageRoute(
          builder: (_) => const ForgotpasswordView(),
        );
    }

    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(
          child: Text('No route defined for this path'),
        ),
      ),
    );
  }
}