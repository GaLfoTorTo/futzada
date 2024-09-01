import 'package:flutter/material.dart';
import 'package:futzada/providers/usuario_provider.dart';
import 'package:futzada/routes/app_routes.dart';
import 'package:futzada/theme/app_themes.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    //INSTANCIAR O GETSTORAGE
    final stackRoute = GetStorage();
    //LER ROTA ULTIMA ROTA ARMAZEANADA
    String initialRoute = stackRoute.read('currentRoute') ?? '/splash'; 

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UsuarioProvider(),
          lazy: false,
        )
      ],
      child: GetMaterialApp(
        title: 'Futzada',
        themeMode: ThemeMode.light,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        initialRoute: initialRoute,
        smartManagement: SmartManagement.keepFactory,
        getPages: AppRoutes.routes,
        routingCallback: (routing) {
          if (routing != null) {
            //SALVAR ROTA ATUAL
            stackRoute.write('currentRoute', routing.current);
          }
        },
      ),
    );
  }
}