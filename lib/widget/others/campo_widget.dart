import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/images/ImgCircularWidget.dart';

class CampoWidget extends StatelessWidget {
  final String? categoria;
  final double qtd;

  const CampoWidget({
    super.key,
    this.categoria = 'Campo',
    required this.qtd
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //DEFINIR LINHAS DO CAMPO
    String linhasCampo = AppIcones.linhasCampo;
    //DEFINIR LINHAS DO CAMPO
    if(categoria == 'Campo'){
      //DEFINIR LINHAS DE CAMPO
      linhasCampo = AppIcones.linhasCampo;
    }else if(categoria == 'Society'){
      //DEFINIR LINHAS DE CAMPO
      linhasCampo = AppIcones.linhasSociety;
    }else if(categoria == 'Quadra'){
      //DEFINIR LINHAS DE CAMPO
      linhasCampo = AppIcones.linhasQuadra;
    }
    //FUNÇÃO DE AJUSTE DE BORDAS DAS LINHAS DO CAMPO
    BorderRadius? borderCampo(int i){
      if(i == 0){
        return const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15));
      }else if(i == 5){
        return const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15));
      }
      return null;
    }

    //FUNÇÃO PARA DISTRIBUIR JOGADORES PELO CAMPO APARTIR DE QTD RECEBIDA
    Map<String, int> calcularSetores() {
      //SETORES DO CAMPO
      int ataque, meioCampo, zaga;
      //VERIFICAR QTD RECEBIDA 
      switch (qtd.toInt()) {
        //SETORES PARA 4 JOGADORES
        case 4:
          ataque = 0;
          meioCampo = 2;
          zaga = 1;
          break;
        //SETORES PARA 5 JOGADORES
        case 5:
          ataque = 1;
          meioCampo = 2;
          zaga = 1;
          break;
        //SETORES PARA 6 JOGADORES
        case 6:
          ataque = 1;
          meioCampo = 2;
          zaga = 2;
          break;
        //SETORES PARA 7 JOGADORES
        case 7:
          ataque = 1;
          meioCampo = 3;
          zaga = 2;
          break;
        //SETORES PARA 8 JOGADORES
        case 8:
          ataque = 2;
          meioCampo = 3;
          zaga = 2;
          break;
        //SETORES PARA 9 JOGADORES
        case 9:
          ataque = 2;
          meioCampo = 3;
          zaga = 3;
          break;
        //SETORES PARA 10 JOGADORES
        case 10:
          ataque = 3;
          meioCampo = 3;
          zaga = 3;
          break;
        //SETORES PARA 11 JOGADORES
        case 11:
          ataque = 3;
          meioCampo = 3;
          zaga = 4;
          break;
        default:
          ataque = 1;
          meioCampo = 1;
          zaga = 1;
      }

      return {
        'Ataque': ataque,
        'Meio-Campo': meioCampo,
        'Zaga': zaga,
      };
    }

    // Função para renderizar setor de ataque
    Row setorAtaque(int numAtaque) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(numAtaque, (index) {
          return const ImgCircularWidget(
            height: 50,
            width: 50,
            image: null,
            borderColor: AppColors.white,
          );
        }),
      );
    }

    // Função para renderizar setor de meio-campo
    Row setorMeioCampo(int numMeioCampo) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(numMeioCampo, (index) {
          return const ImgCircularWidget(
            height: 50,
            width: 50,
            image: null,
            borderColor: AppColors.white,
          );
        }),
      );
    }

    // Função para renderizar setor de zaga
    Row setorZaga(int numZaga) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(numZaga, (index) {
          return const ImgCircularWidget(
            height: 50,
            width: 50,
            image: null,
            borderColor: AppColors.white,
          );
        }),
      );
    }

    //VARIAVEIS PARA CONTROLE DE NUMERO DE JOGADORES NOS SETORES DO CAMPO
    var setores = calcularSetores();
    var numAtaque = setores['Ataque']!;
    var numMeioCampo = setores['Meio-Campo']!;
    var numZaga = setores['Zaga']!;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Stack(
        children: [
          Center(
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(-0.5), 
              child: Container(
                width: dimensions.width - 90,
                height: ( dimensions.height / 2 ) + 50,
                decoration: BoxDecoration(
                  color: AppColors.green_300,
                  border: Border.all(color: AppColors.white, width: 5),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.dark_300.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0,5),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    if(categoria == 'Campo')
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(6, (i){
                          return Container(
                            width: dimensions.width - 90,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.green_500.withOpacity(0.3),
                              borderRadius: borderCampo(i),
                            ),
                          );
                        }),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Center(
                        child: SvgPicture.asset(
                          linhasCampo,
                        )
                      ),
                    ),
                  ]
                ),
              ),
            ),
          ),
          Container(
            height: ( dimensions.height / 2 ),
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            padding: const EdgeInsets.only(top: 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //ATAQUE
                setorAtaque(numAtaque),
                //MEIO-CAMPO
                setorMeioCampo(numMeioCampo),
                //ZAGA
                setorZaga(numZaga),
                //GOLEIRO
                const ImgCircularWidget(
                  height: 50,
                  width: 50,
                  image: null,
                  borderColor: AppColors.white,
                ),
              ]
            ),
          ),
        ]
      ),
    );
  }
}