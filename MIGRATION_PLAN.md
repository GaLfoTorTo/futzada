# Plano de Migração: GetX → Riverpod

## 1. Diagnóstico Geral

### O que já está feito
| Item | Status |
|------|--------|
| Roteamento (GoRouter) | ✅ Concluído |
| DI de serviços e repos (GetIt/`sl`) | ✅ Concluído |
| `ProviderScope` na raiz (`main.dart`) | ✅ Concluído |
| Pacotes `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator` | ✅ No pubspec |
| `AuthController` sem `GetxController` | ✅ Parcialmente migrado |

### O que ainda falta
| Item | Dimensão |
|------|----------|
| Arquivos com `import 'package:get/get.dart'` | **150 arquivos** |
| Controllers que estendem `GetxController` | **19 classes** |
| Mixins que usam `.obs` e GetX | **12 mixins** |
| Arquivos com chamadas `Get.*` (Get.dialog, Get.back, etc.) | **68 arquivos** |

### Os dois problemas distintos

O GetX está sendo usado por **duas razões independentes** no projeto. É importante não confundi-las:

**Problema A — State management:** `GetxController`, `.obs`, `Obx()`, `ever()`, `Worker`  
→ Substituir por `Notifier`/`AsyncNotifier` + `ref.watch`

**Problema B — Utilitários de UI do GetX:** `Get.dialog`, `Get.showOverlay`, `Get.back`, `Get.toNamed`, `Get.changeTheme`  
→ Substituir pelas APIs nativas do Flutter/GoRouter

Ambos precisam ser resolvidos para remover o pacote `get`.

---

## 2. Decisões de Arquitetura

### DI: manter GetIt, não migrar para Riverpod
Os serviços e repositórios já estão bem organizados no GetIt. Migrar tudo para providers Riverpod seria retrabalho sem ganho funcional agora. A estratégia é: **GetIt para serviços/repos, Riverpod para estado**.

### Padrão Riverpod: code generation
Já tem `riverpod_annotation` + `riverpod_generator` instalados. Usar `@riverpod` com `build_runner` é o padrão mais moderno e manutenível.

### Padrão dos controllers
Cada `GetxController` se torna um `Notifier` ou `AsyncNotifier`. Os mixins se transformam em **extensões da classe Notifier** ou são quebrados em **providers separados** por responsabilidade.

### AppWidget: tema via ref.watch
O `ThemeController` usa `Get.changeTheme` e `Get.changeThemeMode`. Após a migração, o `AppWidget` vira `ConsumerWidget` e lê o tema de um `themeProvider`.

---

## 3. Mapa de Correspondência GetX → Riverpod

| GetX | Riverpod |
|------|----------|
| `extends GetxController` | `class XNotifier extends Notifier<XState>` |
| `RxBool x = false.obs` | campo do estado `XState` |
| `Obx(() => Widget)` | `Consumer(builder: (ctx, ref, _) => Widget)` |
| `ever(obs, callback)` | `ref.listen(provider, callback)` em widget ou `ref.listenSelf` em notifier |
| `Worker` | cancelamento manual de `ProviderSubscription` |
| `Get.dialog(...)` | `showDialog(context, ...)` |
| `Get.showOverlay(asyncFn)` | estado de loading + `showDialog` ou overlay manual |
| `Get.back()` | `context.pop()` (GoRouter) |
| `Get.toNamed('/rota')` | `context.push('/rota')` (GoRouter) |
| `Get.offAllNamed('/rota')` | `context.go('/rota')` (GoRouter) |
| `Get.changeTheme(t)` | `ref.read(themeProvider.notifier).setTheme(t)` |
| `Get.find<X>(tag: 'y')` | `ref.read(xProvider)` |

---

## 4. Fases da Migração

A lógica das fases é: do mais simples e de maior impacto para o mais complexo. Cada fase deve compilar e rodar antes de passar para a próxima.

---

### FASE 0 — Pré-migração: eliminar Get.* de UI (sem tocar em estado)

