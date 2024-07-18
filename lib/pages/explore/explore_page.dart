import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/bars/header_widget.dart';

class ExplorePageState extends StatefulWidget {
  final VoidCallback actionButton;
  
  const ExplorePageState({
    super.key,
    required this.actionButton,
  });

  @override
  State<ExplorePageState> createState() => ExplorePageStateState();
}

class ExplorePageStateState extends State<ExplorePageState> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: HeaderWidget(
          title: 'Explore',
          action: () => widget.actionButton(),
        )
      ),
      body: Container(
        color: AppColors.light,
      ),
    );
  }
}