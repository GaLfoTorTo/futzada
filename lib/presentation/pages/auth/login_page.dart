import 'package:esportly/presentation/widget/buttons/button_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:esportly/core/theme/app_colors.dart';
import 'package:esportly/core/theme/app_icones.dart';
import 'package:esportly/core/theme/app_images.dart';
import 'package:esportly/core/helpers/app_helper.dart';
import 'package:esportly/core/helpers/loading_overlay.dart';
import 'package:esportly/presentation/widget/buttons/button_svg_widget.dart';
import 'package:esportly/presentation/widget/buttons/button_text_widget.dart';
import 'package:esportly/presentation/widget/inputs/input_text_widget.dart';
import 'package:esportly/presentation/controllers/auth_controller.dart';

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

  //FUNÇÃO DE CHAMADA DE OVERLAY E LOGIN
  Future<void> logar(type) async {
    //RESGATAR O FORMULÁRIO
    var formData = formKey.currentState;
    //VERIFICAR SE DADOS DA ETAPA FORAM PREENCHIDOS CORRETAMENTE
    if (type == 'platform') {
      if (formData?.validate() ?? false) {
        formData?.save();
      }
    }
    //EXIBIR OVERLAY DE CARREGAMENTO
    try {
      await LoadingOverlay.show(
        context,
        () async => await authController.login(type: type),
        barrierColor: AppColors.dark_700.withAlpha(179),
      );
    } catch (e) {
      if (mounted) {
        AppHelper.feedbackMessage(context, AppHelper.extractErrorMessage(e));
      }
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
        'prefixIcon' : Icons.person,
        'sufixIcon' : null,
        'controller': authController.userController,
        'validator': validateField
      },
      {
        'name':'password',
        'hint': 'Senha',
        'prefixIcon' : Icons.lock,
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
                height: 300,
                child: Column(
                  spacing: 10,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:40),
                      child: SvgPicture.asset(
                        AppIcones.logo,
                        width: 150,
                        height: 150,
                      ),
                    ),
                    Text(
                      'E-sportly',
                      style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontSize: 30,
                        color: AppColors.blue_500
                      )
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                child: Form(
                  key: formKey,
                  child: Column(
                    spacing: 5,
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
                          onValidated: (value) => input['validator'],
                          type: input['type'],
                        );
                      }),
                      ButtonTextWidget(
                        text: "Entrar",
                        textSize: 20,
                        textColor: AppColors.white,
                        backgroundColor: AppColors.blue_500,
                        width: double.infinity,
                        action: () => logar('plataform'),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: double.maxFinite,
                height: 100,
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ButtonSvgWidget(
                      icon: AppIcones.google,
                      width: 60,
                      height: 60,
                      action: () => logar('google')
                    ),
                    ButtonIconWidget(
                      icon: AppIcones.user_plus_solid,
                      iconSize: 30,
                      iconColor: AppColors.grey_700,
                      backgroundColor: AppColors.white,
                      padding: 15,
                      action: () => context.push('/register/onboarding')
                    ),
                    /* ButtonSvgWidget(
                      icon: AppIcones.facebook,
                      width: 60,
                      height: 60,
                      action: () => logar('facebook')
                    ), */
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