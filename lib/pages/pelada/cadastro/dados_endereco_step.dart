import 'dart:io';
import 'package:flutter/material.dart';
import 'package:futzada/controllers/navigation_controller.dart';
import 'package:futzada/widget/inputs/select_days_week_widget.dart';
import 'package:futzada/widget/inputs/select_rounded_widget.dart';
import 'package:get/get.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/controllers/pelada_controller.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/inputs/input_text_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/buttons/button_outline_widget.dart';
import 'package:futzada/widget/indicators/indicator_form_widget.dart';
import 'package:image_picker/image_picker.dart';

class DadosEnderecoStep extends StatefulWidget {  
  const DadosEnderecoStep({super.key});

  @override
  State<DadosEnderecoStep> createState() => DadosEnderecoStepState();
}

class DadosEnderecoStepState extends State<DadosEnderecoStep> {
  //DEFINIR FORMkEY
  final formKey = GlobalKey<FormState>();
  //CONTROLLER DE NAVEGAÇÃO DE HOME
  final controller = Get.put(PeladaController());
  //DEFINIR ARMAZENAMENTO DA IMAGEM
  File? imageFile;
  //INICIALIZAR IMAGE PICKER
  final ImagePicker imagePicker = ImagePicker();
  //DEFINIR TIPOS DE CAMPO
  bool checkedCampo = false;
  bool checkedSociety = false;
  bool checkedFutsal = false;
  //LISTA DE DIAS DA SEMANA
  final List<Map<String, dynamic>> diasSemana = [
    {'dia':'Dom', 'checked':false},
    {'dia':'Seg', 'checked':false},
    {'dia':'Ter', 'checked':false},
    {'dia':'Qua', 'checked':false},
    {'dia':'Qui', 'checked':false},
    {'dia':'Sex', 'checked':false},
    {'dia':'Sab', 'checked':false},
  ];

  @override
  void initState() {
    super.initState();
  }

