import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';

class LineupWidget extends StatelessWidget {
  final String category;
  const LineupWidget({
    super.key,
    required this.category
  });

  @override
  Widget build(BuildContext context) {
    final Size dimensions = MediaQuery.of(context).size;

    //FUNÇÃO PARA DEFINIR TIPO DE MARCAÇÕES DE CAMPO/QUADRA APARTIR DA CATEGORIA
    String fieldType() {
      switch (category) {
        case 'Fut7':
          return AppIcones.fut7_xl;
        case 'Futsal':
          return AppIcones.futsal_xl;
        case 'Futebol':
        default:
          return AppIcones.futebol_xl;
      }
    }

    //FUNÇÃO PARA CONSTRUÇÃO DE CAMPO COM LINHAS
    Widget buildField() {
      return Container(
        width: dimensions.width,
        decoration: BoxDecoration(
          color: AppColors.green_300,
          border: Border.all(color: AppColors.white, width: 5),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              fieldType(),
              fit: BoxFit.fill,
            ),
          ],
        ),
      );
    }

    //WIDGET DE JOGADOR
    Widget buildPlayerPlaceholder() {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.dark_300.withAlpha(50),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      );
    }

    //FUNÇÃO PARA POSICIONAR JOGADORES NO CAMPO
    Widget buildPlayers() {
      final List<int> distribution = [1, 4, 3, 3];

      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: distribution.asMap().entries.map((entry) {
          final int lineIndex = entry.key;
          final int playerCount = entry.value;

          return Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(playerCount, (index) {
                return buildPlayerPlaceholder();
              }),
            ),
          );
        }).toList(),
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