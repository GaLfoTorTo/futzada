import 'package:futzada/widget/indicators/indicator_loading_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/controllers/explorer_controller.dart';
import 'package:futzada/controllers/map_controller.dart';
import 'package:futzada/widget/cards/card_event_search_widget.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/inputs/input_text_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/buttons/button_dropdown_widget.dart';

class EventSettingsPage extends StatefulWidget {
  const EventSettingsPage({super.key});

  @override
  State<EventSettingsPage> createState() => _EventSettingsPageState();
}

class _EventSettingsPageState extends State<EventSettingsPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

    return Scaffold(
      appBar: HeaderWidget(
        title: 'Pesquisar',
        leftAction: () => Get.back(),
        shadow: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            
          ],
        ),
      ),
    );
  }
}
