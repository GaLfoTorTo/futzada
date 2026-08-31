import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:esportly/core/di/service_locator.dart';
import 'package:esportly/core/di/modules/session.dart';
import 'package:esportly/core/theme/app_icones.dart';
import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/data/services/firebase/firebase_service.dart';
import 'package:esportly/presentation/pages/home/home_page.dart';
import 'package:esportly/presentation/pages/home/home_error_page.dart';
import 'package:esportly/presentation/widget/bars/header_widget.dart';
import 'package:esportly/presentation/widget/skeletons/skeleton_home_widget.dart';
import 'package:esportly/presentation/controllers/home_controller.dart';

class HomeBase extends StatefulWidget {
  const HomeBase({super.key});

  @override
  State<HomeBase> createState() => _HomeBaseState();
}

class _HomeBaseState extends State<HomeBase> {
  final HomeController homeController = HomeController.instance;
  final UserModel user = sl<UserModel>(instanceName: 'user');

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final locationGranted = await registerLocation();
    await FirebaseService().initFirebaseMessaging();
    if (mounted && locationGranted) homeController.fetchHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderWidget(
        leftAction: () {
          final scaffoldKey = sl<GlobalKey<ScaffoldState>>(instanceName: 'scaffoldKey');
          scaffoldKey.currentState?.openDrawer();
        },
        leftIcon: AppIcones.bars_solid,
        rightAction: () => context.push('/profile'),
        extraAction: () => context.push('/chats'),
        extraIcon: AppIcones.paper_plane_solid,
        home: true,
        photo: user.photo,
        shadow: false,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => homeController.fetchHome(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              child: ListenableBuilder(listenable: homeController, builder: (_, __) {
                if (!homeController.isLoading) {
                  if (homeController.hasError) {
                    return const HomeErrorPage();
                  }
                  return const HomePage();
                }
                return const SkeletonHomeWidget();
              }),
            ),
          ),
        ),
      ),
    );
  }
}