**Objetivo:** remover as chamadas de utilitário do GetX (`Get.dialog`, `Get.back`, `Get.toNamed`, `Get.showOverlay`) sem alterar nenhum controller ainda. Isso reduz as dependências do pacote `get` significativamente.

**Ações:**
- `Get.back()` → `context.pop()` ou `Navigator.of(context).pop()`
- `Get.toNamed('/x')` → `context.push('/x')`
- `Get.offAllNamed('/x')` → `context.go('/x')`
- `Get.dialog(...)` → `showDialog(context: context, builder: ...)`
- `Get.showOverlay(asyncFn)` → criar um `LoadingOverlay` helper estático que mostra `CircularProgressIndicator` via `showDialog` com `barrierDismissible: false`

**Arquivos principais afetados:** `login_page.dart`, `navigation_controller.dart`, `app_controller.dart`, todos os controllers com navegação.

**Critério de conclusão:** `Get.back`, `Get.toNamed`, `Get.offAllNamed`, `Get.dialog`, `Get.showOverlay` somem do código.

---

### FASE 1 — ThemeController → themeProvider

**Objetivo:** desacoplar o tema do GetX. É o primeiro controller a migrar porque bloqueia a remoção de `Get.changeTheme` e afeta o `AppWidget`.

**Estrutura alvo:**
```dart
// lib/core/providers/theme_provider.dart

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeState build() => ThemeState.fromStorage(GetStorage());

  void alterTheme() { ... }
  void setModality(String modality) { ... }
  Color get primaryColor => state.primaryColor;
}

class ThemeState {
  final ThemeMode themeMode;
  final String mainModality;
  final Color primaryColor;
  ...
}
```

**AppWidget após a migração:**
```dart
class AppWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeNotifierProvider);
    return MaterialApp.router(
      routerConfig: AppRoutes.routes,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: theme.themeMode,
    );
  }
}
```

**Substitui:** `ThemeController.instance`, `Get.changeTheme(...)`, `Get.changeThemeMode(...)`

---

### FASE 2 — Sessão do usuário: GetIt → providers Riverpod

**Objetivo:** substituir o padrão atual de registrar `UserModel`, `List<EventModel>`, `Position`, `LatLng` no GetIt como singletons de sessão. Isso é o coração do `session.dart` e `AppController`.

**Estrutura alvo:**
```dart
// lib/core/providers/session_provider.dart

@Riverpod(keepAlive: true)
class SessionNotifier extends _$SessionNotifier {
  @override
  SessionState build() => const SessionState.empty();

  Future<void> login(UserModel user, String token) async { ... }
  Future<void> logout() async { ... }
}

class SessionState {
  final UserModel? user;
  final List<EventModel> events;
  final Position? position;
  final LatLng? latLng;
  ...
}
```

**O que muda:**
- `sl<UserModel>(instanceName: 'user')` → `ref.read(sessionNotifierProvider).user`
- `sl<List<EventModel>>(instanceName: 'events')` → `ref.read(sessionNotifierProvider).events`
- `registerSession(user)` / `registerEvents(user)` / `registerLocation(context)` → métodos do `SessionNotifier`
- `AuthController.clearUser()` → `ref.read(sessionNotifierProvider.notifier).logout()`

**Impacto:** AuthController, AppController, HomeController, EventController, EscalationController (todos leem `sl<UserModel>` hoje).

---

### FASE 3 — AuthController e fluxo de inicialização

**Objetivo:** transformar o `AuthController` (já é uma plain class, não GetxController) e o `AppController` em um fluxo limpo de Riverpod.

**AuthController** vira um `Notifier` com estado de autenticação:
```dart
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() => AuthState.initial();

  Future<void> login({String? type}) async { ... }
  Future<void> logout() async { ... }
}
```

**AppController** — a lógica de inicialização (buscar usuário, registrar sessão, navegar) migra para um `FutureProvider` ou para o `onInit` do `AuthNotifier`.

O **GoRouter** pode usar `ref.read(authNotifierProvider)` no `redirect` para controlar acesso às rotas, eliminando a necessidade de navegar programaticamente do controller.

