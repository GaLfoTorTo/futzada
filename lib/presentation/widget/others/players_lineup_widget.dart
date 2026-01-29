import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_images.dart';
import 'package:futzada/data/models/participant_model.dart';
import 'package:futzada/core/utils/img_utils.dart';

class PlayersLineupWidget extends StatelessWidget {
  final List<UserModel> players;
  final double? width;
  final double? height;
  final String category;
  final String? command;
  
  const PlayersLineupWidget({
    super.key,
    required this.players,
    this.command = "Home",
    this.width = 342,
    this.height = 518,
    this.category = "Futebol",
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

  double calcSizeAvatar(int qtd) {
    // Mapeia a quantidade para um tamanho fixo baseado em faixas
    if (qtd <= 4) return 60.0;
    if (qtd <= 6) return 55.0;
    if (qtd <= 8) return 52.0;
    if (qtd <= 10) return 50.0;
    return 45.0;
  }

  //FUNÇÃO PARA CALCULAR A POSIÇÃO DOS JOGADORES
  List<Row> _buildPlayers() {
    //CALCULAR TAMANHO DOS PLAYERS 
    double size = calcSizeAvatar(players.length);
    //DEFINIR FORMAÇÃO
    var formation = _getFormation(players.length);
    //VERIFICAR MANDO DE CAMPO
    if(command == 'Away'){
      formation = formation.reversed.toList();
    }
    final listPlayers = <Row>[];
    formation.every((item){
      listPlayers.add(
        Row(
          mainAxisAlignment: item == 1 ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
          children: List.generate(item, (key){
            //RESGATAR JOGADOR
            final player = players[key];

            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: AppColors.green_300,
                border: Border.all(
                  color: command == "Home" ? AppColors.blue_300 : AppColors.red_300,
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
              child: CircleAvatar(
                backgroundImage: ImgUtils.getUserImg(player.photo),
              ),
            );
          })
        )
      );
      return true;
    });
    return listPlayers;
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