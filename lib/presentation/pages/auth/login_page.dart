import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/core/helpers/app_helper.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/core/theme/app_images.dart';
import 'package:futzada/presentation/widget/buttons/button_svg_widget.dart';
import 'package:futzada/presentation/widget/buttons/button_text_widget.dart';
import 'package:futzada/presentation/widget/inputs/input_text_widget.dart';
import 'package:futzada/presentation/controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //RESGATAR CONTROLLER DE AUTENTICAÇÃO
  AuthController authController = AuthController.instance;
  //DEFINIR CHAVE DO FORMULÁRIO
  final formKey = GlobalKey<FormState>();

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

  //FUNÇÃO DE VALIDAÇÃO DE CAMPOS 
  String? validateField(){
    //VERIFICAR SE EMAIL OU USUÁRIO NÃO ESTÁ VAZIO
    if(authController.userController.text.isEmpty){
      return "O e-mail ou nome de usuário deve ser informados!";
    }
    //VERIFICAR SE password NÃO ESTÁ VAZIO
    if(authController.passwordController.text.isEmpty){
      return "A senha deve ser Informada!";
    }
    return null;
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
        'validator': validateField
      },
      {
        'name':'password',
        'hint': 'Senha',
        'prefixIcon' : AppIcones.lock_outline,
        'sufixIcon' : Icons.visibility_off,
        'controller': authController.passwordController,
        'validator': validateField,
        'type' : TextInputType.visiblePassword,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.green_300,
      extendBodyBehindAppBar: true,
      body: Container(
        padding: const EdgeInsets.all(15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.green_300,
          image: DecorationImage(
            image: const AssetImage(AppImages.cardFootball) as ImageProvider,
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              AppColors.green_300.withAlpha(230), 
              BlendMode.srcATop,
            )
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.maxFinite,
                height: 250,
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
                      ...inputs.map((input){
                        return InputTextWidget(
                          backgroundColor: AppColors.white,
                          textColor: AppColors.grey_300,
                          name: input['name'],
                          hint: input['hint'],
                          prefixIcon: input['prefixIcon'],
                          sufixIcon: input['sufixIcon'],
                          textController: input['controller'],
                          onValidated: (value) => authController.apiService.validateEmpty(value, input['name']),
                          type: input['type'],
                        );
                      }),
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
                child: Text(
                  'Esqueceu sua senha?',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: AppColors.blue_500,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.blue_500
                  ),
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Ainda não possui uma conta ?',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateColor.resolveWith((color){
                          return AppColors.green_300.withAlpha(0);
                        })
                      ),
                      child: Text(
                        'Cadastre-se',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: AppColors.blue_500,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.blue_500
                        ),
                      ),
                      onPressed: (){
                        Get.toNamed('/register/onbording');
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
                    ButtonSvgWidget(
                      icon: AppIcones.google,
                      width: 60,
                      height: 60,
                      action: (){
                        //authController.loginGoogle(context);
                        authController.googleLogin(context);
                      }
                    ),
                    ButtonSvgWidget(
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
        ),
      ),
    );
  }
}