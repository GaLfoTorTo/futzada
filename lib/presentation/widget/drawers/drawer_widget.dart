import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/core/theme/app_images.dart';
import 'package:futzada/core/theme/app_size.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/presentation/controllers/auth_controller.dart';
import 'package:futzada/presentation/controllers/theme_controller.dart';
import 'package:futzada/presentation/widget/images/img_circle_widget.dart';
import 'package:futzada/presentation/widget/indicators/indicator_loading_widget.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  //CONTROLLERs
  AuthController authController = AuthController.instance;
  ThemeController themeController = ThemeController.instance;
  //DADOS DO USUÁRIO
  late UserModel? user;
  //VARIAVEL DE MENSAGEM DE ERRO
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    user = Get.find<UserModel>(tag: 'user');
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
    //DELAY PARA EXIBIÇÃO DO OVERLAY
    Future.delayed(const Duration(milliseconds: 300), () async {
      await Get.showOverlay(
        asyncFunction: () async {
          //FINALIZAR PARTIDA
          await authController.logout();
        },
        loadingWidget: const Material(
          color: Colors.transparent,
          child: Center(
            child: IndicatorLoadingWidget()
          ),
        ),
        opacity: 0.7,
        opacityColor: AppColors.dark_700,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    //LISTA DE OPTIONS PARA O DRAWER
    final List<Map<String, dynamic>> drawerOptions = [
      {
        'type': 'section',
        'title': 'Perfil de Usuário',
        'icon' : null, 
        'action' : () => print(null)},
      {
        'type': 'option', 
        'title': 'Minha Conta',
        'icon': Icons.person, 
        'action': () => Get.toNamed('/profile')},
      {
        'type': 'option', 
        'title': 'Favoritos',
        'icon': Icons.bookmark, 
        'action': () => Get.toNamed('/favorits')},
      {
        'type': 'option', 
        'title': 'Amigos',
        'icon': Icons.people_alt_rounded, 
        'action': () => Get.toNamed('/friends')},
      {
        'type': 'option', 
        'title': 'Modalidades',
        'icon': AppIcones.modality_solid, 
        'action': () => Get.toNamed('/modalidades')},
      {
        'type': 'option', 
        'title': 'Minhas Peladas',
        'icon': Icons.sports, 
        'action': () => Get.toNamed('/event/list')},
      {
        'type': 'section',
        'title': 'Privacidade e Segurança',
        'icon' : null, 
        'action' : () => print(null)},
      {
        'type': 'option', 
        'title': 'Tema',
        'icon':  themeController.themeMode.value.name == "dark" ?  AppIcones.moon_solid : AppIcones.sun_solid, 
        'action': () => themeController.alterTheme()},
      {
        'type': 'option', 
        'title': 'Configurações',
        'icon': Icons.settings, 
        'action': () => Get.toNamed('/settings')},
      {
        'type': 'option', 
        'title': 'Central de Ajuda',
        'icon': AppIcones.question_circle_solid, 
        'action': () => Get.toNamed('/help')},
      {
        'type': 'option', 
        'title': 'Sobre',
        'icon': AppIcones.exclamation_circle_solid, 
        'action': () => Get.toNamed('/about')},
      {
        'type': 'option', 
        'title': 'Termos e Políticas',
        'icon': AppIcones.book_solid, 
        'action': () => Get.toNamed('/terms')},
      {
        'type': 'divider',
        'title': 'Divider',
        'icon': AppIcones.book_solid, 
        'action': () => {}},
      {
        'type': 'option', 
        'title': 'Sair',
        'icon': AppIcones.sign_out_solid, 
        'action': () => logout()},
    ];

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              image: DecorationImage(
                image: const AssetImage(AppImages.cardFootball) as ImageProvider,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).primaryColor.withAlpha(200), 
                  BlendMode.srcATop,
                )
              ),
            ),
            child: Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImgCircularWidget(
                    width: 80, 
                    height: 80, 
                    image: user!.photo
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${user!.firstName?.capitalize} ${user!.lastName?.capitalize}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.blue_500,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if(user!.userName != null)...[
                          Text(
                            '@${user!.userName}',
                            style: const TextStyle(
                              color: AppColors.blue_500,
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ]
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ...drawerOptions.map((item){
            if(item['type'] == 'divider'){
              return const Divider();
            }
            return ListTile(
              leading: Icon(
                item["icon"],
                size: AppSize.iconLg,
              ),
              title: Text(
                item['title'],
                style: item['icon'] != null 
                  ? Theme.of(context).textTheme.bodyMedium
                  : Theme.of(context).textTheme.titleSmall,
              ),
              onTap: item[
                'action']
            );
          }),  
        ],
      ),
    );
  }
}