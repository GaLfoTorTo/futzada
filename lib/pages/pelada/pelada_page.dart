import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/bars/header_widget.dart';

class PeladaPageState extends StatefulWidget {
  final VoidCallback actionButton;
  
  const PeladaPageState({
    super.key,
    required this.actionButton,
  });

  @override
  State<PeladaPageState> createState() => PeladaPageStateState();
}

class PeladaPageStateState extends State<PeladaPageState> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: HeaderWidget(
          title: 'Pelada',
          action: () => widget.actionButton(),
        )
      ),
      body: Container(
        color: AppColors.light,
      ),
    );
  }
}