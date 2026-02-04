import 'package:flutter/material.dart';
import 'package:presensi_application_1/features/auth/presentation/pages/login/login_view.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/pengajuan_cuti/presentation/pages/cuti_approval_page.dart';
import '../../features/pengajuan_cuti/presentation/pages/cuti_form_page.dart';
import '../../features/pengajuan_cuti/presentation/pages/cuti_list_page.dart';
import '../../features/pengajuan_izin/presentation/pages/izin_approval_page.dart';
import '../../features/pengajuan_izin/presentation/pages/izin_form_page.dart';
import '../../features/pengajuan_izin/presentation/pages/izin_list_page.dart';

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

      case '/dashboard':
        return MaterialPageRoute(
          builder: (_) => const DashboardPage(),
        );
      
      case '/history':
      case '/cuti':
        return MaterialPageRoute(
          builder: (_) => const CutiListPage(),
        );
      
      case '/cuti/form':
        return MaterialPageRoute(
          builder: (_) => const CutiFormPage(),
        );

      case '/cuti/approval':
        return MaterialPageRoute(
          builder: (_) => const CutiApprovalPage(),
        );

      case '/history':
      case '/izin':
        return MaterialPageRoute(
          builder: (_) => const IzinListPage(),
        );

      case '/izin/form':
        return MaterialPageRoute(
          builder: (_) => const IzinFormPage(),
        );

      case '/izin/approval':
        return MaterialPageRoute(
          builder: (_) => const IzinApprovalPage(),
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