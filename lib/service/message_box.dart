import 'package:buck/basic_app.dart';
import 'package:buck/message/message_body.dart';
import 'package:buck/message/socket_client.dart';
import 'package:buck/utils/dio_client.dart';
import 'package:rxdart/subjects.dart';

final PublishSubject<List<MessageBody>> messageBoxSubject =
    PublishSubject<List<MessageBody>>();

/// @author wujianchuan
/// @date 2019/12/17 17:06
class MessageBox {
  static MessageBox _instance;
  static List<MessageBody> _unreadMessageList = [];
  static List<MessageBody> _alreadyReadMessageList = [];

  MessageBox._();

  static MessageBox getInstance() {
    if (_instance == null) {
      _instance = MessageBox._();
      socketMessageSubject.stream
          .listen((messageBody) => _instance.pushUnreadMessage(messageBody));
    }
    return _instance;
  }

  Future<void> loadMessage() async {
    ResponseBody responseBody =
        await DioClient().get(buck.commonApiInstance.listMessageApi);
    if (responseBody != null && (responseBody.success ?? false)) {
      List<MessageBody> allMessageList =
          MessageBody.allFromMap(responseBody.data);
      _unreadMessageList = allMessageList.where((item) => item.unread).toList();
      _unreadMessageList.sort((v1, v2) => v2.sendTime.compareTo(v1.sendTime));
      _alreadyReadMessageList =
          allMessageList.where((item) => !item.unread).toList();
      _alreadyReadMessageList
          .sort((v1, v2) => v2.sendTime.compareTo(v1.sendTime));
      messageBoxSubject.add(allMessage());
    }
  }

  void pushUnreadMessage(MessageBody messageBody) {
    _unreadMessageList.insert(0, messageBody);
    messageBoxSubject.add(allMessage());
  }

  MessageBody popUnreadMessage(String uuid) {
    MessageBody messageBody =
        _unreadMessageList.singleWhere((item) => item.uuid == uuid);
    messageBody.read();
    _unreadMessageList.remove(messageBody);
    _alreadyReadMessageList.add(messageBody);
    messageBoxSubject.add(allMessage());
    return messageBody;
  }

  void pushAlreadyReadMessage(MessageBody messageBody) {
    _alreadyReadMessageList.insert(0, messageBody);
  }

  void clear() {
    _unreadMessageList.clear();
    _alreadyReadMessageList.clear();
  }

  List<MessageBody> allMessage() {
    List<MessageBody> allMessage = [];
    allMessage.addAll(_unreadMessageList);
    allMessage.addAll(_alreadyReadMessageList);
    return allMessage;
  }

  List<MessageBody> unreadMessage() {
    return _unreadMessageList;
  }
}
