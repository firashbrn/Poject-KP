import 'package:flutter/material.dart';
import 'package:presensi_application_1/core/theme/theme.dart';

import 'core/constants/api_constants.dart';
import 'core/di/injection.dart' as di;
import 'routes/app_route.dart';

void main() async{
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authentication',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightThemeMode,
      onGenerateRoute: AppRoute.generateRoute, 
      initialRoute: ApiConstants.Login,
    );
  }
}

