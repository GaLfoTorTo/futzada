import 'package:flutter/material.dart';
import 'package:futzada/core/di/service_locator.dart';
import 'package:futzada/presentation/widget/drawers/drawer_widget.dart';
import 'package:futzada/presentation/widget/bars/navigation_bar_widget.dart';
import 'package:futzada/presentation/controllers/showcase_controller.dart';

class AppBase extends StatelessWidget {
  final Widget child;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const AppBase({
    super.key,
    required this.child,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    //ESTADO - SCAFFOLDKEY
    final GlobalKey<ScaffoldState> scaffoldKey = sl<GlobalKey<ScaffoldState>>(instanceName: 'scaffoldKey');;
    //CONTROLLER - SHOWCASE
    final ShowcaseController showcaseController = sl<ShowcaseController>();
    //CONFIGURAR SHOWCASE
    showcaseController.setShowcase();

    return Scaffold(
      key: scaffoldKey,
      drawer: const DrawerWidget(),
      body: child,
      bottomNavigationBar: NavigationBarWidget(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}