```dart
// Em AppRoutes
redirect: (context, state) {
  final authState = ref.read(authNotifierProvider);
  if (!authState.isAuthenticated && !isPublicRoute(state.uri)) {
    return '/login';
  }
  return null;
}
```

---

### FASE 4 — NavigationController e ShowcaseController

Controladores simples, bom ponto de entrada para pegar ritmo.

**NavigationController** → `@riverpod` com estado de índice da aba:
```dart
@riverpod
class NavigationNotifier extends _$NavigationNotifier {
  @override
  int build() => 0;
  void setIndex(int i) => state = i;
}
```

As telas (`_screens`) são declaradas diretamente na widget `AppBase`, não precisam de state.

**ShowcaseController** → `@riverpod` simples com estado booleano de progresso do showcase.

---

### FASE 5 — UserController e HomeController

**UserController** é trivial hoje (só expõe `isReady`). Com Riverpod, o dado do usuário já vem do `sessionNotifierProvider`. Provavelmente some como controller separado.

**HomeController** → `AsyncNotifier`:
```dart
@riverpod
class HomeNotifier extends _$HomeNotifier {
  @override
  Future<HomeState> build() => _fetchHome();
  
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchHome);
  }
}
```

Isso elimina os `isLoading`/`hasError`/`isReady` manuais — o `AsyncValue` do Riverpod gerencia os três estados automaticamente (loading, error, data).

---

### FASE 6 — EventController (+ 6 mixins)

O maior controlador de negócio. Os 6 mixins (`EventOverviewMixin`, `EventConfigMixin`, `EventRegisterMixin`, `EventRankMixin`, `EventParticipantsMixin`, `EventRulesMixin`) encapsulam domínios distintos.

**Estratégia:** manter a separação dos mixins mas como **providers independentes** que compartilham o estado do evento selecionado via `selectedEventProvider`.

```dart
// provider do evento selecionado (pivô central)
@riverpod
class SelectedEventNotifier extends _$SelectedEventNotifier {
  @override
  EventModel? build() => null;
  void select(EventModel event) => state = event;
}

// providers de domínio (leem o evento selecionado)
@riverpod
class EventOverviewNotifier extends _$EventOverviewNotifier { ... }

@riverpod
class EventRegisterNotifier extends _$EventRegisterNotifier { ... }
```

Isso é mais limpo que um único controller gigante com mixins.

---

### FASE 7 — GameController (+ 7 mixins) — O mais complexo

O `GameController` tem 30+ variáveis `.obs` cobrindo: partida ao vivo, cronômetro, placar, estatísticas, votação, escalação, stream em tempo real.

**Estratégia: não tentar migrar tudo de uma vez.** Dividir em providers por domínio de jogo:

| Provider | Responsabilidade |
|----------|-----------------|
| `gameMatchProvider` | Estado da partida atual (placar, cartas, posse) |
| `gameStopwatchProvider` | Cronômetro (timer isolado) |
| `gameStreamProvider` | WebSocket/stream em tempo real |
| `gameVoteProvider` | Votação de MVP e resultado |
| `gameScheduleProvider` | Agenda do dia de jogo |
| `gameDayEventProvider` | Presença de jogadores no dia |
| `gameConfigProvider` | Configurações da partida |

O `GameStreamService` que usa WebSocket/Pusher pode ser exposto como `StreamProvider`, que Riverpod gerencia nativamente.

---

### FASE 8 — EscalationController (+ 3 mixins)

Semelhante ao EventController. Os três mixins (`EscalationManagerMixin`, `EscalationMarketMixin`, `EscalationTeamMixin`) viram providers de domínio separados que leem `selectedEventProvider`.

---

### FASE 9 — Controllers menores

Em ordem de complexidade crescente:

1. **RegisterController** → `Notifier<RegisterState>` com o formData como estado
2. **ProfileController** → `AsyncNotifier<ProfileState>`
3. **RankController** → `AsyncNotifier<RankState>`
4. **StatisticsController** → `AsyncNotifier<StatisticsState>`
5. **NotificationController** → `AsyncNotifier<NotificationState>`
6. **ChatController** → `AsyncNotifier<ChatState>` (considerar `StreamNotifier` se usar WebSocket)
7. **ExplorerController + MapController** → podem ser unificados em `MapNotifier`
8. **AddressController** → `AsyncNotifier<AddressState>`

