import 'package:flutter/material.dart';
import 'package:esportly/core/di/service_locator.dart';
import 'package:esportly/core/theme/app_icones.dart';
import 'package:esportly/presentation/widget/dialogs/dialog_back_home.dart';

class NavigationController {
  //CONTROLLER - NAVEGAÇÃO
  static NavigationController get instance => sl<NavigationController>();
  //OPÇÕES DE NAVEGAÇÃO DO BOTTOM NAV
  final List<Map<String, dynamic>> options = [
    {'label' : "Home",         'key' : 'home',          "icon" : Icons.home_filled},
    {'label' : "Escalação",    'key' : 'escalation',    "icon" : AppIcones.escalacao_solid},
    {'label' : "Eventos",      'key' : 'events',        "icon" : Icons.sports},
    {'label' : "Explore",      'key' : 'explorer',      "icon" : Icons.map_rounded},
    {'label' : "Notificações", 'key' : 'notifications', "icon" : Icons.notifications},
  ];

  //FUNÇÃO DE RETORNO PARA HOME
  void backHome(BuildContext context) {
    showDialog(context: context, builder: (_) => const DialogBackHome());
  }
}
