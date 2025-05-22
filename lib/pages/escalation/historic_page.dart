import 'package:flutter/material.dart';
import 'package:futzada/controllers/escalation_controller.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:get/get.dart';

class HistoricPage extends StatefulWidget {
  const HistoricPage({super.key});

  @override
  State<HistoricPage> createState() => _HistoricPageState();
}

class _HistoricPageState extends State<HistoricPage> {
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //RESGATAR CONTROLLER DE CHAT
    var controller = EscalationController.instace;

    return Scaffold(
      appBar: HeaderWidget(
        title: 'Histórico',
        leftAction: () => Get.back(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Obx(() {
                  
                  return Column(
                    children: controller.myEscalations.map((entry) {
                      //RESGATAR ITENS 
                      Map<String, dynamic> item = entry;
                      return  Container();
                    }).toList(),
                  );
                }),
              ]
            ),
          ),
        ),
      ),
    );
  }
}