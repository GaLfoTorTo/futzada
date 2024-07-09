import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:futzada/controllers/cadastro_controller.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/indicators/indicator_form_widget.dart';
import 'package:futzada/widget/inputs/input_text_widget.dart';

class DadosLoginStepState extends StatefulWidget {
  final VoidCallback proximo;
  final VoidCallback voltar;
  final int etapa;
  final CadastroController controller;

  const DadosLoginStepState({
    super.key, 
    required this.proximo, 
    required this.voltar, 
    required this.etapa, 
    required this.controller,
  });

  @override
  State<DadosLoginStepState> createState() => __DadosLoginStepStateState();
}

class __DadosLoginStepStateState extends State<DadosLoginStepState> {
  final formKey = GlobalKey<FormState>();
  //CONTROLLERS DE CADA CAMPO
  late final TextEditingController senhaController;
  late final TextEditingController confirmacaoController;

  @override
  void initState() {
    super.initState();
    //INICIALIZAR LISTENER
    widget.controller.addListener((){});
    //INICIALIZAÇÃO DE CONTROLLERS
    senhaController = TextEditingController(text: widget.controller.model.senha);
    confirmacaoController = TextEditingController(text: widget.controller.model.confirmacao);
  }

  //VALIADÇÃO DE CONFIRMAÇÃO DE SENHA
  String? validateConfirm(){
    //VERIFICAR SE NÃO ESTÁ VAZIO
    if(confirmacaoController.text.isEmpty){
      return "Confirmação de Senha deve ser preenchido(a)!";
    }
    //VERIFICAR SE SENHAS COMBINAM
    if(senhaController.text != confirmacaoController.text){
      return "Senha e Confirmação de senha devem ser iguais!";
    }
    return null;
  }

  //VALIDAÇÃO DA ETAPA
  void submitForm(){
    //RESGATAR O FORMULÁRIO
    var formData = formKey.currentState;
    //VERIFICAR SE DADOS DA ETAPA FORAM PREENCHIDOS CORRETAMENTE
    if (formData?.validate() ?? false) {
      formData?.save();
      widget.proximo();
    }
  }

  @override
  Widget build(BuildContext context) {
    //DICAS DE SENHA
    final List<String> dicas = [
      "Letras Maiúsculas: A- Z;",
      "Letras Minúsculas: a - z;",
      "Números: 0 - 9;",
      "Símbolos especiais: [ #, *, @, & ...];"
    ];
    //LISTA DE CAMPOS
    final List<Map<String, dynamic>> inputs = [
      {
        'name':'senha',
        'label': 'Senha',
        'controller': senhaController,
      },
      {
        'name': 'confirmacao',
        'label': 'Confirmação de Senha',
        'controller': confirmacaoController,
        'validator' : validateConfirm,
      },
    ];

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(15),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IndicatorFormWidget(etapa: widget.etapa),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "Dados de Login",
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
                  "Defina informações que você utilizará para fazer login no app.  Para efetuar login no app você pode utilizar o nome de usuário ou e-mail junto da senha aqui definida.",
                  style: TextStyle(
                    color: AppColors.gray_500,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Dica de Senha:\nCertifique-se de que sua senha seja complexa o suficiente para evitar tentativas de acesso não autorizado. Sua senha deve conter:",
                  style: TextStyle(
                    color: AppColors.gray_500,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              for (var item in dicas)
                Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: AppColors.gray_500,
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            item,
                            style: const TextStyle(
                              color: AppColors.gray_500,
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Text(
                        "Indicador de senha:",
                        style: TextStyle(
                          color: AppColors.gray_500,
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ]
                ),
              ),
              for(var input in inputs)
                InputTextWidget(
                  name: input['name'],
                  label: input['label'],
                  textController: input['controller'],
                  controller: widget.controller,
                  onSaved: widget.controller.onSaved,
                  validator: input['validator'],
                  type: TextInputType.visiblePassword,
                ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ButtonTextWidget(
                    type: "outline",
                    text: "Voltar",
                    textColor: AppColors.blue_500,
                    color: AppColors.blue_500,
                    width: 100,
                    action: widget.voltar,
                  ),
                  ButtonTextWidget(
                    text: "Próximo",
                    textColor: AppColors.blue_500,
                    color: AppColors.green_300,
                    width: 100,
                    action: submitForm,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    //REMOVER LISTENER
    widget.controller.removeListener((){});
    //DISPOSE DOS CONTROLLERS
    senhaController.dispose();
    confirmacaoController.dispose();
    super.dispose();
  }
}