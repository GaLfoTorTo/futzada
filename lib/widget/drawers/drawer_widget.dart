import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/controllers/auth_controller.dart';
import 'package:futzada/providers/usuario_provider.dart';
import 'package:futzada/theme/app_animations.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/login_bg.dart';
import 'package:futzada/widget/images/ImgCircularWidget.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

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
    await Future.delayed(const Duration(milliseconds: 50));
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
    //BUSCAR DADOS SALVOS DO USUARIO
    UsuarioProvider usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
    var usuario = usuarioProvider.usuario;
    //LISTA DE OPTIONS PARA O DRAWER
    final List<Map<String, dynamic>> drawerOptions = [
      {'type': 'section', 'title': 'Perfil de Usuário',},
      {'type': 'option', 'title': 'Minha Conta', 'icon': LineAwesomeIcons.user, 'strokeWidth': 1.0, 'route': '/minha_conta'},
      {'type': 'option', 'title': 'Favoritos', 'icon': LineAwesomeIcons.bookmark, 'strokeWidth': 1.5, 'route': '/favoritos'},
      {'type': 'option', 'title': 'Amigos', 'icon': LineAwesomeIcons.users_solid, 'strokeWidth': 1.0, 'route': '/amigos'},
      {'type': 'option', 'title': 'Modalidades', 'icon': LineAwesomeIcons.futbol, 'strokeWidth': 1.0, 'route': '/modalidades'},
      {'type': 'option', 'title': 'Minhas Peladas', 'icon': LineAwesomeIcons.futbol, 'strokeWidth': 1.0, 'route': '/minhas_peladas'},
      {'type': 'section', 'title': 'Privacidade e Segurança',},
      {'type': 'option', 'title': 'Configurações', 'icon': LineAwesomeIcons.cog_solid, 'strokeWidth': 1.0, 'route': '/configuracoes'},
      {'type': 'option', 'title': 'Central de Ajuda', 'icon': LineAwesomeIcons.question_circle_solid, 'strokeWidth': 1.0, 'route': '/central_ajuda'},
      {'type': 'option', 'title': 'Sobre', 'icon': LineAwesomeIcons.exclamation_circle_solid, 'strokeWidth': 1.0, 'route': '/sobre'},
      {'type': 'option', 'title': 'Termos e Políticas', 'icon': LineAwesomeIcons.atlas_solid, 'strokeWidth': 1.0, 'route': '/termos_politicas'},
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
                const LoginBg(),
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
                              '${usuario.nome} ${usuario.sobrenome}',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.blue_500,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if(usuario.userName != null)
                              Text(
                                '@${usuario.userName}',
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
                  size: 35,
                  color: AppColors.dark_300,
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
                leading:const Icon(
                  Icons.logout,
                  size: 35,
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