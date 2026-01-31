import 'package:futzada/core/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/presentation/controllers/notification_controller.dart';
import 'package:futzada/presentation/pages/notification/notification_view.dart';
import 'package:futzada/presentation/widget/bars/header_widget.dart';

class NotificationPage extends StatefulWidget {
  
  const NotificationPage({
    super.key,
  });

  @override
  State<NotificationPage> createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> with SingleTickerProviderStateMixin {
  //CONTROLLER DE NOTIFICAÇÕES
  NotificationController notificationController = NotificationController.instace;
  //CONTROLLER DE ABAS
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    //INICIALIZAR CONTROLLER DE TAB
    tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

    return Scaffold(
      appBar: HeaderWidget(
        title: 'Notificações',
        leftAction: () => Get.back(),
        shadow: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            TabBar(
              controller: tabController,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  width: 5,
                  color: Theme.of(context).primaryColor,
                ),
                insets: EdgeInsets.symmetric(horizontal: dimensions.width / 2)
              ),
              labelColor: Theme.of(context).primaryColor,
              labelStyle: const TextStyle(
                color: AppColors.grey_500,
                fontWeight: FontWeight.normal,
              ),
              unselectedLabelColor: AppColors.grey_500,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              tabs: const [
                Text("Todas"),
                Tab(text: 'Para você'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: const [
                  NotificationView(
                    type: 'all',
                  ),
                  NotificationView(
                    type: 'forMe',
                  ),
                ],
              ),
            ), 
          ],
        ),
      ), 
    );
  }
}