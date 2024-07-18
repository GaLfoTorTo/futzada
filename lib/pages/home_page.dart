import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/providers/usuario_provider.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/skeletons/skeleton_home_widget.dart';
import 'package:provider/provider.dart';
import '/theme/app_colors.dart';
import '/theme/app_icones.dart';
import '/widget/images/ImgCircularWidget.dart';

class HomePage extends StatefulWidget {
  final Function menuFunction;
  final Function chatFunction;

  const HomePage({
    super.key,
    required this.menuFunction,
    required this.chatFunction,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  //BUSCAR USUARIO PROVIDER
  late UsuarioProvider usuarioProvider;
  late var usuario;

  Future<UsuarioProvider>fetchUsuario(BuildContext context) async {
    //ADICIONAR DELAY DE 2 SEGUNDOS
    await Future.delayed(Duration(seconds: 2));
    //BUSCAR OS DADOS DO PROVIDER 
    usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
    //RESGATAR USUARIO
    usuario = usuarioProvider.usuario;
    return usuarioProvider;
  }

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(
        backgroundColor: AppColors.green_300,
        leading: InkWell(
          onTap: () => widget.menuFunction(true),
          child: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: SvgPicture.asset(
                AppIcones.menu["fas"]!,
                width: double.maxFinite,
                height: double.maxFinite,
                color: AppColors.blue_500,
              ),
            ),
          ),
        ),
        actions: [
          InkWell(
            onTap: () => widget.menuFunction(true),
            child: Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: SvgPicture.asset(
                  AppIcones.direct["fas"]!,
                  width: double.maxFinite,
                  height: double.maxFinite,
                  color: AppColors.blue_500,
                ),
              ),
            ),
          ),
        ],
        elevation: 8,
        shadowColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: Column(
        children: [ 
          FutureBuilder<UsuarioProvider>(
            future: fetchUsuario(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SkeletonHomeWidget();
              } else if (snapshot.hasError) {
                return Center(child: Text('Ocorreu um erro: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          ImgCircularWidget(
                            width: 80, 
                            height: 80, 
                            image: usuario.foto
                          ),
                          Positioned(
                            top: 60,
                            left: 60,
                            child: Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                color: AppColors.green_300,
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppHelper.saudacaoPeriodo(),
                              style: const TextStyle(
                                color: AppColors.blue_500,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${usuario.nome} ${usuario.sobrenome}',
                              style: const TextStyle(
                                color: AppColors.blue_500,
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return const SkeletonHomeWidget();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}