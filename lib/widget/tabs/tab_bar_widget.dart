import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class TabBarWidget extends StatefulWidget {
  final TabController controller;
  final int active;
  
  const TabBarWidget({
    super.key,
    required this.controller,
    required this.active,
  });

  @override
  State<TabBarWidget> createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    //LISTA DE ICONES TAB BAR
    final List<Map<String, dynamic>> tabIcones = [
      {
        'label':'Home',
        'icone': AppIcones.home_outline,
        'active': widget.active == 0 ? AppColors.blue_500 : AppColors.gray_500
      },
      {
        'label':'Escalação',
        'icone': AppIcones.escalacao_outline,
        'active': widget.active == 1 ? AppColors.blue_500 : AppColors.gray_500
      },
      {
        'label':'Pelada',
        'icone': AppIcones.apito,
      },
      {
        'label':'Explore',
        'icone': AppIcones.map_marked_outline,
        'active': widget.active == 3 ? AppColors.blue_500 : AppColors.gray_500
      },
      {
        'label':'Notificações',
        'icone': AppIcones.bell_outline,
        'active': widget.active == 4 ? AppColors.blue_500 : AppColors.gray_500
      },
    ];
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.gray_500.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(3, 0),
          ),
        ],
      ),
      child: TabBar(
        controller: widget.controller,
        indicator: BoxDecoration(),
        onTap: (value) {
          setState(() {
            widget.controller.index = value;
          });
        },
        tabs: [
          for (var icone in tabIcones) 
            Tab(
              icon: Icon(
                icone['icone'],
                color: icone['active'],
              ),
            )
        ],
      ),
    );
  }
}