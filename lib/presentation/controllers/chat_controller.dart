import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:esportly/core/di/service_locator.dart';
import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/data/services/chat_service.dart';

class ChatController extends ChangeNotifier {
  //DEFINIR CONTROLLER UNICO NO GETIT
  static ChatController get instance => sl<ChatController>();
  //INICIALIZAR SERVICE
  final ChatService chatService = sl<ChatService>();
  //RESGATAR USUARIO LOGADO
  UserModel user = sl<UserModel>(instanceName: 'user');
  //CONTROLADOR DE INPUT DE PESQUISA
  final TextEditingController pesquisaController = TextEditingController();
  //CONTROLADOR DE INPUT DE MENSAGEM
  final TextEditingController messageController = TextEditingController();

  //LISTA DE AMIGOS
  final List<Map<String, dynamic>> _chats = [];
  List<Map<String, dynamic>> get chats => _chats;

  //LISTA DE MESAGENS DO CHAT
  final List<Map<String, dynamic>> _chatMessages = [];
  List<Map<String, dynamic>> get chatMessages => _chatMessages;

  void init() {
    //DEFINIR JOGADORES DO MERCADO
    _chats.clear();
    _chats.addAll(chatService.generateChats());
    notifyListeners();
  }

  //FUNÇÃO PARA ENVIAR MENSAGENS
  void getMessages(UserModel user) {
    //LIMPAR CHAT ATUAL
    _chatMessages.clear();
    //BUSCAR INDEX DO CHAT
    final chatIndex = _chats.indexWhere((chatUser) => (chatUser['user'] as UserModel).uuid == user.uuid);
    //VERIFICAR SE INDEX FOI ENCONTRADO
    if (chatIndex != -1) {
      //CLONAR A LISTA
      final updatedMessages = List<Map<String, dynamic>>.from(_chats[chatIndex]['messages']);
      //ATUALIZAR LISTA DE CHAT
      _chats[chatIndex]['messages'] = updatedMessages;
      //ATUALIZA A LISTA REATIVA
      _chatMessages.addAll(updatedMessages);
    }
    notifyListeners();
  }

  //FUNÇÃO PARA ENVIAR MENSAGENS
  void sendMessage(UserModel user) {
    //RESGATAR MENSAGEM DIGITADA
    final text = messageController.text.trim();
    //VERIFICAR SE TEXTO NÃO ESTA VAZIO
    if (text.isEmpty) return;
    //BUSCAR INDEX DO CHAT
    final chatIndex = _chats.indexWhere((chatUser) => (chatUser['user'] as UserModel).uuid == user.uuid);
    //VERIFICAR SE INDEX FOI ENCONTRADO
    if (chatIndex != -1) {
      //CLONAR A LISTA
      final updatedMessages = List<Map<String, dynamic>>.from(_chats[chatIndex]['messages']);
      //ADICONAR MENSAGEM
      updatedMessages.add({
        'text': text,
        'autor': true,
        'time': DateTime.now().hour,
        'readed': true
      });
      //ATUALIZAR LISTA DE CHAT
      _chats[chatIndex]['messages'] = updatedMessages;
      //ATUALIZA A LISTA REATIVA
      _chatMessages.clear();
      _chatMessages.addAll(updatedMessages);
    }
    //LIMPAR CONTROLLER DE MENSAGEM
    messageController.clear();
    notifyListeners();
  }
}
