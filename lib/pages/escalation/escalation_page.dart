import 'package:flutter/material.dart';
import 'package:futzada/controllers/navigation_controller.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:get/get.dart';

class EscalationPageState extends StatefulWidget {  
  const EscalationPageState({
    super.key,
  });

  @override
  State<EscalationPageState> createState() => EscalationPageStateState();
}

class EscalationPageStateState extends State<EscalationPageState> {
  //CONTROLLER DE BARRA NAVEGAÇÃO
  final navigationController = Get.put(NavigationController());
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: HeaderWidget(
        title: 'Escalações',
        leftAction: () => Get.back(),
      ),
      body: SafeArea(
        child: Container(color: Colors.red,),
      ),
    );
  }
}