import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/controllers/auth_controller.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:futzada/widget/login_bg.dart';
import 'package:futzada/widget/images/ImgCircularWidget.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  //INSTANCIAR CONTROLLER DE AUTENTICAÇÃO
  final controller = AuthController();
  //VARIAVEL DE MENSAGEM DE ERRO
  String? errorMessage;

  @override
  void initState() {
    super.initState();
  }

  void completeLogout(statusLogout) async {
    //DELAY DE 1 SEGUNDO
    await Future.delayed(Duration(milliseconds: 50));
    //VERIRICAR SE HOUVE ERRO NO ENVIO DOS DADOS
    if(!statusLogout){
      //FECHAR MODAL
      Navigator.of(context).pop();
      setState(() {});
    }
  }

  //FUNÇÃO PARA EFETUAR LOGIN
  void logout() async{
    setState(() {
      errorMessage = null;
    });
    //TENTAR EFETUAR LOGIN
    var response = controller.logout(context);
    //MODAL DE STATUS DE REGISTRO DO USUARIO
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(150.0),
          ),
          child: FutureBuilder<Map<String, dynamic>>(
            future: response,
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  width: 300,
                  height: 300,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.green_300,
                    )
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
      {'type': 'option', 'title': 'Minha Conta', 'icon': AppIcones.user["far"], 'strokeWidth': 1.0, 'route': '/minha_conta'},
      {'type': 'option', 'title': 'Favoritos', 'icon': AppIcones.favorito["far"], 'strokeWidth': 1.5, 'route': '/favoritos'},
      {'type': 'option', 'title': 'Amigos', 'icon': AppIcones.users["far"], 'strokeWidth': 1.0, 'route': '/amigos'},
      {'type': 'option', 'title': 'Modalidades', 'icon': AppIcones.modalidade["far"], 'strokeWidth': 1.0, 'route': '/modalidades'},
      {'type': 'option', 'title': 'Minhas Peladas', 'icon': AppIcones.futebol_ball["far"], 'strokeWidth': 1.0, 'route': '/minhas_peladas'},
      {'type': 'section', 'title': 'Privacidade e Segurança',},
      {'type': 'option', 'title': 'Configurações', 'icon': AppIcones.cog["far"], 'strokeWidth': 1.0, 'route': '/configuracoes'},
      {'type': 'option', 'title': 'Central de Ajuda', 'icon': AppIcones.interrogacao["far"], 'strokeWidth': 1.0, 'route': '/central_ajuda'},
      {'type': 'option', 'title': 'Sobre', 'icon': AppIcones.exclamacao["far"], 'strokeWidth': 1.0, 'route': '/sobre'},
      {'type': 'option', 'title': 'Termos e Políticas', 'icon': AppIcones.book["far"], 'strokeWidth': 1.0, 'route': '/termos_politicas'},
    ];

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: AppColors.green_300,
            ),
            child: Stack(
              children: [
                LoginBg(),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ImgCircularWidget(width: 70, height: 70, image: AppImages.user_default),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Nome do Usuário",//ADICIONAR NOME DO USUARIO
                              style: TextStyle(
                                color: AppColors.blue_500,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "@nome_usuario",//ADICIONAR @ DO USUARIO
                              style: TextStyle(
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
                leading:
                SvgPicture.asset(
                  option["icon"],
                  color: AppColors.dark_500,
                ),
                title: Text(
                  option['title'],
                  style: const TextStyle(
                    color: AppColors.dark_300,
                    fontSize: 15,
                  ),
                ),
                onTap: () {
                  print('Navegar para ${option['route']}');
                },
              )
              :
              ListTile(
                title: Text(
                  option['title'],
                  style: const TextStyle(
                    color: AppColors.gray_500,
                    fontSize: 15,
                  ),
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
                leading:
                SvgPicture.asset(
                  AppIcones.logout["far"]!,
                  color: AppColors.dark_500,
                ),
                title: const Text(
                  "Sair",
                  style: TextStyle(
                    color: AppColors.dark_300,
                    fontSize: 15,
                  ),
                ),
                onTap: () {
                  logout();
                },
              ),
            ),
          )            
        ],
      ),
    );
  }
}