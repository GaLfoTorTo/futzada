
import 'package:futzada/presentation/controllers/event_controller.dart';
import 'package:futzada/data/models/address_model.dart';
import 'package:futzada/presentation/widget/buttons/button_text_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/presentation/controllers/address_controller.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:latlong2/latlong.dart';

class BottomSheetPlace extends StatefulWidget {
  final Map<String, dynamic> marker;
  const BottomSheetPlace({
    super.key,
    required this.marker
  });

  @override
  State<BottomSheetPlace> createState() => BottomSheetPlayerState();
}

class BottomSheetPlayerState extends State<BottomSheetPlace> {
  //RESGATAR CONTROLLER DE EVENTO
  EventController eventController = EventController.instance;
  //RESGATAR CONTROLLER DE ENDEREÇOS
  AddressController addressController = AddressController.instance;
  //CONTROLADOR DE CARREGAMENTO DE INFORMAÇÕES DO LOCAL
  RxBool isLoaded = false.obs;
  //ESTADO DE ENDEREÇO
  late AddressModel? location;
  IconData icon = AppIcones.modality_solid;
  Color color = AppColors.grey_300;

  @override
  void initState() {
    super.initState();
    //CARREGAR INFORMAÇÕES DO LOCAL
    loadPlaceInfo(widget.marker['id']);
  }

  //FUNÇÃO PARA BUSCAR INFORMAÇÕES DO LOCAL
  Future<void> loadPlaceInfo(id) async{
    //VERIFICAR SE MARKER TEM OS DADOS DE ENDEREÇO DEFINIDOS
    if(widget.marker['address'] == null){
      //DEFINIR ENDEREÇO DO EVENTO
      final latlon = LatLng(widget.marker['lat'], widget.marker['lon']);
      //BUSCAR ENDEREÇO
      var data = await addressController.addressService.getLatLonLocation(latlon);
      //DEFINIR ENDEREÇO
      location = AddressModel(
        street: data['road'] ?? '',
        borough: data['boroughb'] ?? '',
        suburb: data['suburb'] ?? '',
        city: data['city'] ?? '',
        state: data['state'] ?? '',
        zipCode: data['zipCode'] ?? data['postcode'] ?? '',
        country: data['country_code'] ?? '',
        latitude: widget.marker['lat'] ?? '',
        longitude: widget.marker['lon'] ?? '',
      );
      print(location);
      //ADICIONAR ENDEREÇO AO MARKER
      addressController.sportPlaces.firstWhere((item) => item['id'] == widget.marker['id'])['address'] = location;
    }else{
      //RESGATAR DADOS DE ENDEREÇO DO MARKER
      location = widget.marker['address'];
    }
    //RESGATAR COR E ICONE DO LOCAL
    switch (widget.marker['sport']) {
      case 'Futsal':
      case 'Fut7':
      case 'Futebol':
        //DEFINIR COR E ICONE PARA TIPO FUTEBOL
        color = AppColors.green_300;
        icon = AppIcones.futebol_ball_solid;
      case 'Basquete':
        //DEFINIR COR E ICONE PARA TIPO BASQUETE
        color = AppColors.orange_300;
        icon = AppIcones.basquete_ball_solid;
      case 'Volei':
      case 'Volei de Praia':
        //DEFINIR COR E ICONE PARA TIPO VOLEI
        color = widget.marker['sport'] == "Volei" ? AppColors.yellow_300 : AppColors.bege_300;
        icon = AppIcones.volei_ball_solid;
    }
    //ATUALIZAR ESTADO DE CARREGAMENTO
    isLoaded.value = true;
  }
  
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

    return  Container(
      width: dimensions.width,
      height: ( dimensions.height / 2 ) + 50,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).dialogTheme.backgroundColor,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
      ),
      child: Obx((){
        //EXIBIÇÃO DE LOADING DE CARREGAMENTO
        if(!isLoaded.value){
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.green_300,
            )
          );
        }
        //COLUNA DE INFORMAÇÕES DO LOCAL
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(location != null)...[
              Container(
                width: dimensions.width,
                height: 150,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: AppColors.blue_500,
                  size: 100,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: Icon(
                        Icons.location_on,
                        color: AppColors.dark_300,
                      ),
                    ),
                    SizedBox(
                      width: dimensions.width - 50,
                      child: Text(
                        widget.marker['name'] != null 
                          ? "${widget.marker['name']}" 
                          : "${location!.street} ${location!.suburb} ${location!.borough}",
                        style: Theme.of(context).textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ]
                )
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(widget.marker['name'] != null)...[
                      Text(
                        "${location!.city}/${location!.state}",
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: AppColors.grey_500
                        ),
                        maxLines: 1,
                      ),
                    ],
                    Text(
                      "${location!.city}/${location!.state}",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: AppColors.grey_500
                      ),
                      maxLines: 1,
                    ),
                    Text(
                      "${location!.zipCode}",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: AppColors.grey_500
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      children: [
                        Text(
                          "Esporte: ",
                          style: Theme.of(context).textTheme.titleSmall
                        ),
                        Text(
                          "${widget.marker['sport']} ",
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: AppColors.grey_500
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      children: [
                        Text(
                          "Superficie: ",
                          style: Theme.of(context).textTheme.titleSmall
                        ),
                        Text(
                          "${widget.marker['surface']} ",
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: AppColors.grey_500
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      children: [
                        Text(
                          "Acesso: ",
                          style: Theme.of(context).textTheme.titleSmall
                        ),
                        Text(
                          "${widget.marker['access']} ",
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: AppColors.grey_500
                          ),
                          maxLines: 1,
                        ),
                        Icon(
                          widget.marker['access'] == "Publico" ? AppIcones.door_open_solid : AppIcones.door_close_solid,
                          color: AppColors.grey_500,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              ButtonTextWidget(
                text: "Confirmar",
                textSize: 16,
                textColor: AppColors.blue_500,
                width: dimensions.width,
                backgroundColor: color,
                action: () {
                  //DEFINIR CATEGORIA APARTIR DA SUPERFICIE
                  addressController.setCategory(widget.marker);
                  //SELECIONAR LOCALIZAÇÃO
                  addressController.setEventAddress(location);
                }
              )
            ]else...[

            ]
          ]
        );
      })
    );
  }
}