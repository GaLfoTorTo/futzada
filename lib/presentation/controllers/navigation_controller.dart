import 'package:flutter/material.dart';
import 'package:futzada/core/di/service_locator.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/presentation/widget/dialogs/dialog_back_home.dart';

class NavigationController {
  //CONTROLLER - NAVEGAÇÃO
  static NavigationController get instance => sl<NavigationController>();
  //OPÇÕES DE NAVEGAÇÃO DO BOTTOM NAV
  final List<Map<String, dynamic>> options = [
    {'label' : "Home",         'key' : 'home',          "icon" : Icons.home_filled},
    {'label' : "Escalação",    'key' : 'escalation',    "icon" : AppIcones.escalacao_outline},
    {'label' : "Eventos",      'key' : 'events',        "icon" : AppIcones.apito},
    {'label' : "Explore",      'key' : 'explorer',      "icon" : Icons.map_rounded},
    {'label' : "Notificações", 'key' : 'notifications', "icon" : Icons.notifications},
  ];

  //FUNÇÃO DE RETORNO PARA HOME
  void backHome(BuildContext context) {
    showDialog(context: context, builder: (_) => const DialogBackHome());
  }
}
