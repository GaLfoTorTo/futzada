import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:futzada/models/address_model.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/controllers/address_controller.dart';
import 'package:futzada/controllers/event_controller.dart';

class AddressDialog extends StatelessWidget {
  const AddressDialog({super.key});

  @override
  Widget build(BuildContext context) {
    //RESGATAR CONTROLLER DE EVENTO
    EventController eventController = EventController.instance;
    //RESGATAR CONTROLLER DE ENDEREÇOS
    AddressController addressController = AddressController.instance;

    //FUNÇÃO DE SELEÇÃO DE ENDEREÇO
    void selectAddress(AddressModel suggestion) {
      //DEFINIR TEXTO DO INPUT DE ENDEREÇO
      eventController.addressText.value = "${suggestion.street ?? ''} ${suggestion.borough ?? ''}, ${suggestion.number ?? ''} - ${suggestion.borough ?? ''} - ${suggestion.city}/${suggestion.state}";
      //ATUALIZAR ENDEREÇO DA PELADA
      eventController.addressEvent = suggestion;
      //ATUALIZAR E MOVER MAPAR PARA LAT E LONG RECEBIDA
      addressController.moveMapCurrentUser(LatLng(suggestion.latitude!, suggestion.longitude!));
      //LIMPAR SUGESTÕES E CAMPO DE PESQUISA
      addressController.suggestions.clear();
      addressController.searchController.clear();
      //FECHAR DIALOG
      Get.back();
    }
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      const BackButton(),
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: Text(
                          'Onde Vamos Jogar?',
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                TextField(
                  controller: addressController.searchController,
                  decoration: InputDecoration(
                    fillColor: AppColors.gray_300.withAlpha(50),
                    hintText: 'Buscar endereço...',
                    border: const OutlineInputBorder(),
                    icon: const Icon(Icons.location_on),
                    suffixIcon: const Icon(Icons.search),
                  ),
                  onChanged: (value) => addressController.searchText.value = value,
                ),
                const Divider(color: AppColors.gray_300),
              ],
            ),
          ),
          Obx(() {
            final suggestions = addressController.suggestions;
            if (addressController.isSearching.value) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.green_300),
              );
            }
            if (suggestions.isNotEmpty) {
              return Expanded(
                child: ListView.builder(
                  itemCount: suggestions.length,
                  itemBuilder: (context, index) {
                    AddressModel suggestion = suggestions[index];
                    String address = "${suggestion.street ?? ''} ${suggestion.borough ?? ''}, ${suggestion.number ?? ''}";
                    String complement = "${suggestion.borough ?? ''} - ${suggestion.city ?? ''}/${suggestion.state}";
                    return ListTile(
                      leading: const Icon(Icons.location_pin, color: AppColors.dark_300, size: 30),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            address,
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(color: AppColors.dark_300),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            complement,
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.gray_300),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                      onTap: () => selectAddress(suggestion),
                    );
                  },
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Text(
                      'Pesquise o local onde sua pelada irá acontecer pelo nome completo ou via CEP.',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.gray_500),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ex: Quadra Poliesportiva - Brasília - DF...',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.gray_500),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}