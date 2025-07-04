import 'package:flutter/material.dart';
import 'package:futzada/models/address_model.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/controllers/address_controller.dart';

class ErroAddressDialog extends StatelessWidget {
  final AddressModel suggestion;
  const ErroAddressDialog({
    super.key,
    required this.suggestion
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //RESGATAR CONTROLLER DE ENDEREÇOS
    AddressController addressController = AddressController.instance;

    return  Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: dimensions.width,
              alignment: Alignment.centerLeft,
              child: BackButton(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'O endereço pode não ser um local esportivo!',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const Icon(
              Icons.location_off_rounded,
              size: 150,
              color: AppColors.blue_500,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Text(
                'Parece que você selecionou um local que pode não ser um local esportivo (Quadra, Campo, Ginásio...). Deseja manter o local selecionado como o endereço da sua pelada?',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            ButtonTextWidget(
              text: "Definir Local",
              icon: Icons.location_on,
              width: dimensions.width,
              action: () => addressController.setEventAddress(suggestion),
            ),
          ],
        ),
      ),
    );
  }
}