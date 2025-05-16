import 'package:flutter/material.dart';
import 'package:futzada/controllers/notification_controller.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/images/img_circle_widget.dart';
import 'package:futzada/widget/images/img_group_circle_widget.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationView extends StatelessWidget {
  final String type;
  const NotificationView({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR CONTROLER DE NOTIFICAÇÕES
    var controller =  NotificationController.instace;
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimentions = MediaQuery.of(context).size;
    //RESGATAR NOTIFICAÇÕES
    List<Map<String, dynamic>> notifications = controller.getNotifications(type);
    //ARRAY DE NOTIFICAÇÕES
    List<Widget> notificationList = [];
    //RESGATAR  FORMATO DAS DATAS
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    //DEFINIR ULTIMA DATA DE NOTIFICAÇÕES
    DateTime lastDate = dateFormat.parse(notifications[0]['date']);

    for (var notification in notifications) {
      //RESGATAR DATA DA NOTIFICACAO
      DateTime notificationDate = dateFormat.parse(notification['date']);
      //VERIFICAR SE DATAS SÃO DIFERENTES
      if(notificationDate.isBefore(lastDate)){
        //REATRIBUIR DATA
        lastDate = notificationDate;
        //RESGATAR LABEL DA DATA
        String dateLabel = timeago.format(notificationDate);
        //ADICIONAR IDENTIFICADOR DE LABEL
        notificationList.add(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              dateLabel,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          )
        );
      }

      //GERAR CARD DE NOTIFICAÇÃO
      notificationList.add(
        InkWell(
          child: Container(
            width: dimentions.width,
            padding: const EdgeInsets.all(10),
            color: AppColors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (notification['image'] is List<dynamic>) ...[
                  ImgGroupCircularWidget(
                    width: 70,
                    height: 70,
                    images: notification['image'],
                  ),
                ] else ...[
                  ImgCircularWidget(
                    width: 70,
                    height: 70,
                    image: notification['image'],
                  ),
                ],
                Container(
                  width: dimentions.width - 120,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          notification['title'],
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: AppColors.blue_500,
                          ),
                        ),
                      ),
                      Text(
                        notification['description'],
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.gray_500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      //ADICIONAR DIVIDER
      notificationList.add(const Divider(color: AppColors.gray_300, thickness: 1));
    }

    return SingleChildScrollView(
      child: Column(children: notificationList),
    );
  }
}