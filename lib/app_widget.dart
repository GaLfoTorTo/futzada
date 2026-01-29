import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/app_binding.dart';
import 'package:futzada/core/theme/app_themes.dart';
import 'package:futzada/core/routes/app_routes.dart';
import 'package:flutter_quill/flutter_quill.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      title: 'Futzada',
      initialBinding: AppBinding(),
      themeMode: ThemeMode.light,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: '/splash',
      smartManagement: SmartManagement.keepFactory,
      debugShowCheckedModeBanner: false,
      getPages: AppRoutes.routes,
      localizationsDelegates: const [
        FlutterQuillLocalizations.delegate,
      ],
    );
  }
}