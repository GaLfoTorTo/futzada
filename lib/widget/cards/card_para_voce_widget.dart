import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';

class CardParaVoceWidget extends StatelessWidget {
  final List<Map<String, dynamic>> peladas;
  final PageController controller;
  
  const CardParaVoceWidget({
    super.key, 
    required this.peladas,
    required this.controller
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 450,
        child: PageView(
          controller: controller,
          children: peladas.map((item) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gray_300.withOpacity(0.5),
                    spreadRadius: 0.8,
                    blurRadius: 7,
                    offset: Offset(5, 5),
                  ),
                ],
                image: DecorationImage(
                  image: NetworkImage(item['image']),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: item['gradient']
                ),
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        item['titulo'],
                        style: TextStyle(
                          color: item['textColor'],
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppIcones.location['fas']!,
                          width: 20,
                          height: 20,
                          color: item['textColor'],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            item['distancia'],
                            style: TextStyle(
                              color: item['textColor'],
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                            
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}