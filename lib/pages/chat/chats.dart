import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/controllers/chat_controller.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/images/ImgCircularWidget.dart';
import 'package:futzada/widget/inputs/input_text_widget.dart';
import 'package:get/get.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/models/user_model.dart';
import 'package:futzada/theme/app_colors.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  //CONTROLLER DE BARRA NAVEGAÇÃO
  final controller = Get.find<ChatController>();

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //RESGATAR USUARIO LOGADO
    UserModel user = Get.find<UserModel>(tag: 'user');
    
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: HeaderWidget(
        title: user.userName,
        leftAction: () => Get.back(),
        shadow: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: dimensions.width,
            color: AppColors.white,
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: InputTextWidget(
                    name: 'search',
                    hint: 'Pesquisa',
                    bgColor: AppColors.gray_300.withAlpha(100),
                    prefixIcon: AppIcones.search_solid,
                    textController: controller.pesquisaController,
                    controller: controller,
                    type: TextInputType.text,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Mensagens',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      ButtonTextWidget(
                        text: "Novo Chat",
                        width: 130,
                        height: 20,
                        icon: AppIcones.user_plus_solid,
                        iconAfter: true,
                        textColor: AppColors.green_300,
                        backgroundColor: Colors.transparent,
                        action: () {},
                      ),
                    ],
                  ),
                ),
                for(var item in controller.friends)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: TextButton(
                      onPressed: () {},
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(AppColors.white),
                        padding: WidgetStatePropertyAll(EdgeInsets.all(15))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: ImgCircularWidget(
                                  height: 60,
                                  width: 60,
                                  image: item['foto'],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    item['nome'],
                                    style: Theme.of(context).textTheme.titleSmall,
                                  ),
                                  Text(
                                    "4 mensagens",
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}