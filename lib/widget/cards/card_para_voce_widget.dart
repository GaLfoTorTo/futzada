import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

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
                    color: AppColors.dark_500.withOpacity(0.5),
                    spreadRadius: 0.5,
                    blurRadius: 5,
                    offset: Offset(2, 5),
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
                        Icon(
                          LineAwesomeIcons.location_arrow_solid,
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