  //FUNÇÃO PARA BUSCAR IMAGEM
  Future<void> getImage() async {
    final image = await imagePicker.pickImage(source: ImageSource.gallery);
    //VERIFICAR SE IMAGEM FOI SELECIONADA
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
        controller.onSaved({'foto': image.path});
      });
    }
  }

  //FUNÇÃO DE EXIBIÇÃO DE CAPA DA PELADA
  dynamic capaImage(imageFile){
    if(imageFile != null){
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: FileImage(imageFile!) as ImageProvider<Object>,
              fit: BoxFit.cover
            ),
            border: Border.all(
              color: AppColors.gray_500,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }else{
      return Opacity(
        opacity: 0.3,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: AppColors.gray_700,
              border: Border.all(
                color: AppColors.gray_500,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              AppIcones.camera_solid,
              color: AppColors.blue_500,
              size: 50,
            ),
          ),
        ),
      );
    }
  }

  // Lista de endereços fictícios para demonstração
  final List<Map<String, String>> enderecos = [
    {"logradouro":"1234 Market St, San Francisco, CA","complemento":"endereco 1 St, San Francisco, CA Complemento de endereço"},
    {"logradouro":"5678 Mission St, San Francisco, CA","complemento":"endereco 2 St, San Francisco, CA Complemento de endereço"},
    {"logradouro":"9101 Union St, San Francisco, CA","complemento":"endereco 3 St, San Francisco, CA Complemento de endereço"},
    {"logradouro":"1123 Castro St, San Francisco, CA","complemento":"endereco 4 St, San Francisco, CA Complemento de endereço"},
  ];

  //FUNÇÃO PARA ABRIR BOTTOMSHEET
  void openAdressSearch() {
    Get.bottomSheet(
      Container(
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
              hint: 'Ex: Rua 5 lote 91...',
              textController: controller.enderecoController,
              prefixIcon: AppIcones.marker_solid,
              controller: controller,
              onSaved: controller.onSaved,
              type: TextInputType.text,
              adressSearch: openAdressSearch,
            ),
            const Divider(),
            Expanded(
              child: ListView(
                children: enderecos.asMap().entries.map((entry) {
                  //RESGATAR ENDEREÇO
                  Map<String, String> item = entry.value;
                  return ListTile(
                    leading: const Icon(AppIcones.marker_solid, color: AppColors.dark_300),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item["logradouro"]!,
                          style: Theme.of(Get.context!).textTheme.titleSmall,
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
                      controller.enderecoController.text = item['logradouro']!;
                      //FECHAR BOTTOMSHEET
                      Get.back();
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    ).whenComplete(() {
      //REMOVER FOCO DO BOTÃO AO FECHAR BOTTOMSHEET
      FocusScope.of(context).unfocus(); 
    });
  }

  //SELECIONAR O MELHOR PÉ
  void selectTipoCampo(String value){
    setState(() {
      //ATUALIZAR VALOR DO CONTROLER
      controller.tipoCampoController.text = value;
      controller.onSaved({"tipoCampo": value});
      //VERIFICAR E ALTERAR PÉ SELECIONADO
      checkedCampo = value == 'Campo' ?  true : false;
      checkedSociety = value == 'Society' ? true : false;
      checkedFutsal = value == 'Futsal' ? true : false;
    });
  }

  //FUNÇÃO SELECIONAR DIA DA SEMANA
  void selectDaysWeek(String value){
    setState(() {
      //ENCONTRAR O DIA ESPECIFICO NO ARRAY
      final day = diasSemana.firstWhere((item) => item['dia'] == value);
      //ATUALIZAR O VALOR DE CHECKED
      day['checked'] = !(day['checked'] as bool);
    });
  }

  //VALIDAÇÃO DA ETAPA
  void submitForm(){
    //RESGATAR O FORMULÁRIO
    var formData = formKey.currentState;
    //VERIFICAR SE DADOS DA ETAPA FORAM PREENCHIDOS CORRETAMENTE
    if (formData?.validate() ?? false) {
      formData?.save();
      //NAVEGAR PARA CADASTRO DE ENDEREÇO
      Get.toNamed('/pelada/cadastro/dados_endereco');
    }
  }

  @override
  Widget build(BuildContext context) {
    //CONTROLLER DE BARRA NAVEGAÇÃO
    final navigationController = Get.find<NavigationController>();
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

    //RESGATAR VALOR SELECIONADO
    bool checkedCampo = controller.tipoCampoController.text == 'Campo' ? true : false;
    bool checkedSociety = controller.tipoCampoController.text == 'Society' ? true : false;
    bool checkedFutsal = controller.tipoCampoController.text == 'Futsal' ? true : false;

    //LISTA DE CATEGORIAS DE CAMPO
    final List<Map<String, dynamic>> melhorPe = [
      {'value': 'Campo', 'icon': AppIcones.foot_field_solid, 'checked': checkedCampo},
      {'value': 'Society', 'icon': AppIcones.foot_society_solid, 'checked': checkedSociety},
      {'value': 'Futsal', 'icon': AppIcones.foot_futsal_solid, 'checked': checkedFutsal},
    ];

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: HeaderWidget(
        title: "Cadastro Pelada", 
        leftAction: () => Get.back(),
        rightAction: () => navigationController.backHome(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Container(
              width: dimensions.width,
              padding: const EdgeInsets.all(15),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const IndicatorFormWidget(
                    length: 3,
                    etapa: 1
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Endereço, Data e Hora",
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),]
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Certo então vamos lá! Informe o Nome, a Bio, a Imagem de capa e a Visibilidade da pelada. Você também pode definir as configurações de colaboradores da pelada.",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  InputTextWidget(
                    name: 'endereco',
                    label: 'Endereço',
                    textController: controller.enderecoController,
                    controller: controller,
                    onSaved: controller.onSaved,
                    type: TextInputType.streetAddress,
                    adressSearch: openAdressSearch,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child:Text(
                      "Categoria",
                      style: Theme.of(context).textTheme.titleSmall,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for(var item in melhorPe)
                          SelectRoundedWidget(
                            value: item['value'],
                            icon: item['icon'],
                            size: 120,
                            iconSize: 40,
                            checked: item['checked'],
                            controller: controller,
                            onChanged: selectTipoCampo,
                          )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child:Text(
                      "Dia da Semana",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: diasSemana.map<Widget>((item) {
                        return SelectDaysWeekWidget(
                          value: item['dia'],
                          checked: item['checked'],
                          action: selectDaysWeek,
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ButtonOutlineWidget(
                          text: "Voltar",
                          width: 100,
                          action: () => Get.back(),
                        ),
                        ButtonTextWidget(
                          text: "Próximo",
                          width: 100,
                          action: () => Get.toNamed('/cadastro/conclusao'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}