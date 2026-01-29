import 'package:flutter/material.dart';
import 'package:futzada/data/models/address_model.dart';
import 'package:futzada/presentation/controllers/address_controller.dart';
import 'package:futzada/presentation/widget/buttons/button_text_widget.dart';

class DialogAlertAddress extends StatelessWidget {
  final AddressModel suggestion;
  const DialogAlertAddress({
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          spacing: 20,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: dimensions.width,
              alignment: Alignment.centerLeft,
              child: BackButton(),
            ),
            Text(
              'O endereço pode não ser um local esportivo!',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const Icon(
              Icons.location_off_rounded,
              size: 150,
            ),
             Text(
              'Parece que você selecionou um local que pode não ser um local esportivo (Quadra, Campo, Ginásio...). Deseja manter o local selecionado como o endereço da sua pelada?',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
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