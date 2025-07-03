import 'package:get/get.dart';
import 'package:futzada/pages/app_base.dart';
import 'package:futzada/pages/splash_page.dart';
import 'package:futzada/pages/onboarding/onboarding_page.dart';
import 'package:futzada/pages/auth/login_page.dart';
import 'package:futzada/pages/auth/register/apresentacao_step.dart';
import 'package:futzada/pages/auth/register/register_basic_step.dart';
import 'package:futzada/pages/auth/register/modes_step.dart';
import 'package:futzada/pages/auth/register/player_mode_step.dart';
import 'package:futzada/pages/auth/register/manager_mode_step.dart';
import 'package:futzada/pages/auth/register/conclusion_step.dart';
import 'package:futzada/pages/escalation/escalation_page.dart';
import 'package:futzada/pages/escalation/historic_page.dart';
import 'package:futzada/pages/escalation/market_page.dart';
import 'package:futzada/pages/event/list/event_list.dart';
import 'package:futzada/pages/event/register/event_config_game_step.dart';
import 'package:futzada/pages/event/view/event_historic_page.dart';
import 'package:futzada/pages/event/view/event_page.dart';
import 'package:futzada/pages/games/config/game_config_page.dart';
import 'package:futzada/pages/games/detail/game_detail_page.dart';
import 'package:futzada/pages/games/detail/games_list_page%20.dart';
import 'package:futzada/pages/chat/chats.dart';
import 'package:futzada/pages/chat/chat_private.dart';
import 'package:futzada/pages/event/register/event_basic_step.dart';
import 'package:futzada/pages/event/register/event_address_step.dart';
import 'package:futzada/pages/event/register/event_participants_step.dart';
import 'package:futzada/pages/explore/map/map_widget.dart';
import 'package:futzada/pages/explore/map/map_picker.dart';

class AppRoutes {
  static final routes = [
      GetPage(name: "/splash", page: () => const SplashPage()),
      GetPage(name: "/apresentacao", page: () => const OnboardingPage(), transition: Transition.rightToLeft),
      GetPage(name: "/login", page: () => const LoginPage(), transition: Transition.leftToRight),
      //REGISTRO DE USUÁRIO
      GetPage(name: "/register/apresentacao", page: () =>  const ApresentacaoStep(), transition: Transition.rightToLeft),
      GetPage(name: "/register/dados_basicos", page: () =>  const RegisterBasicStep(), transition: Transition.rightToLeft),
      GetPage(name: "/register/modos", page: () =>  const ModesStep(), transition: Transition.rightToLeft),
      GetPage(name: "/register/jogador", page: () =>  const PlayerModeStep(), transition: Transition.leftToRight),
      GetPage(name: "/register/tecnico", page: () =>  const ManagerModeStep(), transition: Transition.leftToRight),
      GetPage(name: "/register/Conclusion", page: () =>  const ConclusionStep(), transition: Transition.leftToRight),
      //HOME
      GetPage(name: "/home", page: () => const AppBase()),
      //CHAT
      GetPage(name: "/chats", page: () => const ChatsPage(), transition: Transition.rightToLeft),
      GetPage(name: "/chat_private", page: () => const ChatPrivatePage(), transition: Transition.rightToLeft),
      //ESCALAÇÃO
      GetPage(name: "/escalation", page: () => const EscalationPage()),
      GetPage(name: "/escalation/market", page: () => const MarketPage()),
      GetPage(name: "/escalation/historic", page: () => const HistoricPage()),
      //PARTIDAS
      GetPage(name: "/games/list", page: () => const GamesListPage()),
      GetPage(name: "/games/config", page: () => const GameConfigPage()),
      GetPage(name: "/games/overview", page: () => const GameDetailPage()),
      //EVENTS - CADASTRO 
      GetPage(name: "/event/register/basic", page: () => const EventBasicStep(), transition: Transition.rightToLeft),
      GetPage(name: "/event/register/address", page: () => const EventAddressStep(), transition: Transition.rightToLeft),
      GetPage(name: "/event/register/config_games", page: () => const EventConfigGameStep(), transition: Transition.rightToLeft),
      GetPage(name: "/event/register/participants", page: () => const EventParticipantsStep(), transition: Transition.rightToLeft),
      //EVENTS - VIEW GERAL
      GetPage(name: "/event/geral", page: () => const EventPage(), transition: Transition.rightToLeft),
      GetPage(name: "/event/historic", page: () => const EventHistoricPage(), transition: Transition.rightToLeft),
      //EVENTS - LISTA
      GetPage(name: "/event/list", page: () => const EventListPage(), transition: Transition.rightToLeft),
      //EXPLORE MAPA
      GetPage(name: "/explore/map", page: () => const MapaPage(), transition: Transition.rightToLeft),
      GetPage(name: "/explore/map/picker", page: () => const MapPickerPage(), transition: Transition.rightToLeft),
  ];
}