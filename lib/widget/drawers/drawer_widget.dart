import 'package:flutter/material.dart';
import 'package:futzada/controllers/auth_controller.dart';
import 'package:futzada/models/usuario_model.dart';
import 'package:futzada/theme/app_animations.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:futzada/theme/app_size.dart';
import 'package:futzada/widget/images/ImgCircularWidget.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  //INSTANCIAR CONTROLLER DE AUTENTICAÇÃO
  final controller = Get.find<AuthController>();
  //DADOS DO USUÁRIO
  late UsuarioModel? usuario;
  //VARIAVEL DE MENSAGEM DE ERRO
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    usuario = controller.usuario;
  }

  void completeLogout(statusLogout) async {
    //DELAY DE 1 SEGUNDO
    await Future.delayed(const Duration(milliseconds: 50));
    //VERIRICAR SE HOUVE ERRO NO ENVIO DOS DADOS
    if(!statusLogout){
      //FECHAR MODAL
      Get.back();
      setState(() {});
    }
  }

  //FUNÇÃO PARA EFETUAR LOGIN
  void logout() async{
    setState(() {
      errorMessage = null;
    });
    //TENTAR EFETUAR LOGIN
    var response = controller.logout();
    //MODAL DE STATUS DE REGISTRO DO USUARIO
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 1,
          child: FutureBuilder<Map<String, dynamic>>(
            future: response,
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
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
              }else if(snapshot.hasError) {
                //FECHAR MODAL
                completeLogout(false);
                //ADICIONAR MENSAGEM DE ERRO
                errorMessage = 'Houve um erro ao efetuar login.';
              }else if(snapshot.hasData) {
                //RESGATAR RETORNO DO SERVIDOR
                var data = snapshot.data!;
                //VERIFICAR SE OPERAÇÃO FOI BEM SUCEDIDA
                if (data['status'] != 200) {
                  //FECHAR MODAL
                  completeLogout(false);
                  //ADICIONAR MENSAGEM DE ERRO
                  errorMessage = data['message'];
                }
              }
              return Container(
                width: 300,
                height: 300,
              );
            }
          )
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //LISTA DE OPTIONS PARA O DRAWER
    final List<Map<String, dynamic>> drawerOptions = [
      {'type': 'section', 'title': 'Perfil de Usuário',},
      {'type': 'option', 'title': 'Minha Conta', 'icon': AppIcones.user_outline, 'route': '/minha_conta'},
      {'type': 'option', 'title': 'Favoritos', 'icon': AppIcones.bookmark_outline, 'route': '/favoritos'},
      {'type': 'option', 'title': 'Amigos', 'icon': AppIcones.users_outline, 'route': '/amigos'},
      {'type': 'option', 'title': 'Modalidades', 'icon': AppIcones.modality_outline, 'route': '/modalidades'},
      {'type': 'option', 'title': 'Minhas Peladas', 'icon': AppIcones.futbol_ball_outline, 'route': '/minhas_peladas'},
      {'type': 'section', 'title': 'Privacidade e Segurança',},
      {'type': 'option', 'title': 'Configurações', 'icon': AppIcones.cog_outline, 'route': '/configuracoes'},
      {'type': 'option', 'title': 'Central de Ajuda', 'icon': AppIcones.question_circle_outline, 'route': '/central_ajuda'},
      {'type': 'option', 'title': 'Sobre', 'icon': AppIcones.exclamation_circle_outline, 'route': '/sobre'},
      {'type': 'option', 'title': 'Termos e Políticas', 'icon': AppIcones.book_outline, 'route': '/termos_politicas'},
    ];

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            decoration: const BoxDecoration(
              color: AppColors.green_300,
            ),
            child: Stack(
              children: [
                Stack(
                  children: [
                    Image.asset(
                      AppImages.gramado,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Container(
                      color: AppColors.green_300.withOpacity(0.8),
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ],
                ),
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ImgCircularWidget(
                        width: 80, 
                        height: 80, 
                        image: usuario!.foto
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${usuario!.nome} ${usuario!.sobrenome}',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.blue_500,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if(usuario!.userName != null)
                              Text(
                                '@${usuario!.userName}',
                                style: const TextStyle(
                                  color: AppColors.blue_500,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]
            ),
          ),
          for (var option in drawerOptions)
            option['type'] == 'option' ? 
              ListTile(
                leading:Icon(
                  option["icon"],
                  color: AppColors.gray_700,
                  size: AppSize.iconLg,
                ),
                title: Text(
                  option['title'],
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.gray_700),
                ),
                onTap: () => print('Navegar para ${option['route']}'),
              )
              :
              ListTile(
                title: Text(
                  option['title'],
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: AppColors.dark_300),
                )
              ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.gray_500,
                  width: 1,
                )
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: ListTile(
                leading: const Icon(
                  AppIcones.sign_out_outline,
                  color: AppColors.gray_700,
                  size: AppSize.iconLg,
                ),
                title: Text(
                  "Sair",
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(color: AppColors.gray_700,),
                ),
                onTap: () => logout(),
              ),
            ),
          )            
        ],
      ),
    );
  }
}