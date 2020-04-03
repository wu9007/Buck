import 'dart:convert';
import 'dart:io';

import 'package:buck/basic_app.dart';
import 'package:buck/message/cmd_executor.dart';
import 'package:buck/message/message_body.dart';
import 'package:buck/model/user_info.dart';
import 'package:buck/widgets/tips/tips_tool.dart';
import 'package:rxdart/rxdart.dart';

final BehaviorSubject<MessageBody> socketMessageSubject =
    BehaviorSubject<MessageBody>();

class SocketClient {
  static SocketClient _socketClient = new SocketClient._();
  WebSocket _webSocket;
  bool _isOpen = false;

  SocketClient._();

  static Future<SocketClient> getInstance() async {
    return _socketClient;
  }

  Future<bool> connect() async {
    UserInfo userInfo = buck.userInfo;
    String serialNo = buck.androidInfo.androidId;
    String activeBaseUrl = buck.cacheControl.activeBaseUrl;
    RegExpMatch portRegExpMatch = RegExp(r"\d{1}:").firstMatch(activeBaseUrl);
    String ip = activeBaseUrl.substring(
        activeBaseUrl.indexOf('//') + 2, portRegExpMatch.start + 1);
    String wsPort = buck.cacheControl.wsPort;
    if (wsPort == null)
      wsPort = (int.parse(activeBaseUrl.substring(
                  portRegExpMatch.start + 2, activeBaseUrl.length)) +
              1)
          .toString();
    String wsUrl = 'ws://$ip:$wsPort';
    _webSocket = await WebSocket.connect(wsUrl, headers: {
      'avatar': userInfo.avatar,
      'serialNo': serialNo,
    }).timeout(Duration(seconds: 15)).catchError((e) {
      TipsTool.warning('连接异常，系统同将无法收到实时消息').show();
    });
    if (_webSocket?.readyState == 1) {
      _isOpen = true;
      print("Websocke has been connected.");
      _webSocket.listen(
        _onData,
        onError: (error) {
          _isOpen = false;
          print("Websocket was interrupted by error: $error.");
        },
        onDone: () {
          _isOpen = false;
          print("Websocke has been closed.");
        },
      );
    }
    return _isOpen;
  }

  void closeSocket() {
    if (_isOpen) {
      _webSocket.close();
    }
  }

  sendMessage(String message) {
    if (!_isOpen) {
      connect().then((isOpen) => _webSocket.add(message));
    } else {
      _webSocket.add(message);
    }
  }

  void _onData(dynamic content) {
    MessageBody messageBody = MessageBody.fromMap(jsonDecode(content));

    if (SYSTEM_ACTION_MESSAGE == messageBody.type) {
      CmdExecutor.execute(messageBody.cmd);
    } else {
      socketMessageSubject.add(messageBody);
    }
  }
}
