import 'dart:async';
import 'package:flutter/material.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/inputs/input_text_widget.dart';
import 'package:futzada/controllers/event_controller.dart';
import 'package:get/get.dart';

class EventAddressDialog extends StatelessWidget {
  const EventAddressDialog({super.key});

  @override
  Widget build(BuildContext context) {
    //CONTROLLER DE REGISTRO DA PELADA
    final controller = EventController.instance;
    //TIMER DE CONSULTA ENDEREÇO
    Timer? debounce;

    //FUNÇÃO PARA BUSCAR ENDEREÇO (VIA CEP)
    void searchAddress(value) {
      //ATUALIZAR ISSEARCHING
      controller.isSearching.value = true;
      controller.isSearching.refresh();
      //CANCELAR O TIMER ATUAL SE EXISTIR
      if (debounce?.isActive ?? false) {
        debounce!.cancel();
      }
      //VERIFICAR SE VALOR RECEBIDO NÃO ESTA VAZIO
      if (value.isNotEmpty) {
        //CRIAR UM NOVO TIMER DE 2 SEGUNDOS
        debounce = Timer(const Duration(seconds: 2), () async {
          //BUSCAR ENDEREÇO VIA CEP
          var endereco = await AppHelper.getAddress(value);
          //VERIFICAR SE FOI ENCONTRADO APENAS UM ENDEREÇO
          if(endereco is Map){
            //VERIFICAR SE OCORREU UM ERRO
            if(endereco.containsKey('error')){
              //ATUALIZAR MENSAGEM DE ERRO
              controller.enderecoMessage.value = endereco['error'];
              controller.enderecoMessage.refresh();
              //ATUALIZAR ISSEARCHING
              controller.enderecos.value = [];
              controller.enderecos.refresh();
            }else{
              //ATUALIZAR ENDEREÇOS
              controller.enderecos.value = [endereco as Map<String, dynamic> ];
              controller.enderecos.refresh();
            }
          }
          //VERIFICAR SE FOI ENCONTRADO MAIS DE UM ENDEREÇO
          if(endereco is List){
            //CONVERTER DADOS RECEBIDOS PARA O TIPO CORRETO (List<Map<String, dynamic>>)
            List<Map<String, dynamic>> listEnderecos = List<Map<String, dynamic>>.from(endereco.cast<Map<String, dynamic>>());
            //ATUALIZAR ENDEREÇOS
            controller.enderecos.value = listEnderecos;
            controller.enderecos.refresh();
          }
          //ATUALIZAR ISSEARCHING
          controller.isSearching.value = false;
          controller.isSearching.refresh();
        });
      }else{
        //ATUALIZAR ISSEARCHING
        controller.enderecos.value = [];
        controller.enderecos.refresh(); 
        //ATUALIZAR ISSEARCHING
        controller.isSearching.value = false;
        controller.isSearching.refresh();
      }
      //CANCELAR O TIMER
      debounce?.cancel(); 
    }

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
      ),
      child: Column(
        children: [
          Row(
            children: [
              const BackButton(),
              Padding(
                padding: const EdgeInsets.only(left: 60),
                child: Text(
                  'Onde você joga?',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          InputTextWidget(
            name: 'search',
            hint: 'Ex: Campo de Futebol Divinéia - Núcleo Bandeirante, Brasília - DF',
            textController: controller.addressController,
            prefixIcon: AppIcones.marker_solid,
            controller: controller,
            onChanged: searchAddress,
            onSaved: controller.onSaved,
            type: TextInputType.text,
          ),
          const Divider(),
          Obx(() {
            return Expanded(
              child: controller.enderecos.isEmpty 
              ? Center(
                  child: controller.isSearching.value
                    ? const CircularProgressIndicator(
                        color: AppColors.green_300,
                      )
                    : Column(
                        children: [
                          Text(
                            controller.enderecoMessage.value,
                            style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(
                              color: AppColors.gray_500,
                            )
                          ),
                          Text(
                            'Ex: Quadra Poliesportiva - Brasília - DF',
                            style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(
                              color: AppColors.gray_500,
                            ),
                            textAlign: TextAlign.center
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Você também pode buscar o endereço pelo CEP',
                              style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(
                                color: AppColors.gray_500,
                              ),
                              textAlign: TextAlign.center
                            ),
                          ),
                          Text(
                            'Caso o endereço estja correto mas não foi encontrado, prossiga com o cadastro normalmente',
                            style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(
                              color: AppColors.gray_500,
                            ),
                            textAlign: TextAlign.center
                          ),
                        ],
                      ),
                )
              : ListView(
                children: controller.enderecos.asMap().entries.map((entry) {
                  //RESGATAR ENDEREÇO
                  Map<dynamic, dynamic> item = entry.value;
                  return ListTile(
                    leading: const Icon(AppIcones.marker_solid, color: AppColors.dark_300),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${item["logradouro"]}, ${item['bairro']} - ${item['localidade']} - ${item['uf']}",
                          style: Theme.of(Get.context!).textTheme.titleSmall!.copyWith(
                              overflow: TextOverflow.ellipsis
                            ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            item["complemento"]!,
                            style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(
                              color: AppColors.gray_500,
                              overflow: TextOverflow.ellipsis
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      //SELECIONAR TEXTO
                      controller.addressController.text = "${item["logradouro"]}, ${item['bairro']} - ${item['localidade']} - ${item['uf']}";
                      //FECHAR BOTTOMSHEET
                      Get.back();
                    },
                  );
                }).toList(),
              ),
            );
          }),
        ],
      ),
    );
  }
}