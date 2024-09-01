import 'package:flutter/material.dart';
import 'package:futzada/app_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'firebase_options.dart';

void main() async {
  //INICIALIZAR OS BINDINGS DO FLUTTER
  WidgetsFlutterBinding.ensureInitialized();
  //INICIALIZAR O GETSTORAGE
  await GetStorage.init();
  runApp(const AppFirebase());
}

class AppFirebase extends StatefulWidget {
  const AppFirebase({super.key});

  @override
  State<AppFirebase> createState() => _AppFirebaseState();
}

class _AppFirebaseState extends State<AppFirebase> {
  final Future<FirebaseApp>_initialization = Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform );

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
          //CASO COMPLETO, EXIBIR APLICAÇÃO
          return const AppWidget();
        }else{
          //CASO QUALQUER OUTRA COISA EXIBIR LOADING
          return const Material(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}