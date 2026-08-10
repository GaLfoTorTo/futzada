import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Indica se a navegação principal está pronta (dados da home carregados).
/// Escrito por HomeController via ProviderContainer global (GetIt).
/// Lido por NavigationBarWidget via ref.watch.
class NavReadyNotifier extends Notifier<bool> {
  @override
  bool build() => false;
}

final navReadyProvider = NotifierProvider<NavReadyNotifier, bool>(NavReadyNotifier.new);
