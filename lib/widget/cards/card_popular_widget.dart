import 'package:flutter/material.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/indicators/indicator_avaliacao_widget.dart';

class CardPopularWidget extends StatelessWidget {
  final List<Map<String, dynamic>> popular;
  final PageController controller;
  
  const CardPopularWidget({
    super.key, 
    required this.popular,
    required this.controller
  });

  @override
  Widget build(BuildContext context) {
    var dimensions = MediaQuery.of(context).size;

    return Center(
      child: Container(
        height: 450,
        width: dimensions.width,
        child: PageView(
          controller: controller,
          children: popular.map((item) {
            return Container(
              margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppHelper.randomColor(),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.dark_500.withOpacity(0.5),
                    spreadRadius: 0.5,
                    blurRadius: 5,
                    offset: Offset(2, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: double.maxFinite,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      image: DecorationImage(
                        image: NetworkImage(item['image']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item['titulo'],
                          style: const TextStyle(
                            color: AppColors.blue_500,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IndicatorAvaliacaoWidget(estrelas: item['avaliacao'])
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      item['descricao'],
                      style: const TextStyle(
                        color: AppColors.blue_500,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}