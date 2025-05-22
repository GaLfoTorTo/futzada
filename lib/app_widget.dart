import 'package:flutter/material.dart';
import 'package:futzada/controllers/auth_controller.dart';
import 'package:futzada/controllers/navigation_controller.dart';
import 'package:futzada/routes/app_routes.dart';
import 'package:futzada/theme/app_themes.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    //INICIALIZAR CONTROLLER DE AUTENTICAÇÃO
    Get.put(AuthController());
    //INICIALIZAR CONTROLLER DE NAVEGAÇÃO
    Get.put(NavigationController(), permanent: true);
    //INSTANCIAR O GETSTORAGE
    final storage = GetStorage();
    //LER ROTA ULTIMA ROTA ARMAZEANADA
    String initialRoute = '/splash'; 

    return GetMaterialApp(
      title: 'Futzada',
      themeMode: ThemeMode.light,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: initialRoute,
      smartManagement: SmartManagement.keepFactory,
      debugShowCheckedModeBanner: false,
      getPages: AppRoutes.routes,
      routingCallback: (routing) {
        if (routing != null) {
          //SALVAR ROTA ATUAL
          storage.write('currentRoute', routing.current);
        }
      },
    );
  }
}