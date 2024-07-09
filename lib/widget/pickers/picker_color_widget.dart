import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';

class PickerColorWidget extends StatelessWidget {
  final String? id;
  final String? label;
  final Color? color;
  final bool? checked;
  final String? tipo;
  final Function? selectColor;
  
  const PickerColorWidget({
    super.key, 
    this.id, 
    this.label, 
    this.color = AppColors.white,
    this.checked, 
    this.tipo, 
    this.selectColor,
  });

  @override
  Widget build(BuildContext context) {
    var dimensions = MediaQuery.of(context).size;

    void modalColors(BuildContext context){
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext context) {
          return Container(
            width: dimensions.width,
            height: dimensions.height / 2,
            margin: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Selecione a cor $label",
                      style: const TextStyle(
                        color: AppColors.gray_500,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.spaceEvenly,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      for (var cor in AppColors.colors.entries) 
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: InkWell(
                            onTap: () => {
                              //SELECIONAR COR
                              selectColor!(id, cor.value, tipo),
                              //FECHAR MODAL
                              Navigator.of(context).pop(),
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: cor.value,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  if (color == cor.value)
                                    BoxShadow(
                                      color: color!.withOpacity(0.2),
                                      spreadRadius: 8,
                                      blurRadius: 1,
                                      offset: Offset(0,0),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                ]
              ),
            )
          );
        },
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (label == 'Primária' || label == 'Secundária')
          Text(
            "${label}",
            style: const TextStyle(
              color: AppColors.gray_500,
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            onTap: () => {
              //ABRIR MODAL
              modalColors(context),
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  if (checked != null && checked == true )
                    BoxShadow(
                      color: color!.withOpacity(0.2),
                      spreadRadius: 8,
                      blurRadius: 1,
                      offset: Offset(0,0),
                    ),
                ],
              ),
            ),
          )
        )
      ],
    );
  }
}