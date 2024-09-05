import 'package:futzada/theme/app_animations.dart';
import 'package:lottie/lottie.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:futzada/app_widget.dart';
import 'package:futzada/controllers/auth_controller.dart';

void main() async {
  //INICIALIZAR OS BINDINGS DO FLUTTER
  final WidgetsBinding widgetBinding = WidgetsFlutterBinding.ensureInitialized();
  //SEGURAR SPALSH ATÉ CARERGAMENTO DOS DEMAIS ITENS
  FlutterNativeSplash.preserve(widgetsBinding: widgetBinding);
  //INICIALIZAR O GETSTORAGE
  await GetStorage.init();
  //INICIALIZAR FIREBASE
  runApp(const AppFirebase());
}

class AppFirebase extends StatefulWidget {
  const AppFirebase({super.key});

  @override
  State<AppFirebase> createState() => _AppFirebaseState();
}

class _AppFirebaseState extends State<AppFirebase> {
  final Future<FirebaseApp>_initialization = Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      //INICIALIZAR FUTURE FIREBASE
      future: _initialization,
      builder: (context, snapshot) {
        //VERIFICAR SE HOUVE ERROS
        if(snapshot.hasError){
          //CASO OCORRA ALGUM ERRO EXIBIR MENSAGEM DE ERRO.
          return const Material(
            child: Center(
              child: Text("Não foi Possível logar", textDirection: TextDirection.ltr,),
            ),
          );
        } else if(snapshot.connectionState == ConnectionState.done){
          //INICIALIZAR CONTROLLER DE AUTENTICAÇÃO
          Get.put(AuthController());
          //CASO COMPLETO, EXIBIR APLICAÇÃO
          return const AppWidget();
        }else{
          //CASO QUALQUER OUTRA COISA EXIBIR LOADING
          return Container(
            width: 300,
            height: 300,
            child: Center(
              child: Lottie.asset(
                AppAnimations.loading,
                fit: BoxFit.contain,
              ),
            )
          );
        }
      },
    );
  }
}