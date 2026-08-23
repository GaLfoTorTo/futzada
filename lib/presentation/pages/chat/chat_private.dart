import 'package:flutter/material.dart';
import 'package:esportly/presentation/widget/images/img_circle_widget.dart';
import 'package:esportly/presentation/widget/inputs/input_text_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:esportly/presentation/controllers/chat_controller.dart';
import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/core/theme/app_colors.dart';
import 'package:esportly/presentation/widget/bars/header_widget.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ChatPrivatePage extends StatefulWidget {
  final UserModel user;
  const ChatPrivatePage({super.key, required this.user});

  @override
  State<ChatPrivatePage> createState() => _ChatPrivatePageState();
}

class _ChatPrivatePageState extends State<ChatPrivatePage> {
  //CONTROLLER DE BARRA NAVEGAÇÃO
  final controller = ChatController.instance;
  //CONTROLADOR DE SCROLL
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    //SCROLL INICIAL SE NECESSÁRIO
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToBottom();
    });
    //RESGATAR MENSAGENS DO CHAT ESPECIFICO
    controller.getMessages(widget.user);
  }

  //FUNÇÃO PARA ROLAGEM DE PAGINA AO ADICIONAR MENSAGEM
  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: HeaderWidget(
        title: "@${widget.user.userName}",
        leftAction: () => context.pop(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListenableBuilder(listenable: controller, builder: (_, __){
                  //RESGATAR MENSAGENS DO CHAT ESPECIFICO
                  var messages = controller.chatMessages;
                  //TRIGGER DE ROLAGEM DA PAGINA
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    scrollToBottom();
                  });
                  //VERIFICAR SE EXISTEM MENSAGENS 
                  if(messages.isNotEmpty){
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        //RESGATAR MENSAGENS
                        final message = messages[index];
                        return ChatBubble(
                          message: message['text'],
                          autor: message['autor'],
                          readed: message['readed'],
                        );
                      },
                    );
                  }else{
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: ImgCircularWidget(
                            size: 120,
                            image: widget.user.photo,
                          ),
                        ),
                        Text(
                          "${widget.user.firstName} ${widget.user.lastName}",
                          style: Theme.of(context).textTheme.titleLarge!
                        ),
                        Text(
                          "@${widget.user.userName}",
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.grey_300)
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          child: Text(
                            "Vocês não tem nenhuma mensagem atualmente\nMande um olá e inicie uma nova conversa!",
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.grey_300),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  }
                }),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark ? AppColors.dark_500 : AppColors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InputTextWidget(
                      hint: 'Mensagem...',
                      backgroundColor: AppColors.grey_300.withAlpha(50),
                      textController: controller.messageController,
                      type: TextInputType.text,
                    ),
                  ),
                  IconButton(
                    onPressed: () => controller.sendMessage(widget.user),
                    color: AppColors.green_300,
                    highlightColor: AppColors.green_100,
                    icon: const Icon(
                      Icons.send_rounded, 
                      color: AppColors.green_500
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool autor;
  final bool readed;

  const ChatBubble({
    super.key,
    required this.message,
    required this.autor,
    required this.readed,
  });

  @override
  Widget build(BuildContext context) {
    //DEFINIR ALINHAMENTO DE MENSAGEM
    final alignment = autor ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    //DEFINIR GRADIENTE DE COR
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? AppColors.dark_500 : AppColors.white;
    final textColorTheme = isDark ? AppColors.white : AppColors.dark_500;
    final gradient = autor
        ? [AppColors.green_300, AppColors.green_500.withGreen(160)]
        : [color, color];
    //DEFINIR COR DO TEXTO DA MENSAGEM
    final textColor = autor 
        ? AppColors.white
        : textColorTheme;
    //DEFINIR BORDARS DA MENSAGEM
    final radius = autor
        ? const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(4),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          );
  
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          constraints: const BoxConstraints(maxWidth: 300),
          decoration: BoxDecoration(
            /* color: autor ? AppColors.green_300 : AppColors.light, */
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
            ),
            borderRadius: radius,
          ),
          child: Column(
            children: [
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: textColor)
              ),
              if(readed)...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      LineAwesomeIcons.check_double_solid,
                      color: textColor,
                      size: 20,
                    ),
                  ],
                )
              ]
            ],
          ),
        ),
      ],
    );
  }
}