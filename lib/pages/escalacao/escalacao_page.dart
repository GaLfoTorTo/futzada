import 'package:flutter/material.dart';
import 'package:futzada/controllers/navigation_controller.dart';
import 'package:futzada/pages/apresentacao_page.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class EscalacaoPageState extends StatefulWidget {  
  const EscalacaoPageState({
    super.key,
  });

  @override
  State<EscalacaoPageState> createState() => EscalacaoPageStateState();
}

class EscalacaoPageStateState extends State<EscalacaoPageState> {
  //CONTROLLER DE BARRA NAVEGAÇÃO
  final navigationController = Get.put(NavigationController());
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: HeaderWidget(
        title: 'Escalações',
        action: () => Get.back(),
      ),
      body: SafeArea(
        child: Container(color: Colors.red,),
      ),
    );
  }
}