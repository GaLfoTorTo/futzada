import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/helpers/modality_helper.dart';

class LineupWidget extends StatelessWidget {
  final String category;
  const LineupWidget({
    super.key,
    required this.category
  });

  @override
  Widget build(BuildContext context) {
    final Size dimensions = MediaQuery.of(context).size;

    //FUNÇÃO PARA CONSTRUÇÃO DE CAMPO COM LINHAS
    Widget buildField() {
      return Container(
        width: dimensions.width,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.white, width: 5),
          borderRadius: BorderRadius.circular(15)
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              ModalityHelper.getCategoryCourt(category, large: true),
              fit: BoxFit.fill,
            ),
          ],
        ),
      );
    }

    //EXIBINDO CAMPO/QUADRA
    return Stack(
      children: [
        buildField(),
      ],
    );
  }
}