import 'package:futzada/pages/cadastro/cadastro_page.dart';
import 'package:futzada/pages/app_base.dart';
import 'package:futzada/pages/login_page.dart';
import 'package:futzada/pages/splash_page.dart';

class AppRoutes {
  static final routes = {
      "/splash": (context) => const SplashPage(),
      "/login": (context) => const LoginPage(),
      "/cadastro": (context) =>  const CadastroPage(),
      "/home": (context) => const AppBase(),
    };
}