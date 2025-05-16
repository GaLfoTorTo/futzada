import 'package:flutter/material.dart';
import 'package:futzada/controllers/notification_controller.dart';
import 'package:futzada/pages/notification/notification_view.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:get/route_manager.dart';

class NotificationPage extends StatefulWidget {
  
  const NotificationPage({
    super.key,
  });

  @override
  State<NotificationPage> createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> with SingleTickerProviderStateMixin {
  var controller = NotificationController.instace;
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
    var dimentions = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: HeaderWidget(
        title: 'Notificações',
        leftAction: () => Get.back(),
        shadow: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: AppColors.white,
              child: TabBar(
                controller: tabController,
                indicator: UnderlineTabIndicator(
                  borderSide: const BorderSide(
                    width: 5,
                    color: AppColors.green_300,
                  ),
                  insets: EdgeInsets.symmetric(horizontal: dimentions.width / 3.5)
                ),
                labelColor: AppColors.green_300,
                labelStyle: const TextStyle(
                  color: AppColors.gray_500,
                  fontWeight: FontWeight.normal,
                ),
                unselectedLabelColor: AppColors.gray_500,
                labelPadding: const EdgeInsets.symmetric(vertical: 5),
                tabs: const [
                  Text("Todas"),
                  Tab(text: 'Para você'),
                ],
              ),
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