import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/presentation/widget/pickers/picker_color_widget.dart';

class PickerEmblemaWidget extends StatelessWidget {
  final Function selectEstampa;
  final Function selectColor;
  final Color primaryColor;
  final Color secondaryColor;
  //CONTROLLADORES DE CORES DAS ESTAMPAS
  final Map<String, Map<String, dynamic>> configEstampa;
  
  const PickerEmblemaWidget({
    super.key, 
    required this.selectEstampa,
    required this.selectColor,
    required this.primaryColor,
    required this.secondaryColor,
    required this.configEstampa,
  });

  @override
  Widget build(BuildContext context) {
    //CONTROLLADORES DE CORES DAS ESTAMPAS
    Map<String, dynamic> bgConfig = configEstampa['bg']!;
    Map<String, dynamic> mtConfig = configEstampa['mt']!;
    Map<String, dynamic> mbConfig = configEstampa['mb']!;
    Map<String, dynamic> mlConfig = configEstampa['ml']!;
    Map<String, dynamic> mrConfig = configEstampa['mr']!;
    Map<String, dynamic> lvConfig = configEstampa['lv']!;
    Map<String, dynamic> lhConfig = configEstampa['lh']!;
    //CONFIGURAR COR INICIAL 
    bgConfig['color'] = bgConfig['color'] ?? secondaryColor;
    mtConfig['color'] = mtConfig['color'] ?? secondaryColor;
    mbConfig['color'] = mbConfig['color'] ?? secondaryColor;
    mlConfig['color'] = mlConfig['color'] ?? secondaryColor;
    mrConfig['color'] = mrConfig['color'] ?? secondaryColor;
    lvConfig['color'] = lvConfig['color'] ?? secondaryColor;
    lhConfig['color'] = lhConfig['color'] ?? secondaryColor;
    //LISTA DE OPTIONS PARA O DRAWER
    final List<Map<String, dynamic>> estampas = [
      {
        'label': 'Base',
        'value': 'bg', 
        'color': bgConfig['color'],
        'estampa': Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: bgConfig['color'],
                          borderRadius: BorderRadius.circular(70),
                          boxShadow: [
                            BoxShadow(
                              color: bgConfig['color'].withAlpha(50),
                              spreadRadius: 8,
                              blurRadius: 1,
                              offset: const Offset(0,0),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20), 
                        child: PickerColorWidget(
                          color: bgConfig['color'],
                          id: "bg",
                          label: "Base",
                          checked: true,
                          selectColor: selectColor,
                          tipo: "Emblema",
                        ),
                      )
                    ]
                  )
      },
      {
        'label': 'Superior',
        'value': 'mt', 
        'color': mtConfig['color'],
        'estampa': Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(70),
                        boxShadow: [
                        if (mtConfig['checked'])
                          BoxShadow(
                            color: mtConfig['color'].withAlpha(50),
                            spreadRadius: 8,
                            blurRadius: 1,
                            offset: const Offset(0,0),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: double.maxFinite,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(60)),
                              color: mtConfig['color'],
                            ),
                          ),
                          Container(
                            width: double.maxFinite,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(60)),
                              color: bgConfig['color'],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20), 
                      child: PickerColorWidget(
                        color: mtConfig['color'],
                        id: "mt",
                        label: "Superior",
                        checked: mtConfig['checked'],
                        selectColor: selectColor,
                        tipo: "Emblema",
                      ),
                    )
                  ]
                )
      },
      {
        'label': 'Inferior',
        'value': 'mb', 
        'color': mbConfig['color'],
        'estampa': Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(70),
                        boxShadow: [
                        if (mbConfig['checked'])
                          BoxShadow(
                            color: mbConfig['color'].withAlpha(50),
                            spreadRadius: 8,
                            blurRadius: 1,
                            offset: const Offset(0,0),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: double.maxFinite,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(60)),
                              color: bgConfig['color'],
                            ),
                          ),
                          Container(
                            width: double.maxFinite,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(60)),
                              color: mbConfig['color'],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20), 
                      child: PickerColorWidget(
                        color: mbConfig['color'],
                        id: "mb",
                        label: "Inferior",
                        checked: mbConfig['checked'],
                        selectColor: selectColor,
                        tipo: "Emblema",
                      ),
                    )
                  ]
                )
      },
      {
        'label': 'Direita',
        'value': 'mr', 
        'color': mrConfig['color'],
        'estampa': Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(70),
                        boxShadow: [
                        if (mrConfig['checked'])
                          BoxShadow(
                            color: mrConfig['color'].withAlpha(50),
                            spreadRadius: 8,
                            blurRadius: 1,
                            offset: const Offset(0,0),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: double.maxFinite,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.horizontal(left: Radius.circular(60)),
                              color: bgConfig['color'],
                            ),
                          ),
                          Container(
                            width: 60,
                            height: double.maxFinite,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.horizontal(right: Radius.circular(60)),
                              color: mrConfig['color'],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20), 
                      child: PickerColorWidget(
                        color: mrConfig['color'],
                        id: "mr",
                        label: "Direita",
                        checked: mrConfig['checked'],
                        selectColor: selectColor,
                        tipo: "Emblema",
                      ),
                    )
                  ]
                )
      },
      {
        'label': 'Esquerda',
        'value': 'ml', 
        'color': mlConfig['color'],
        'estampa': Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(70),
                        boxShadow: [
                        if (mlConfig['checked'])
                          BoxShadow(
                            color: mlConfig['color'].withAlpha(50),
                            spreadRadius: 8,
                            blurRadius: 1,
                            offset: const Offset(0,0),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: double.maxFinite,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.horizontal(left: Radius.circular(60)),
                              color: mlConfig['color'],
                            ),
                          ),
                          Container(
                            width: 60,
                            height: double.maxFinite,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.horizontal(right: Radius.circular(60)),
                              color: bgConfig['color'],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20), 
                      child: PickerColorWidget(
                        color: mlConfig['color'],
                        id: "ml",
                        label: "Esquerda",
                        checked: mlConfig['checked'],
                        selectColor: selectColor,
                        tipo: "Emblema",
                      ),
                    )
                  ]
                )
      },
      {
        'label': 'Listras Verticais',
        'value': 'lv', 
        'color': lvConfig['color'],
        'estampa':Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(70),
                        color: bgConfig['color'],
                        boxShadow: [
                        if (lvConfig['checked'])
                          BoxShadow(
                            color: lvConfig['color'].withAlpha(50),
                            spreadRadius: 8,
                            blurRadius: 1,
                            offset: const Offset(0,0),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                      borderRadius: BorderRadius.circular(70),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(3, (index){
                            return 
                            Container(
                              constraints: const BoxConstraints(
                                maxWidth: 20,
                                maxHeight: 120,
                              ),
                              width: 20,
                              height: 120,
                              color: lvConfig['color'],
                            );
                          }).toList()
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20), 
                      child: PickerColorWidget(
                        color: lvConfig['color'],
                        id: "lv",
                        label: "Listras Verticais",
                        checked: lvConfig['checked'],
                        selectColor: selectColor,
                        tipo: "Emblema",
                      ),
                    )
                  ]
                )
      },
      {
        'label': 'Listras Horizontais',
        'value': 'lh', 
        'color': lhConfig['color'],
        'estampa': Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(70),
                        color: bgConfig['color'],
                        boxShadow: [
                        if (lhConfig['checked'])
                          BoxShadow(
                            color: lhConfig['color'].withAlpha(50),
                            spreadRadius: 8,
                            blurRadius: 1,
                            offset: const Offset(0,0),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                      borderRadius: BorderRadius.circular(70),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(3, (index){
                            return Container(
                              constraints: const BoxConstraints(
                                maxWidth: 120,
                                maxHeight: 20,
                              ),
                              width: 120,
                              height: 20,
                              color: lhConfig['color'],
                            );
                          }).toList()
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20), 
                      child: PickerColorWidget(
                        color: lhConfig['color'],
                        id: "lh",
                        label: "Listras Horizontais",
                        checked: lhConfig['checked'],
                        selectColor: selectColor,
                        tipo: "Emblema",
                      ),
                    )
                  ]
                )
      }
    ];

    return CarouselSlider(
      options: CarouselOptions(
        height: 300,
        initialPage: 0,
        enableInfiniteScroll: true,
        autoPlay: false,
        enlargeCenterPage: true,
        enlargeFactor: 0,
        viewportFraction: 0.5,
        scrollDirection: Axis.horizontal,
      ),
      items: estampas.map((estampa) {
        return Builder(
          builder: (BuildContext context) {
            return InkWell(
              onTap: () {
                if(estampa['value'] != 'bg'){
                  selectEstampa(estampa['value'], estampa['color'], 'Emblema');
                }
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  estampa['estampa'],
                  Text(
                    estampa['label'],
                    style: const TextStyle(
                      color: AppColors.grey_500,
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ]
              )
            );
          },
        );
      }).toList(),
    );
  
  }
}