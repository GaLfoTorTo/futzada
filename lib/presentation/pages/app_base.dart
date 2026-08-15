import 'package:flutter/material.dart';
import 'package:futzada/core/di/service_locator.dart';
import 'package:futzada/presentation/widget/drawers/drawer_widget.dart';
import 'package:futzada/presentation/widget/bars/navigation_bar_widget.dart';
import 'package:futzada/presentation/controllers/showcase_controller.dart';

class AppBase extends StatefulWidget {
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
  State<AppBase> createState() => _AppBaseState();
}

class _AppBaseState extends State<AppBase> {
  @override
  void initState() {
    super.initState();
    sl<ShowcaseController>().setShowcase();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = sl<GlobalKey<ScaffoldState>>(instanceName: 'scaffoldKey');

    return Scaffold(
      key: scaffoldKey,
      drawer: const DrawerWidget(),
      body: widget.child,
      bottomNavigationBar: NavigationBarWidget(
        selectedIndex: widget.selectedIndex,
        onDestinationSelected: widget.onDestinationSelected,
      ),
    );
  }
}
