import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_icones.dart';

class EmblemaWidget extends StatefulWidget {
  final String emblem;
  const EmblemaWidget({
    super.key,
    required this.emblem
  });

  @override
  State<EmblemaWidget> createState() => _EmblemaWidgetState();
}

class _EmblemaWidgetState extends State<EmblemaWidget> {
  String emblem = "emblema_1";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      AppIcones.emblemas[emblem]!,
      width: 100,
      colorFilter: ColorFilter.mode(
        AppColors.grey_300, 
        BlendMode.srcIn,
      ),
    );
  }
}