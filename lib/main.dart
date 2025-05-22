import 'package:futzada/theme/app_colors.dart';

import 'firebase_options.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:futzada/app_widget.dart';
import 'package:futzada/theme/app_animations.dart';
import 'package:futzada/controllers/auth_controller.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  //1 - INICIALIZAR OS BINDINGS DO FLUTTER
  final WidgetsBinding widgetBinding = WidgetsFlutterBinding.ensureInitialized();
  //2 - SEGURAR SPALSH ATÉ CARERGAMENTO DOS DEMAIS ITENS
  FlutterNativeSplash.preserve(widgetsBinding: widgetBinding);
  //TENTAR TRATAMENTOS INICIAIS
  try {
    //3 - INICIALIZAR O GETSTORAGE
    await GetStorage.init();
    //4 - INICIALIZAR FIREBASE (com timeout para evitar travamentos)
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ).timeout(const Duration(seconds: 10));
    }
    //5 - INICIALIZAR ARVORE DE WIDGETS (APPWIDGET)
    runApp(const AppWidget());
  } catch (e, stack) {
    //ERROS - EXIBIÇÃO DE ERRO
    debugPrint('Erro na inicialização: $e');
    debugPrint('Stack trace: $stack');
    
    //ERROS - EXIBIR TELA DE ERRO AMIGÁVEL
    runApp(MaterialApp(
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