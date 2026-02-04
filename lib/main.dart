import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:presensi_application_1/core/theme/theme.dart';

import 'core/constants/api_constants.dart';
import 'core/di/injection.dart' as di;
import 'routes/app_route.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await di.init();
  runApp(const ProviderScope(child: MyApp()));
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

