import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/controllers/login_controller.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/buttons/button_icon_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/inputs/input_text_widget.dart';
import 'package:futzada/widget/login_bg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final controller = LoginController();
  //CONTROLLERS DE CADA CAMPO
  final TextEditingController emailController = TextEditingController(text: '');
  final TextEditingController senhaController = TextEditingController(text: '');
  //VARIAVEL DE MENSAGEM DE ERRO
  String? errorMessage;

  @override
  void initState() {
    super.initState();
  }

  //FUNÇÃO PARA RESGATAR OS VALORES DE EMAIL E SENHA
  void onSaved(Map<String, dynamic> updates) {  
    
  }

  //VALIDAÇÃO DE EMAIL E SENHA
  String? validateLogin(){
    //VERIFICAR SE EMAIL OU USUÁRIO NÃO ESTÁ VAZIO
    if(emailController.text.isEmpty){
      return "O e-mail ou nome de usuário deve ser preenchido(a)!";
    }
    //VERIFICAR SE SENHA NÃO ESTÁ VAZIO
    if(senhaController.text.isEmpty){
      return "Senha deve ser preenchido(a)!";
    }
    return null;
  }

  //ENVIAR INFORMAÇÕES DE LOGIN
  void submitForm(){
    //RESGATAR O FORMULÁRIO
    var formData = formKey.currentState;
    //VERIFICAR SE DADOS DA ETAPA FORAM PREENCHIDOS CORRETAMENTE
    if (formData?.validate() ?? false) {
      formData?.save();
      //EFETUAR LOGIN
      login();
    }
  }

  void login() async{
    //TENTAR EFETUAR LOGIN
    var response = controller.login(
      emailController.text,
      senhaController.text
    );
    //MODAL DE STATUS DE REGISTRO DO USUARIO
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(150.0),
          ),
          child: FutureBuilder<Map<String, dynamic>>(
            future: response,
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  width: 300,
                  height: 300,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.green_300,
                    )
                  )
                );
              }else if(snapshot.hasError) {
                //ADICIONAR MENSAGEM DE ERRO
                errorMessage = 'Houve um erro ao efetuar login.';
              }else if(snapshot.hasData) {
                //RESGATAR RETORNO DO SERVIDOR
                var data = snapshot.data!;
                //VERIFICAR SE OPERAÇÃO FOI BEM SUCEDIDA
                if (data['status'] == 200) {
                  //NAVEGAR PARA HOME PAGE
                  //Navigator.pushReplacementNamed(context, "/home");
                }else{
                  //ADICIONAR MENSAGEM DE ERRO
                  errorMessage = data['message'];
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
    //ESPERAR POR 5 SEGUNDOS
    await Future.delayed(Duration(seconds: 2));
    //VERIRICAR SE HOUVE ERRO NO ENVIO DOS DADOS
    if(errorMessage != null){
      Navigator.of(context).pop();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    //LISTA DE CAMPOS
    final List<Map<String, dynamic>> inputs = [
      {
        'name': 'email',
        'label': 'Usuário ou E-mail',
        'icon' : AppIcones.user["far"],
        'controller': emailController,
        'validator': validateLogin
      },
      {
        'name':'senha',
        'label': 'Senha',
        'icon' : AppIcones.lock["far"],
        'controller': senhaController,
        'validator': validateLogin,
        'type' : TextInputType.visiblePassword,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.green_300,
      body: SafeArea(
        child: Stack(
          children: [
            const LoginBg(),
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
                              if(errorMessage != null)
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.red_300,
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: Text(
                                    errorMessage!,
                                    style: const TextStyle(color: AppColors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              for(var input in inputs)
                                InputTextWidget(
                                  name: input['name'],
                                  label: input['label'],
                                  icon: input['icon'],
                                  textController: input['controller'],
                                  controller: controller,
                                  onSaved: onSaved,
                                  validator: input['validator'],
                                  type: input['type'],
                                ),
                              ButtonTextWidget(
                                text: "Entrar",
                                textColor: AppColors.white,
                                color: AppColors.blue_500,
                                width: double.infinity,
                                action: submitForm,
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: const Text(
                          'Esqueceu sua senha ?',
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
                                Navigator.pushNamed(context, "/cadastro");
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
                              icon: AppIcones.google["fas"],
                              dimensions: 60,
                              action: (){
                                controller.googleLogin(context);
                              }
                            ),
                            /* ButtonIconWidget(
                              icon: AppIcones.facebook["fas"],
                              iconColor: AppColors.blue_300,
                              dimensions: 60,
                              action: (){
                                print('Login facebook');
                              }
                            ) */
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
  @override
  void dispose() {
    //DISPOSE DOS CONTROLLERS
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }
}