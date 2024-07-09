import 'package:flutter/material.dart';
import 'package:futzada/routes/app_routes.dart';
import 'theme/app_colors.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Futzada',
      theme: ThemeData(
        primaryColor: AppColors.green_300,
        fontFamily: 'Nunito'
      ),
      initialRoute: "/splash",
      routes: AppRoutes.routes,
    );
  }
}