import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:futzada/core/theme/app_colors.dart';

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

    void modalColors() {
      Get.bottomSheet(
        Container(
          width: dimensions.width,
          height: dimensions.height / 2,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Selecione a cor $label",
                    style: const TextStyle(
                      color: AppColors.grey_500,
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
                          onTap: () {
                            selectColor?.call(id, cor.value, tipo);
                            Get.back(); // fecha o bottomSheet
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
                                    offset: const Offset(0, 0),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        isScrollControlled: true,
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (label == 'Primária' || label == 'Secundária')
          Text(
            label!,
            style: const TextStyle(
              color: AppColors.grey_500,
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            onTap: modalColors,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  if (checked == true)
                    BoxShadow(
                      color: color!.withOpacity(0.2),
                      spreadRadius: 8,
                      blurRadius: 1,
                      offset: const Offset(0, 0),
                    ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}