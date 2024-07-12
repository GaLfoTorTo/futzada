import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/pickers/picker_color_widget.dart';
import 'dart:math'; 

class PickerUniformeWidget extends StatelessWidget {
  final Function selectEstampa;
  final Function selectColor;
  final Color primariaColor;
  final Color secundariaColor;
  //CONTROLLADORES DE CORES DAS ESTAMPAS
  final Map<String, dynamic> confEstampa;
  
  const PickerUniformeWidget({
    super.key, 
    required this.selectEstampa,
    required this.selectColor,
    required this.primariaColor,
    required this.secundariaColor,
    required this.confEstampa,
  });

  @override
  Widget build(BuildContext context) {
    //CONTROLLADORES DE CORES DAS ESTAMPAS
    Map<String, dynamic> bgConfig = confEstampa['bg'];
    Map<String, dynamic> mtConfig = confEstampa['mt'];
    Map<String, dynamic> mbConfig = confEstampa['mb'];
    Map<String, dynamic> mlConfig = confEstampa['ml'];
    Map<String, dynamic> mrConfig = confEstampa['mr'];
    Map<String, dynamic> lvcConfig = confEstampa['lvc'];
    Map<String, dynamic> lvlConfig = confEstampa['lvl'];
    Map<String, dynamic> lhcConfig = confEstampa['lhc'];
    Map<String, dynamic> lhlConfig = confEstampa['lhl'];
    Map<String, dynamic> mcConfig = confEstampa['mc'];
    Map<String, dynamic> mmConfig = confEstampa['mm'];
    Map<String, dynamic> mxlConfig = confEstampa['mxl'];
    //CONFIGURAR COR INICIAL 
    bgConfig['color'] = bgConfig['color'] ?? secundariaColor;
    mtConfig['color'] = mtConfig['color'] ?? secundariaColor;
    mbConfig['color'] = mbConfig['color'] ?? secundariaColor;
    mlConfig['color'] = mlConfig['color'] ?? secundariaColor;
    mrConfig['color'] = mrConfig['color'] ?? secundariaColor;
    lvcConfig['color'] = lvcConfig['color'] ?? secundariaColor;
    lvlConfig['color'] = lvlConfig['color'] ?? secundariaColor;
    lhcConfig['color'] = lhcConfig['color'] ?? secundariaColor;
    lhlConfig['color'] = lhlConfig['color'] ?? secundariaColor;
    mcConfig['color'] = mcConfig['color'] ?? secundariaColor;
    mmConfig['color'] = mmConfig['color'] ?? secundariaColor;
    mxlConfig['color'] = mxlConfig['color'] ?? secundariaColor;
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
                              color: bgConfig['color'].withOpacity(0.2),
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
                          tipo: "Uniforme",
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
                            color: mtConfig['color'].withOpacity(0.2),
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
                        label: "Suoerior",
                        checked: mtConfig['checked'],
                        selectColor: selectColor,
                        tipo: "Uniforme",
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
                            color: mbConfig['color'].withOpacity(0.2),
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
                        tipo: "Uniforme",
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
                            color: mrConfig['color'].withOpacity(0.2),
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
                        tipo: "Uniforme",
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
                            color: mlConfig['color'].withOpacity(0.2),
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
                        tipo: "Uniforme",
                      ),
                    )
                  ]
                )
      },
      {
        'label': 'Listras Verticais 1',
        'value': 'lvc', 
        'color': lvcConfig['color'],
        'estampa':Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(70),
                        color: bgConfig['color'],
                        boxShadow: [
                        if (lvcConfig['checked'])
                          BoxShadow(
                            color: lvcConfig['color'].withOpacity(0.2),
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
                          children: [
                            Container(
                              constraints: const BoxConstraints(
                                maxWidth: 20,
                                maxHeight: 120,
                              ),
                              width: 20,
                              height: 120,
                              color: lvcConfig['color'],
                            ),
                            Container(
                              constraints: const BoxConstraints(
                                maxWidth: 20,
                                maxHeight: 120,
                              ),
                              width: 20,
                              height: 120,
                              color: lvcConfig['color'],
                            ),
                            Container(
                              constraints: const BoxConstraints(
                                maxWidth: 20,
                                maxHeight: 120,
                              ),
                              width: 20,
                              height: 120,
                              color: lvcConfig['color'],
                            ),
                          ]
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20), 
                      child: PickerColorWidget(
                        color: lvcConfig['color'],
                        id: "lvc",
                        label: "Listras Verticais 1",
                        checked: lvcConfig['checked'],
                        selectColor: selectColor,
                        tipo: "Uniforme",
                      ),
                    )
                  ]
                )
      },
      {
        'label': 'Listras Verticais 2',
        'value': 'lvl', 
        'color': lvlConfig['color'],
        'estampa':Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(70),
                        color: bgConfig['color'],
                        boxShadow: [
                        if (lvlConfig['checked'])
                          BoxShadow(
                            color: lvlConfig['color'].withOpacity(0.2),
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
                          children: [
                            Container(
                              constraints: const BoxConstraints(
                                maxWidth: 50,
                                maxHeight: 120,
                              ),
                              width: 50,
                              height: 120,
                              color: lvlConfig['color'],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20), 
                      child: PickerColorWidget(
                        color: lvlConfig['color'],
                        id: "lvl",
                        label: "Listras Verticais 2",
                        checked: lvlConfig['checked'],
                        selectColor: selectColor,
                        tipo: "Uniforme",
                      ),
                    )
                  ]
                )
      },
      {
        'label': 'Listras Horizontais 1',
        'value': 'lhc', 
        'color': lhcConfig['color'],
        'estampa': Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(70),
                        color: bgConfig['color'],
                        boxShadow: [
                        if (lhcConfig['checked'])
                          BoxShadow(
                            color: lhcConfig['color'].withOpacity(0.2),
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
                          children: [
                            Container(
                              constraints: const BoxConstraints(
                                maxWidth: 120,
                                maxHeight: 20,
                              ),
                              width: 120,
                              height: 20,
                              color: lhcConfig['color'],
                            ),
                            Container(
                              constraints: const BoxConstraints(
                                maxWidth: 120,
                                maxHeight: 20,
                              ),
                              width: 120,
                              height: 20,
                              color: lhcConfig['color'],
                            ),
                            Container(
                              constraints: const BoxConstraints(
                                maxWidth: 120,
                                maxHeight: 20,
                              ),
                              width: 120,
                              height: 20,
                              color: lhcConfig['color'],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20), 
                      child: PickerColorWidget(
                        color: lhcConfig['color'],
                        id: "lhc",
                        label: "Listras Horizontais 1",
                        checked: lhcConfig['checked'],
                        selectColor: selectColor,
                        tipo: "Uniforme",
                      ),
                    )
                  ]
                )
      },
      {
        'label': 'Listras Horizontais 2',
        'value': 'lhl', 
        'color': lhlConfig['color'],
        'estampa': Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(70),
                        color: bgConfig['color'],
                        boxShadow: [
                        if (lhlConfig['checked'])
                          BoxShadow(
                            color: lhlConfig['color'].withOpacity(0.2),
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
                          children: [
                            Container(
                              constraints: const BoxConstraints(
                                maxWidth: 120,
                                maxHeight: 30,
                              ),
                              width: 120,
                              height: 30,
                              color: lhlConfig['color'],
                            ),
                            Container(
                              constraints: const BoxConstraints(
                                maxWidth: 120,
                                maxHeight: 30,
                              ),
                              width: 120,
                              height: 30,
                              color: lhlConfig['color'],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20), 
                      child: PickerColorWidget(
                        color: lhlConfig['color'],
                        id: "lhl",
                        label: "Listras Horizontais 2",
                        checked: lhlConfig['checked'],
                        selectColor: selectColor,
                        tipo: "Uniforme",
                      ),
                    )
                  ]
                )
      },
      {
        'label': 'Mangas 1',
        'value': 'mc', 
        'color': mcConfig['color'],
        'estampa': Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(70),
                        color: bgConfig['color'],
                        boxShadow: [
                        if (mcConfig['checked'])
                          BoxShadow(
                            color: mcConfig['color'].withOpacity(0.2),
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
                          children: [
                            Transform.rotate(
                              angle: - 30 * pi / 180, 
                              child: Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 120,
                                  maxHeight: 20,
                                ),
                                width: 120,
                                height: 20,
                                color: mcConfig['color'],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20), 
                      child: PickerColorWidget(
                        color: mcConfig['color'],
                        id: "mc",
                        label: "Mangas 1",
                        checked: mcConfig['checked'],
                        selectColor: selectColor,
                        tipo: "Uniforme",
                      ),
                    )
                  ]
                )
      },
      {
        'label': 'Mangas 2',
        'value': 'mm', 
        'color': mmConfig['color'],
        'estampa': Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(70),
                        color: bgConfig['color'],
                        boxShadow: [
                        if (mmConfig['checked'])
                          BoxShadow(
                            color: mmConfig['color'].withOpacity(0.2),
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
                          children: [
                            Transform.rotate(
                              angle: - 30 * pi / 180, 
                              child: Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 120,
                                  maxHeight: 50,
                                ),
                                width: 120,
                                height: 50,
                                color: mmConfig['color'],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20), 
                      child: PickerColorWidget(
                        color: mmConfig['color'],
                        id: "mm",
                        label: "Mangas 2",
                        checked: mmConfig['checked'],
                        selectColor: selectColor,
                        tipo: "Uniforme",
                      ),
                    )
                  ]
                )
      },
      {
        'label': 'Mangas 3',
        'value': 'mxl', 
        'color': mxlConfig['color'],
        'estampa': Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(70),
                        color: bgConfig['color'],
                        boxShadow: [
                        if (mxlConfig['checked'])
                          BoxShadow(
                            color: mxlConfig['color'].withOpacity(0.2),
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
                          children: [
                            Transform.rotate(
                              angle: - 30 * pi / 180, 
                              child: Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 120,
                                  maxHeight: 80,
                                ),
                                width: 120,
                                height: 80,
                                color: mxlConfig['color'],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20), 
                      child: PickerColorWidget(
                        color: mxlConfig['color'],
                        id: "mxl",
                        label: "Mangas 3",
                        checked: mxlConfig['checked'],
                        selectColor: selectColor,
                        tipo: "Uniforme",
                      ),
                    )
                  ]
                )
      },
    ];

    return Column(
      children: [
        Wrap(
          spacing: 50, 
          runSpacing: 15,
          children: [
            CarouselSlider(
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
                          selectEstampa(estampa['value'], estampa['color'], 'Uniforme');
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
                              color: AppColors.gray_500,
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
            ),
            /* if (validatePositions == false)
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Text(
                  'Ao menos 1 posição deve ser selecionada',
                  style: TextStyle(color: Colors.red),
                ),
              ), */
          ],
        ),
      ],
    );
  
  }
}