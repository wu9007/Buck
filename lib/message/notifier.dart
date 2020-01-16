import 'package:buck/message/message_body.dart';
import 'package:buck/message/socket_client.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
final PublishSubject<String> notifierSubject = PublishSubject<String>();

class Notifier {
  static Notifier _instance = Notifier._();
  num _notificationId = 0;

  Notifier._();

  static Notifier getInstance() {
    return _instance;
  }

  Future init() async {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
    var initializationSettings = InitializationSettings(initializationSettingsAndroid, null);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String payload) async {
      _notificationId--;
      if (payload != null) {
        notifierSubject.add(payload);
      }
    });

    socketMessageSubject.stream.listen((messageBody) => showBigTextNotification(messageBody));
  }

  Future<void> showBigTextNotification(MessageBody messageBody) async {
    String title = messageBody.title;
    String content = messageBody.content;
    var bigTextStyleInformation = BigTextStyleInformation(
      content,
      htmlFormatBigText: true,
      contentTitle: title,
      htmlFormatContentTitle: true,
      summaryText: '新消息',
      htmlFormatSummaryText: true,
    );
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'bigTextChannel',
      '大文本通道',
      '大文本任务提示',
      style: AndroidNotificationStyle.BigText,
      styleInformation: bigTextStyleInformation,
    );
    var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, null);
    await flutterLocalNotificationsPlugin.show(++_notificationId, title, content, platformChannelSpecifics, payload: messageBody.uuid);
  }
}
