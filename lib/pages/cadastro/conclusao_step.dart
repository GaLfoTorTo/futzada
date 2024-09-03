import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:futzada/controllers/cadastro_controller.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/theme/app_animations.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/buttons/button_outline_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/indicators/indicator_form_widget.dart';
import 'package:futzada/widget/termos_politicas/politicas_privacidade.dart';
import 'package:futzada/widget/termos_politicas/termos.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ConclusaoStep extends StatefulWidget {
  const ConclusaoStep({super.key});

  @override
  State<ConclusaoStep> createState() => _ConclusaoStepStateState();
}

class _ConclusaoStepStateState extends State<ConclusaoStep>  with SingleTickerProviderStateMixin {
  //CONTROLLER DE ABAS
  late final TabController _termosController;
  //CONTROLADOR DOS INPUTS DO FORMULÁRIO
  final CadastroController controller = Get.put(CadastroController());
  //CONTROLLADORES DE CHECKBOX
  late bool termosUsoChecked;
  late bool politicasChecked;
  late bool saveChecked;
  bool validateTermos = true;
  //MENSAGEM DE ERRO
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _termosController = TabController(length: 2, vsync: this);
    //INICIALIZAR VARIAVEIS DE CONTROLE DE CHECKBOX
    termosUsoChecked = false;
    politicasChecked = false;
    saveChecked = false;
  }

  //FUNÇÃO DE CALLBACK DE RETORNO DO SERVIDOR
  void onCompleteAnimation(statusRequest) async {
    //ESPERAR 5 SEGUNDOS
    await Future.delayed(Duration(seconds: 5));
    //VERIRICAR SE HOUVE ERRO NO ENVIO DOS DADOS
    if(statusRequest == true){
      //NAVEGAR PARA LOGIN
      Navigator.pushReplacementNamed(context, "/login");
    }else{
      //FECHAR MODAL
      setState(() {
        Navigator.of(context).pop();
      });
      AppHelper.erroMessage(context, errorMessage);
    }
  }

  //FUNÇÃO DE ENVIO DE DADOS PARA BACKEND
  void registerUser() async{
    var response = controller.sendForm();
    //MODAL DE STATUS DE REGISTRO DO USUARIO
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 1,
          child: FutureBuilder<Map<String, dynamic>>(
            future: response,
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  width: 300,
                  height: 300,
                  child: Center(
                    child: Lottie.asset(
                      AppAnimations.loading,
                      fit: BoxFit.contain,
                    ),
                  )
                );
              }else if(snapshot.hasError) {
                //ADICIONAR MENSAGEM DE ERRO
                errorMessage = 'Erro desconhecido';
                if (snapshot.error is Map<String, dynamic>) {
                  errorMessage = (snapshot.error as Map<String, dynamic>)['message'] ?? 'Erro desconhecido';
                }
                return Container(
                  width: 300,
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Lottie.asset(
                        AppAnimations.checkError,
                        fit: BoxFit.contain,
                        onLoaded: (composition) {
                          //REMOVER MODAL
                          onCompleteAnimation(false);
                        },
                      ),
                    ],
                  )
                );
              }else if(snapshot.hasData) {
                //RESGATAR MENSAGEM
                var data = snapshot.data!;
                //VERIFICAR SE OPERAÇÃO FOI BEM SUCEDIDA
                if (data['status'] == 200) {
                  return Container(
                    width: 300,
                    height: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Lottie.asset(
                          AppAnimations.checkSuccess,
                          fit: BoxFit.contain,
                          onLoaded: (composition) {
                            //REMOVER MODAL
                            onCompleteAnimation(true);
                          },
                        ),
                      ],
                    )
                  );
                }else{
                  //ADICIONAR MENSAGEM DE ERRO
                  errorMessage = data['message'];
                  return Container(
                    width: 300,
                    height: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Lottie.asset(
                          AppAnimations.checkError,
                          fit: BoxFit.contain,
                          onLoaded: (composition) {
                            //REMOVER MODAL
                            onCompleteAnimation(false);
                          },
                        ),
                      ],
                    )
                  );
                }
              }
              return Container(
                width: 300,
                height: 300,
              );
            }
          )
        );
      },
    );
  }

  //FUNÇÃO PARA HABILITAR OU DESABILITAR BOTÃO DE SALVAMENTO
  void enableSave(){
    setState(() {
      //VERIFICAR SE TERMOS DE USO E POLITICAS FORAM SELECIONADAS
      if(termosUsoChecked && politicasChecked){
        //HABILITAR BOTÃO DE SALVAMENTO
        saveChecked = true;
      }else{
        //DESABILITAR BOTÃO DE SALVAMENTO
        saveChecked = false;
      }
    });
  }

  //VALIDAÇÃO DA ETAPA
  void submitForm(){
    print('testes');
    setState(() {
      //REMOVER ERROS 
      errorMessage = null;
      //VALIDAR SE TERMOS E POLITICAS ESTÃO SELECIONADOS
      validateTermos = saveChecked ? true : false;
      //VERIFICAR SE FORMULÁRIO PODE SER ENVIADO
      if(validateTermos){
        //CHAMAR FUNÇÃO DE SALVAMENTO
        registerUser();
      }else{
        //ALERTAR ERRO
        errorMessage = 'Aceite os termos de uso e políticas para finalizar o cadastro';
        AppHelper.erroMessage(context, errorMessage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var dimensions = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: HeaderWidget(
        title: "Cadastro", 
        leftAction: () => Get.back()
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: dimensions.width,
            padding: const EdgeInsets.all(15),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const IndicatorFormWidget(
                  length: 3,
                  etapa: 2
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "Conclusão",
                    style: TextStyle(
                      color: AppColors.dark_500,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Estamos quase lá! Para finalizar seu registro, assinale que você aceita os termos de uso e as politicas de privacidade do app para concluir seu cadastro.",
                    style: TextStyle(
                      color: AppColors.gray_500,
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  height: 500,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    children: [
                      TabBar(
                        controller: _termosController,
                        indicatorColor: AppColors.green_300,
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: AppColors.green_300,
                        labelStyle: const TextStyle(
                          color: AppColors.gray_500,
                          fontWeight: FontWeight.normal,
                        ),
                        unselectedLabelColor: AppColors.gray_500,
                        labelPadding: const EdgeInsets.symmetric(vertical: 5),
                        tabs: const [
                          Text("Termos de Uso"),
                          Tab(text: 'Políticas Priv.'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _termosController,
                          children: const [
                            TermosUso(),
                            PoliticasPrivacidade(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Transform.scale(
                            scale: 1.5,
                            child: Checkbox(
                              value: termosUsoChecked,
                              onChanged: (value) {
                                setState(() {
                                  //CHECKED INPUT
                                  termosUsoChecked = !termosUsoChecked;
                                  //HABILITAR OU DESABILITAR BOTÃO DE SALVAR
                                  enableSave();
                                });
                              },
                              activeColor: AppColors.green_300,
                            ),
                          ),
                          const Text.rich(
                            TextSpan(
                              text: 'Li e aceito os ',
                              style: TextStyle(
                                color: AppColors.gray_500,
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Termos de Uso',
                                  style: TextStyle(
                                    color: AppColors.green_300,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Transform.scale(
                            scale: 1.5,
                            child: Checkbox(
                              value: politicasChecked,
                              onChanged: (value) {
                                setState(() {
                                  //CHECKED BOTÃO
                                  politicasChecked = !politicasChecked;
                                  //HABILITAR OU DESABILITAR BOTÃO DE SALVAR
                                  enableSave();
                                });
                              },
                              activeColor: AppColors.green_300,
                            ),
                          ),
                          const Text.rich(
                            TextSpan(
                              text: 'Li e aceito as ',
                              style: TextStyle(
                                color: AppColors.gray_500,
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Politicas de Privacidade',
                                  style: TextStyle(
                                    color: AppColors.green_300,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ButtonOutlineWidget(
                      text: "Voltar",
                      width: 100,
                      action: () => Get.back(),
                    ),
                    ButtonTextWidget(
                      text: "Salvar",
                      icon: AppIcones.save_solid,
                      iconSize: 20,
                      iconAfter: true,
                      width: 100,
                      action: () => submitForm(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _termosController.dispose();
    super.dispose();
  }
}