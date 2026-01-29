import 'package:flutter/material.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/data/services/chat_service.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  //DEFINIR CONTROLLER UNICO NO GETX
  static ChatController get instance => Get.find();
  //INICIALIZAR SERVICE
  final ChatService chatService = ChatService();
  //RESGATAR USUARIO LOGADO
  UserModel user = Get.find<UserModel>(tag: 'user');
  //CONTROLADOR DE INPUT DE PESQUISA
  final TextEditingController pesquisaController = TextEditingController();
  //CONTROLADOR DE INPUT DE MENSAGEM
  final TextEditingController messageController = TextEditingController();
  //LISTA DE AMIGOS
  var chats = <Map<String, dynamic>>[].obs;
  //LISTA DE MESAGENS DO CHAT
  RxList<Map<String, dynamic>> chatMessages = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    //DEFINIR JOGADORES DO MERCADO
    chats.value = chatService.generateChats();
  }

  //FUNÇÃO PARA ENVIAR MENSAGENS
  void getMessages(UserModel user){
    //LIMPAR CHAT ATUAL
    chatMessages.value = [];
    //BUSCAR INDEX DO CHAT
    final chatIndex = chats.indexWhere((chatUser) => (chatUser['user'] as UserModel).uuid == user.uuid);
    //VERIFICAR SE INDEX FOI ENCONTRADO
    if(chatIndex != -1){
      //CLONAR A LISTA 
      final updatedMessages = List<Map<String, dynamic>>.from(chats[chatIndex]['messages']);
      //ATUALIZAR LISTA DE CHAT
      chats[chatIndex]['messages'] = updatedMessages;
      //ATUALIZA A LISTA REATIVA
      chatMessages.value = updatedMessages;
    }
  }

  //FUNÇÃO PARA ENVIAR MENSAGENS
  void sendMessage(UserModel user){
    //RESGATAR MENSAGEM DIGITADA
    final text = messageController.text.trim();
    //VERIFICAR SE TEXTO NÃO ESTA VAZIO
    if (text.isEmpty) return;
    //BUSCAR INDEX DO CHAT
    final chatIndex = chats.indexWhere((chatUser) => (chatUser['user'] as UserModel).uuid == user.uuid);
    //VERIFICAR SE INDEX FOI ENCONTRADO
    if(chatIndex != -1){
      //CLONAR A LISTA 
      final updatedMessages = List<Map<String, dynamic>>.from(chats[chatIndex]['messages']);
      //ADICONAR MENSAGEM
      updatedMessages.add({
        'text': text,
        'autor': true,
        'time': DateTime.now().hour,
        'readed' : true
      });
      //ATUALIZAR LISTA DE CHAT
      chats[chatIndex]['messages'] = updatedMessages;
      //ATUALIZA A LISTA REATIVA
      chatMessages.value = updatedMessages;
    }
    //LIMPAR CONTROLLER DE MENSAGEM
    messageController.clear();
  }
}