import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/bars/header_widget.dart';

class EscalacaoPageState extends StatefulWidget {
  final VoidCallback actionButton;
  
  const EscalacaoPageState({
    super.key,
    required this.actionButton,
  });

  @override
  State<EscalacaoPageState> createState() => EscalacaoPageStateState();
}

class EscalacaoPageStateState extends State<EscalacaoPageState> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: HeaderWidget(
          title: 'Escalação',
          action: () => widget.actionButton(),
        )
      ),
      body: Container(
        color: AppColors.light,
      ),
    );
  }
}