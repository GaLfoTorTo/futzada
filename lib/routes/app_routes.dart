import 'package:get/get.dart';
import 'package:futzada/pages/event/register/event_basic_step.dart';
import 'package:futzada/pages/event/register/event_address_step.dart';
import 'package:futzada/pages/event/register/event_participants_step.dart';
import 'package:futzada/pages/app_base.dart';
import 'package:futzada/pages/splash_page.dart';
import 'package:futzada/pages/auth/login_page.dart';
import 'package:futzada/pages/onboarding/onboarding_page.dart';
import 'package:futzada/pages/register/apresentacao_step.dart';
import 'package:futzada/pages/register/register_basic_step.dart';
import 'package:futzada/pages/register/modes_step.dart';
import 'package:futzada/pages/register/player_mode_step.dart';
import 'package:futzada/pages/register/manager_mode_step.dart';
import 'package:futzada/pages/register/conclusion_step.dart';
import 'package:futzada/pages/map/map_widget.dart';

class AppRoutes {
  static final routes = [
      GetPage(name: "/splash", page: () => const SplashPage()),
      GetPage(name: "/apresentacao", page: () => const OnboardingPage(), transition: Transition.rightToLeft),
      GetPage(name: "/login", page: () => const LoginPage(), transition: Transition.leftToRight),
      //register
      GetPage(name: "/register/apresentacao", page: () =>  const ApresentacaoStep(), transition: Transition.rightToLeft),
      GetPage(name: "/register/dados_basicos", page: () =>  const RegisterBasicStep(), transition: Transition.rightToLeft),
      GetPage(name: "/register/modos", page: () =>  const ModesStep(), transition: Transition.rightToLeft),
      GetPage(name: "/register/jogador", page: () =>  const PlayerModeStep(), transition: Transition.leftToRight),
      GetPage(name: "/register/tecnico", page: () =>  const ManagerModeStep(), transition: Transition.leftToRight),
      GetPage(name: "/register/Conclusion", page: () =>  const ConclusionStep(), transition: Transition.leftToRight),
      //HOME
      GetPage(name: "/home", page: () => const AppBase()),
      //ESCALAÇÃO
      GetPage(name: "/escalacao", page: () => const RegisterBasicStep()),
      //PELADAS - CADASTRO 
      GetPage(name: "/event/register/event_basic", page: () => const EventBasicStep(), transition: Transition.rightToLeft),
      GetPage(name: "/event/register/event_address", page: () => const EventAddressStep(), transition: Transition.rightToLeft),
      GetPage(name: "/event/register/event_participants", page: () => const EventParticipantsStep(), transition: Transition.rightToLeft),
      //EXPLORE MAPA
      GetPage(name: "/explore/mapa", page: () => const MapaPage(), transition: Transition.rightToLeft),
  ];
}