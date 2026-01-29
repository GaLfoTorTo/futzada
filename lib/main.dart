import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:futzada/app_widget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  //1 - INICIALIZAR OS BINDINGS DO FLUTTER
  final WidgetsBinding widgetBinding = WidgetsFlutterBinding.ensureInitialized();
  //2 - SEGURAR SPALSH ATÉ CARERGAMENTO DOS DEMAIS ITENS
  FlutterNativeSplash.preserve(widgetsBinding: widgetBinding);
  //TENTAR TRATAMENTOS INICIAIS
  try {
    //3 - INICIALIZAR O DOTENV E GETSTORAGE
    await dotenv.load(fileName: ".env",);
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