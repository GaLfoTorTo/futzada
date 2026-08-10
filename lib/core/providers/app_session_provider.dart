import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppSession { loading, unauthenticated, firstLogin, authenticated }

class AppSessionNotifier extends Notifier<AppSession> {
  @override
  AppSession build() => AppSession.loading;

  void setUnauthenticated() => _set(AppSession.unauthenticated);
  void setFirstLogin()      => _set(AppSession.firstLogin);
  void setAuthenticated()   => _set(AppSession.authenticated);

  void _set(AppSession next) {
    if (state == AppSession.loading) FlutterNativeSplash.remove();
    state = next;
  }
}

final appSessionProvider = NotifierProvider<AppSessionNotifier, AppSession>(
  AppSessionNotifier.new,
);
