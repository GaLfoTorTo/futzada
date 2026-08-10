import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:futzada/app_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:futzada/core/di/service_locator.dart';
import 'package:futzada/core/storage/app_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:futzada/core/di/modules/services.dart';
import 'package:futzada/core/di/modules/controllers.dart';
import 'package:futzada/core/di/modules/repositories.dart';

void main() async {
  //1 - INICIALIZAR OS BINDINGS DO FLUTTER
  final WidgetsBinding widgetBinding = WidgetsFlutterBinding.ensureInitialized();
  //2 - SEGURAR SPALSH ATÉ CARERGAMENTO DOS DEMAIS ITENS
  FlutterNativeSplash.preserve(widgetsBinding: widgetBinding);
  //TENTAR TRATAMENTOS INICIAIS
  try {
    //3 - INICIALIZAR DE VARIAVEIS DE AMBIENTE 
    await dotenv.load(fileName: ".env",);
    //4 - INICIALIZAÇÃO DE STORAGE
    await AppStorage.init();
    //5 - INICIALIZAR FIREBASE (com timeout para evitar travamentos)
    //5.1 - INICIALIZAR FIREBASE APP (INTEGRATION)
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).timeout(const Duration(seconds: 10));
    //5.2 - INICIALIZAR FIREBASE MESSAGING (BACKGROUND)
    FirebaseMessaging.onBackgroundMessage(initFirebaseHandler);
    //6 - REGISTRAR PROVIDER CONTAINER GLOBAL (acesso Riverpod fora da widget tree)
    final container = ProviderContainer();
    sl.registerSingleton<ProviderContainer>(container);
    //6.1 - INICIALIZAR DEPENDENCIAS (CONTROLLERS, SERVICES E REPOSITORIES)
    registerServices(container);
    registerInitControllers();
    registerLazyControllers();
    registerRepositories();
    //7 - INICIALIZAR PROVIDER + ARVORE DE WIDGETS (APPWIDGET)
    runApp(UncontrolledProviderScope(container: container, child: const AppWidget()));
  } catch (e, stack) {
    //ERROS - EXIBIÇÃO DE ERRO
    debugPrint('Erro na inicialização: $e');
    debugPrint('Stack trace: $stack');
    
    //ERROS - EXIBIR TELA DE ERRO AMIGÁVEL
    runApp(
      MaterialApp(
        home: Scaffold(
          backgroundColor: AppColors.green_300,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Falha na inicialização do aplicativo",
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: AppColors.blue_500
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Recarregue o App e tente novamente",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.blue_500),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => main(), // Tentar novamente
                  child: const Text("Tentar novamente"),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}

Future<void> initFirebaseHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}