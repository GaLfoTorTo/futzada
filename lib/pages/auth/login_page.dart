import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:futzada/widget/buttons/button_icon_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/inputs/input_text_widget.dart';
import 'package:futzada/controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //DEFINIR CHAVE DO FORMULÁRIO
  final formKey = GlobalKey<FormState>();
  //RESGATAR CONTROLLER DE AUTENTICAÇÃO
  AuthController authController = AuthController.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //ENVIAR INFORMAÇÕES DE LOGIN
  void submitForm(){
    //RESGATAR O FORMULÁRIO
    var formData = formKey.currentState;
    //VERIFICAR SE DADOS DA ETAPA FORAM PREENCHIDOS CORRETAMENTE
    if (formData?.validate() ?? false) {
      formData?.save();
      //EXIBIR OVERLAY DE CARREGAMENTO
      Get.showOverlay(
        asyncFunction: () async {
          //TENTAR EFETUAR LOGIN
          final response = await authController.login();
          //ESPERAR 5 SEGUNDOS ANTES DE EXECUTAR FUNÇÃO DE CRONOMETRO
          if (response['status'] != 200) {
            //EXIBIR MENSAGEM DE ERRO
            AppHelper.feedbackMessage(context, "Houve um erro ao enviar as informações, tente novamente.");
          }
        },
        loadingWidget: const Material(
          color: Colors.transparent,
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.green_300,

            ),
          ),
        ),
        opacity: 0.7,
        opacityColor: AppColors.dark_700,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //LISTA DE CAMPOS
    final List<Map<String, dynamic>> inputs = [
      {
        'name': 'user',
        'hint': 'Usuário ou E-mail',
        'prefixIcon' : AppIcones.user_outline,
        'sufixIcon' : null,
        'controller': authController.userController,
        'validator': authController.validateUser
      },
      {
        'name':'password',
        'hint': 'Senha',
        'prefixIcon' : AppIcones.lock_outline,
        'sufixIcon' : Icons.visibility_off,
        'controller': authController.passwordController,
        'validator': authController.validatePassword,
        'type' : TextInputType.visiblePassword,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.green_300,
      body: SafeArea(
        child: Stack(
          children: [
            Stack(
              children: [
                Image.asset(
                  AppImages.gramado,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Container(
                  color: AppColors.green_300.withAlpha(170),
                  width: double.infinity,
                  height: double.infinity,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.maxFinite,
                        height: 230,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left:40),
                              child: SvgPicture.asset(
                                AppIcones.logo,
                                width: 130,
                                height: 130,
                              ),
                            ),
                            const Text(
                              'Futzada',
                              style: TextStyle(
                                color: AppColors.blue_500,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              for(var input in inputs)
                                InputTextWidget(
                                  name: input['name'],
                                  hint: input['hint'],
                                  prefixIcon: input['prefixIcon'],
                                  sufixIcon: input['sufixIcon'],
                                  textController: input['controller'],
                                  onValidated: (value) => authController.formService.validateEmpty(value, input['name']),
                                  type: input['type'],
                                ),
                              ButtonTextWidget(
                                text: "Entrar",
                                textColor: AppColors.white,
                                backgroundColor: AppColors.blue_500,
                                width: double.infinity,
                                action: submitForm,
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: double.maxFinite,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: const Text(
                          'Esqueceu sua senha?',
                          style: TextStyle(
                            color: AppColors.blue_500,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Ainda não possui uma conta ?',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateColor.resolveWith((color){
                                  return AppColors.green_300.withAlpha(0);
                                })
                              ),
                              child: const Text(
                                'Cadastre-se',
                                style: TextStyle(
                                  color: AppColors.blue_500,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline
                                ),
                              ),
                              onPressed: (){
                                Get.toNamed('/register/apresentacao');
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ButtonIconWidget(
                              icon: AppIcones.google,
                              width: 60,
                              height: 60,
                              action: (){
                                authController.googleLogin(context);
                              }
                            ),
                            ButtonIconWidget(
                              icon: AppIcones.facebook,
                              width: 60,
                              height: 60,
                              action: (){
                                //controller.googleLogin(context);
                              }
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}