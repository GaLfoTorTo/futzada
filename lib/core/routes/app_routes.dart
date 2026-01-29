import 'package:get/get.dart';
import 'package:futzada/presentation/pages/app_base.dart';
import 'package:futzada/presentation/pages/splash_page.dart';
import 'package:futzada/presentation/pages/auth/login_page.dart';
import 'package:futzada/presentation/pages/register/onboarding_step.dart';
import 'package:futzada/presentation/pages/register/register_form.dart';
import 'package:futzada/presentation/pages/register/modes_step.dart';
import 'package:futzada/presentation/pages/register/player_mode_step.dart';
import 'package:futzada/presentation/pages/register/manager_mode_step.dart';
import 'package:futzada/presentation/pages/register/conclusion_step.dart';
import 'package:futzada/presentation/pages/onboarding/onboarding_page.dart';
import 'package:futzada/presentation/pages/profile/profile_page.dart';
import 'package:futzada/presentation/pages/chat/chats.dart';
import 'package:futzada/presentation/pages/chat/chat_private.dart';
import 'package:futzada/presentation/pages/escalation/escalation_page.dart';
import 'package:futzada/presentation/pages/escalation/historic_page.dart';
import 'package:futzada/presentation/pages/escalation/market_page.dart';
import 'package:futzada/presentation/pages/escalation/statistics_page.dart';
import 'package:futzada/presentation/pages/games/detail/game_detail_page.dart';
import 'package:futzada/presentation/pages/games/detail/games_day_page%20.dart';
import 'package:futzada/presentation/pages/games/config/game_config_page.dart';
import 'package:futzada/presentation/pages/games/config/game_random_teams_page.dart';
import 'package:futzada/presentation/pages/event/view/event_list_page.dart';
import 'package:futzada/presentation/pages/event/view/event_page.dart';
import 'package:futzada/presentation/pages/event/view/event_settings_page.dart.dart';
import 'package:futzada/presentation/pages/event/view/event_historic_page.dart';
import 'package:futzada/presentation/pages/event/register/event_config_game_step.dart';
import 'package:futzada/presentation/pages/event/register/event_basic_step.dart';
import 'package:futzada/presentation/pages/event/register/event_address_step.dart';
import 'package:futzada/presentation/pages/event/register/event_participants_step.dart';
import 'package:futzada/presentation/pages/explore/map/map_picker.dart';
import 'package:futzada/presentation/pages/explore/map/map_explorer.dart';
import 'package:futzada/presentation/pages/explore/explore_filter_page.dart';
import 'package:futzada/presentation/pages/explore/explore_search_page.dart';

class AppRoutes {
  static final routes = [
      GetPage(name: "/splash", page: () => const SplashPage()),
      GetPage(name: "/onboarding", page: () => const OnboardingPage(), transition: Transition.rightToLeft),
      GetPage(name: "/login", page: () => const LoginPage(), transition: Transition.leftToRight),
      //REGISTRO DE USUÁRIO
      GetPage(name: "/register/onbording", page: () =>  const OnboardingStep(), transition: Transition.rightToLeft),
      GetPage(name: "/register", page: () =>  const RegisterStep(), transition: Transition.rightToLeft),
      GetPage(name: "/register/player", page: () =>  const PlayerModeStep(), transition: Transition.leftToRight),
      GetPage(name: "/register/manager", page: () =>  const ManagerModeStep(), transition: Transition.leftToRight),
      //HOME
      GetPage(name: "/home", page: () => const AppBase()),
      //CHAT
      GetPage(name: "/profile", page: () => const ProfilePage(), transition: Transition.rightToLeft),
      //CHAT
      GetPage(name: "/chats", page: () => const ChatsPage(), transition: Transition.rightToLeft),
      GetPage(name: "/chat_private", page: () => const ChatPrivatePage(), transition: Transition.rightToLeft),
      //ESCALAÇÃO
      GetPage(name: "/escalation", page: () => const EscalationPage()),
      GetPage(name: "/escalation/statistics", page: () => const StatisticsPage()),
      GetPage(name: "/escalation/market", page: () => const MarketPage()),
      GetPage(name: "/escalation/historic", page: () => const HistoricPage()),
      //PARTIDAS
      GetPage(name: "/games/day", page: () => const GamesDayPage()),
      GetPage(name: "/games/config", page: () => const GameConfigPage()),
      GetPage(name: "/games/teams", page: () => const GameRandomTeamsPage()),
      GetPage(name: "/games/overview", page: () => const GameDetailPage()),
      //EVENTS - CADASTRO 
      GetPage(name: "/event/register/basic", page: () => const EventBasicStep(), transition: Transition.rightToLeft),
      GetPage(name: "/event/register/address", page: () => const EventAddressStep(), transition: Transition.rightToLeft),
      GetPage(name: "/event/register/config_games", page: () => const EventConfigGameStep(), transition: Transition.rightToLeft),
      GetPage(name: "/event/register/participants", page: () => const EventParticipantsStep(), transition: Transition.rightToLeft),
      //EVENTS - VIEW GERAL
      GetPage(name: "/event/geral", page: () => const EventPage(), transition: Transition.rightToLeft),
      GetPage(name: "/event/settings", page: () => const EventSettingsPage(), transition: Transition.rightToLeft),
      GetPage(name: "/event/historic", page: () => const EventHistoricPage(), transition: Transition.rightToLeft),
      GetPage(name: "/event/list", page: () => const EventListPage(), transition: Transition.rightToLeft),
      //EXPLORE MAPA
      GetPage(name: "/explore/map", page: () => const MapExplorePage(), transition: Transition.rightToLeft),
      GetPage(name: "/explore/map/picker", page: () => const MapPickerPage(), transition: Transition.rightToLeft),
      GetPage(name: "/explore/search", page: () => const ExploreSearchPage(), transition: Transition.rightToLeft),
      GetPage(name: "/explore/filter", page: () => const ExploreFilterPage(), transition: Transition.rightToLeft),
  ];
}