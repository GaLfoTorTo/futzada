import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_images.dart';

class PlayersCourtWidget extends StatelessWidget {
  final int playerCount;
  final double? width;
  final double? height;
  final String category;
  
  const PlayersCourtWidget({
    super.key,
    required this.playerCount,
    this.width = 342,
    this.height = 518,
    this.category = "Futebol"
  });

  //FUNÇÃO DE DEFINIÇÃO DE FORMAÇÃO POR CATEGORIA
  List<int> _getFormation(int count) {
    switch (count) {
      case 4:
        return [1, 1, 2, 0];
      case 5:
        return [1, 1, 2, 1];
      case 6:
        return [1, 1, 3, 1];
      case 7:
        return [1, 3, 2, 1];
      case 8:
        return [1, 3, 3, 1];
      case 9:
        return [1, 3, 3, 2];
      case 10:
        return [1, 3, 3, 3];
      case 11:
        return [1, 4, 3, 3];
      default:
        return [1, 4, 3, 3];
    }
  }

  //FUNÇÃO PARA CALCULAR A POSIÇÃO DOS JOGADORES
  List<Row> _buildPlayers() {
    var formation = _getFormation(playerCount);
    formation = formation.reversed.toList();
    final players = <Row>[];
    formation.every((item){
      players.add(
        Row(
          mainAxisAlignment: item == 1 ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
          children: List.generate(item, (key){
            return Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppImages.userDefault) as ImageProvider,
                  fit: BoxFit.contain
                ),
                color: AppColors.green_300,
                border: Border.all(
                  color: AppColors.white,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.dark_300.withAlpha(50),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0,5), 
                  ),
                ],
              ),
            );
          })
        )
      );
      return true;
    });
    return players;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _buildPlayers(),
      ),
    );
  }
}