---

### FASE 10 — Widgets e páginas

Com todos os controllers migrados, atualizar os widgets:

- Substituir `Obx(() => ...)` por `Consumer(builder: (ctx, ref, _) => ...)`
- `StatefulWidget` com controller GetX → `ConsumerStatefulWidget` ou `ConsumerWidget`
- `ever(obs, cb)` em `initState` → `ref.listen(provider, cb)` no `build`
- Remover todos os `import 'package:get/get.dart'`

---

### FASE 11 — Limpeza final

- Remover `get: ^4.6.6` do `pubspec.yaml`
- Remover `get_storage` se substituído por `shared_preferences` (ou manter — ele não é GetX, é independente)
- Remover `core/di/modules/controllers.dart` (os controllers não precisam mais de registro manual)
- Atualizar `main.dart`: remover `registerInitControllers()`, `registerLazyControllers()`
- Executar `flutter pub get` e verificar que não há referências a `get`

---

## 5. Riscos e Pontos de Atenção

### `ever()` e Workers → `ref.listen`
Os workers `ever(obs, cb)` no `AppController` criam dependências encadeadas (userWorker espera homeWorker). No Riverpod, isso vira `ref.listen` dentro de outros providers ou nos widgets. Atenção para não criar ciclos de dependência.

### `Get.showOverlay`
Usado no `login_page.dart`. É um overlay de loading enquanto uma `asyncFunction` executa. Substituir por um `loadingProvider` simples + `showDialog` manual ou pelo padrão de loading state no próprio Notifier.

### GoRouter + Riverpod redirect
O `GoRouter` é instanciado antes do `ProviderScope` resolver. Para usar `ref` no redirect, usar o padrão de `ProviderContainer` ou `ref.invalidateSelf()` com `refreshListenable`.

### `RxDouble tabMargin = 10.0.obs` em widgets (`game_detail_page`)
Alguns `.obs` estão nas páginas, não nos controllers. Substituir por `useState` (hooks) ou `StatefulWidget` simples com `setState`.

### ProfileController com `Get.put`
O `profile_page.dart` usa `Get.put(ProfileController())` — padrão GetX de DI, não GetIt. Esse controller não está no service locator. Migrar para `ref.watch(profileNotifierProvider)` sem necessidade de registrar em lugar nenhum.

---

## 6. Ordem de Execução Recomendada

```
Fase 0  → Eliminar Get.* de UI (sem tocar controllers)
Fase 1  → ThemeController
Fase 2  → Sessão (UserModel, eventos, localização)
Fase 3  → AuthController + fluxo de init
Fase 4  → NavigationController + ShowcaseController
Fase 5  → UserController + HomeController
Fase 6  → EventController (6 mixins)
Fase 7  → GameController (7 mixins)
Fase 8  → EscalationController (3 mixins)
Fase 9  → Controllers menores (Register, Profile, Rank, Stats, etc.)
Fase 10 → Widgets e páginas (trocar Obx por Consumer)
Fase 11 → Limpeza e remoção do pacote get
```

**A cada fase:** compilar, rodar o app, verificar os fluxos afetados antes de avançar.

---

## 7. Estrutura de Pastas Alvo

```
lib/
├── core/
│   ├── providers/              ← NOVO: providers globais
│   │   ├── session_provider.dart
│   │   ├── theme_provider.dart
│   │   └── auth_provider.dart
│   ├── di/                     ← MANTÉM: GetIt para serviços/repos
│   └── ...
├── presentation/
│   ├── providers/              ← NOVO: providers de feature
│   │   ├── home_provider.dart
│   │   ├── event_provider.dart
│   │   ├── game_provider.dart
│   │   ├── escalation_provider.dart
│   │   └── ...
│   ├── controllers/            ← REMOVE: esvaziado gradualmente
│   └── pages/                  ← ATUALIZA: Obx → Consumer
```

Os arquivos `.g.dart` gerados pelo `build_runner` ficam ao lado dos providers.
