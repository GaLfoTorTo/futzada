import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:esportly/presentation/controllers/escalation_controller.dart';
import 'package:esportly/presentation/widget/bars/header_widget.dart';

class HistoricPage extends StatefulWidget {
  const HistoricPage({super.key});

  @override
  State<HistoricPage> createState() => _HistoricPageState();
}

class _HistoricPageState extends State<HistoricPage> {
  @override
  Widget build(BuildContext context) {
    //RESGATAR CONTROLLER DE CHAT
    var controller = EscalationController.instance;

    return Scaffold(
      appBar: HeaderWidget(
        title: 'Histórico',
        leftAction: () => context.pop(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                ListenableBuilder(listenable: controller, builder: (_, __){
                  
                  return Column(
                    children: controller.myEscalations.map((entry) {
                      //RESGATAR ITENS 
                      //Map<String, dynamic> item = entry;
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