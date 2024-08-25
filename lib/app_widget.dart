import 'package:flutter/material.dart';
import 'package:futzada/providers/usuario_provider.dart';
import 'package:futzada/routes/app_routes.dart';
import 'package:futzada/theme/app_themes.dart';
import 'package:provider/provider.dart';

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
        themeMode: ThemeMode.light,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        initialRoute: "/splash",
        routes: AppRoutes.routes,
      ),
    );
  }
}