import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/bars/header_widget.dart';

class NotificacaoPageState extends StatefulWidget {
  final VoidCallback actionButton;
  
  const NotificacaoPageState({
    super.key,
    required this.actionButton,
  });

  @override
  State<NotificacaoPageState> createState() => NotificacaoPageStateState();
}

class NotificacaoPageStateState extends State<NotificacaoPageState> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: HeaderWidget(
          title: 'Notificação',
          action: () => widget.actionButton(),
        )
      ),
      body: Container(
        color: AppColors.light,
      ),
    );
  }
}