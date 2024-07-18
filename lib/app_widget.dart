import 'package:flutter/material.dart';
import 'package:futzada/providers/usuario_provider.dart';
import 'package:futzada/routes/app_routes.dart';
import 'package:provider/provider.dart';
import 'theme/app_colors.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UsuarioProvider(),
          lazy: false,
        )
      ],
      child: MaterialApp(
        title: 'Futzada',
        theme: ThemeData(
          primaryColor: AppColors.green_300,
          fontFamily: 'Nunito'
        ),
        initialRoute: "/splash",
        routes: AppRoutes.routes,
      ),
    );
  }
}