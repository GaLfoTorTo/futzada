import 'package:flutter/material.dart';
import 'package:futzada/presentation/controllers/notification_controller.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/presentation/widget/images/img_circle_widget.dart';
import 'package:futzada/presentation/widget/images/img_group_circle_widget.dart';
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
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //RESGATAR CONTROLER DE NOTIFICAÇÕES
    NotificationController notificationController =  NotificationController.instace;
    //RESGATAR NOTIFICAÇÕES
    List<Map<String, dynamic>> notifications = notificationController.getNotifications(type);
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
      //RESGATAR LISTA DE IMAGENS PARA NOTIFICAÇÃO
      List<dynamic> imgNotification = [notification['image'][0], notification['image'][1]];

      //GERAR CARD DE NOTIFICAÇÃO
      notificationList.add(
        InkWell(
          child: Container(
            width: dimensions.width,
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (notification['image'] is List<dynamic>) ...[
                  ImgGroupCircularWidget(
                    width: 60,
                    height: 60,
                    images: imgNotification,
                  ),
                ] else ...[
                  ImgCircularWidget(
                    width: 70,
                    height: 70,
                    image: notification['image'],
                  ),
                ],
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      spacing: 5,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          notification['title'],
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          notification['description'],
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: AppColors.grey_500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      //ADICIONAR DIVIDER
      notificationList.add(const Divider(color: AppColors.grey_300, thickness: 1));
    }

    return SingleChildScrollView(
      child: Column(children: notificationList),
    );
  }
}