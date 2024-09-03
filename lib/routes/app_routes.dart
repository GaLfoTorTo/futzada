import 'package:futzada/pages/cadastro/conclusao_step.dart';
import 'package:futzada/pages/pelada/cadastro/dados_endereco_step.dart';
import 'package:get/get.dart';
import 'package:futzada/pages/app_base.dart';
import 'package:futzada/pages/splash_page.dart';
import 'package:futzada/pages/auth/login_page.dart';
import 'package:futzada/pages/apresentacao/apresentacao_page.dart';
import 'package:futzada/pages/cadastro/apresentacao_step.dart';
import 'package:futzada/pages/cadastro/dados_basicos_step.dart';
import 'package:futzada/pages/cadastro/modalidades_step.dart';
import 'package:futzada/pages/cadastro/modalidade_jogador_step.dart';
import 'package:futzada/pages/cadastro/modalidade_tecnico_step.dart';
import 'package:futzada/pages/pelada/cadastro/dados_pelada_step.dart';

class AppRoutes {
  static final routes = [
      GetPage(name: "/splash", page: () => const SplashPage()),
      GetPage(name: "/apresentacao", page: () => const ApresentacaoPage()),
      GetPage(name: "/login", page: () => const LoginPage()),
      //CADASTRO
      GetPage(name: "/cadastro/apresentacao", page: () =>  const ApresentacaoStep(), transition: Transition.rightToLeft),
      GetPage(name: "/cadastro/dados_basicos", page: () =>  const DadosBasicosStep(), transition: Transition.rightToLeft),
      GetPage(name: "/cadastro/modalidades", page: () =>  const ModalidadesStep(), transition: Transition.rightToLeft),
      GetPage(name: "/cadastro/jogador", page: () =>  const ModalidadeJogadorStep(), transition: Transition.leftToRight),
      GetPage(name: "/cadastro/tecnico", page: () =>  const ModalidadeTecnicoStep(), transition: Transition.leftToRight),
      GetPage(name: "/cadastro/conclusao", page: () =>  const ConclusaoStep(), transition: Transition.leftToRight),
      //HOME
      GetPage(name: "/home", page: () => const AppBase()),
      //ESCALAÇÃO
      GetPage(name: "/escalacao", page: () => const DadosBasicosStep()),
      //PELADAS - CADASTRO 
      GetPage(name: "/pelada/cadastro/dados_pelada", page: () => const DadosPeladaStep(), transition: Transition.rightToLeft),
      GetPage(name: "/pelada/cadastro/dados_endereco", page: () => const DadosEnderecoStep(), transition: Transition.rightToLeft),
  ];
}