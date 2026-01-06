import 'package:flutter/material.dart';
import 'package:futzada/controllers/chat_controller.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/images/img_circle_widget.dart';
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
  ChatController chatController = ChatController.instace;

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //RESGATAR USUARIO LOGADO
    UserModel user = chatController.user;

    //FUNÇÃO PARA DEFINIR PREVIEW DE MENSAGENS NO CHAT
    Widget previewMessages(List<dynamic> messages){
      //RESGATAR ULTIMA MENSAGEM DO USUARIO  DO CHAT
      var lastMessage = messages.last;
      //VERIFICAR SE ULTIMA MENSAGEM FOI LIDA OU E DO USUARIO LOGADO
      if(lastMessage['autor'] || lastMessage['readed']){
        return Text(
          lastMessage['text'],
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: AppColors.gray_300,
            overflow: TextOverflow.ellipsis
          ),
        );
      }else{
        // CONTADOR DE MENSAGENS NÃO LIDAS
        int countMessages = 1;
        //LOOP NAS MENSAGENS
        for (var entry in messages) {
          //VERIFICAR SE MENSAGEM NÃO É DO USUARIO LOGADO E NÃO FOI LIDA
          if (!entry['autor'] && !entry['readed']) {
            countMessages++;
          }else{
            break;
          }
        }

        return Text(
          "$countMessages mensagens",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.bold
          ),
        );
      }
    }
    
    return Scaffold(
      appBar: HeaderWidget(
        title: user.userName,
        leftAction: () => Get.back(),
        shadow: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: dimensions.width,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: InputTextWidget(
                    name: 'search',
                    hint: 'Pesquisa',
                    backgroundColor: AppColors.gray_300.withAlpha(50),
                    prefixIcon: AppIcones.search_solid,
                    textController: chatController.pesquisaController,
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
                Obx(() {
                  //RESGTATAR CHATS
                  var chats = chatController.chats;
                  //VERIFICAR SE CHATS NÃO ESTÃO VAZIOS
                  if (chats.isEmpty) {
                    return const Center(
                      child: Text("Nenhuma conversa iniciada."),
                    );
                  }

                  return Column(
                    children: chats.map((chat) {
                      // RESGATAR USUARIO DO CHAT
                      UserModel userChat = chat['user'];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: ElevatedButton(
                          onPressed: () => Get.toNamed(
                            "/chat_private",
                            arguments: userChat,
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: ImgCircularWidget(
                                  height: 60,
                                  width: 60,
                                  image: userChat.photo,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${userChat.firstName} ${userChat.lastName}",
                                    style: Theme.of(context).textTheme.titleSmall,
                                  ),
                                  if(chat['messages'].length > 0)...[
                                    Container(
                                      width: dimensions.width - 150,
                                      child: previewMessages(chat['messages'])
                                    ),
                                  ]
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                })
              ]
            ),
          ),
        ),
      ),
    );
  }
}