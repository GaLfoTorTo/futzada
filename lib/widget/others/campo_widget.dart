import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/buttons/button_player_widget.dart';

class CampoWidget extends StatelessWidget {
  final String? categoria;
  final Map<int, dynamic> escalation;
  final String formation;
  final double? width;
  final double? height;

  const CampoWidget({
    super.key,
    this.categoria = 'Campo',
    required this.escalation,
    this.formation = '4-3-3',
    this.width = 342,
    this.height = 518,
  });

  @override
  Widget build(BuildContext context) {
    //FUNÇÕES DE ESTAMPA DO CAMPO
    String fieldType(String? categoria){
      if(categoria == 'Society'){
        //DEFINIR LINHAS DE CAMPO
        return AppIcones.linhasSociety;
      }
      if(categoria == 'Quadra'){
        //DEFINIR LINHAS DE CAMPO
        return AppIcones.linhasQuadra;
      }
      //DEFINIR LINHAS DE CAMPO
      return AppIcones.linhasCampo;
    }
    //FUNÇÃO DE AJUSTE DE BORDAS DAS LINHAS DO CAMPO
    BorderRadius? borderRadiusField(int i){
      if(i == 0){
        return const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15));
      }else if(i == 5){
        return const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15));
      }
      return null;
    }
    //FUNÇÃO PARA GERAR LINHAS DO GRAMADO
    Widget grassField(){
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(6, (i){
          return Container(
            width: width,
            height: height! / 11,
            decoration: BoxDecoration(
              color: AppColors.green_500.withAlpha(70),
              borderRadius: borderRadiusField(i),
            ),
          );
        }),
      );
    }
    //FUNÇÃO PARA AJUSTAR A ALINHAÇÃO DAS POSIÇÕES NO CAMPO
    AlignmentGeometry setAligmentPositions(int index, int qtd){
      //VERIFICAR QTD DE LINHAS NA FORMAÇÃO
      if(qtd == 4){
        //VERIFICAR QUANTIDADE DE ZAGUEIROS OU MEIAS
        if(index == 0 || index == 3 ){
          //ALINHAR A BAIXO
          return Alignment.topCenter;
        }
      //VERIFICAR QTD DE LINHAS NA FORMAÇÃO
      }else if(qtd == 5){
        //VERIFICAR QUANTIDADE DE ZAGUEIROS OU MEIAS
        if(index == 0 || index == 4){
          //ALINHAR A BAIXO
          return Alignment.topCenter;
        }
      }
      //ALINHAR AO CENTRO
      return Alignment.center;
    }
    //FUNÇÃO PARA RENDERIZAR CAMPO
    Widget renderField(){
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.green_300,
          border: Border.all(color: AppColors.white, width: 5),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.dark_300.withAlpha(50),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0,5), 
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if(categoria == 'Campo')...[
              grassField(),
            ],
            SvgPicture.asset(
              height: height! - 40,
              fieldType(categoria),
            )
          ]
        ),
      );
    }
    //FUNÇÃO PARA TRATAMENTO DA FORMAÇÃO
    List<int> setPositions(){
      //VARIAVEIS PARA CONTROLE DE NUMERO DE JOGADORES NOS SETORES DO CAMPO
      var listFormation = formation.split('-').map((e) => int.parse(e)).toList();
      //ADICIONAR O GOLEIRO NO INICIO DO ARRAY
      listFormation.insert(0, 1);
      //INVERTER ORDEM DO ARRAY DE POSIÇÕES
      return listFormation.reversed.toList();
    }
    //VARAIVEL DE POSIÇÕES DA FORMAÇÃO
    var positions = setPositions();
    
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform(
          alignment: Alignment.topCenter,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0008)
            ..rotateX(-0.7), 
          child: renderField()
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...positions.asMap().entries.map((entry){
              final groupPosition = entry.key;
              final qtd = entry.value;
              //INVERTER POSITIONS PARA CALULAR INDEX REAL DO ATLETA
              final invertedGroupPos = positions.length - 1 - groupPosition;
              // CALCULAR A POSIÇÃO DO JOGADOR NA ESCALAÇÃO
              final groupStartIndex = positions
                  .reversed
                  .toList()
                  .sublist(0, invertedGroupPos)
                  .fold(0, (sum, item) => sum + item);
              //ATACANTES, MEIAS, ZAGUEIROS E GOLEIRO
              return SizedBox(
                height: positions.length == 5 ? 100 : 130,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(qtd, (index) {
                    // CALCULAR A POSIÇÃO DO JOGADOR NA ESCALAÇÃO
                    final realPosition = groupStartIndex + index;
                    //RESGATAR JOGADOR NA ESCALAÇÃO
                    Map<String, dynamic>? player = escalation[realPosition];
                    return Container(
                      alignment: setAligmentPositions(index, qtd),
                      child: ButtonPlayerWidget(
                        player: player,
                        size: 60,
                        borderColor: AppHelper.setPlayerPosition(player),
                      )
                    );
                  }),
                ),
              );
            }),
          ]
        ),
      ]
    );
  }
}