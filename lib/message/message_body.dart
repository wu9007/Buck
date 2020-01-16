import 'package:buck/utils/dio_client.dart';

const COMMON_MESSAGE = 'CommonMessage';
const SYSTEM_ACTION_MESSAGE = 'SystemActionMessage';

class MessageBody {
  final String _type;
  final String _cmd;

  final String _uuid;
  final String _sender;
  final String _senderName;
  final String _bundleId;
  final String _title;
  final String _content;
  final DateTime _sendTime;
  bool _unread = true;

  MessageBody.fromMap(Map<String, dynamic> map)
      : this._type = map['type'],
        this._cmd = map['cmd'],
        this._bundleId = map['bundleId'],
        this._title = map['title'],
        this._uuid = map['uuid'],
        this._sender = map['sender'],
        this._senderName = map['senderName'],
        this._content = map['content'],
        this._sendTime = DateTime.parse(map['sendTime']),
        this._unread = map['unread'];

  static List<MessageBody> allFromMap(List jsonList) {
    if (jsonList == null || jsonList.length <= 0) {
      return [];
    } else {
      return jsonList.map((json) => MessageBody.fromMap(json)).toList();
    }
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        'type': this._type,
        'cmd': this._cmd,
        'uuid': this._uuid,
        'sender': this._sender,
        'senderName': this._senderName,
        'bundleId': this._bundleId,
        'title': this._title,
        'content': this._content,
        'sendTime': this._sendTime,
        'unread': this._unread,
      };

  Future<void> read() async {
    this._unread = false;
    await DioClient().get('/message/read', params: {'uuid': _uuid});
  }

  String get type => this._type;

  String get cmd => _cmd;

  String get content => _content;

  String get title => _title;

  String get uuid => _uuid;

  String get sender => _sender;

  String get senderName => _senderName;

  bool get unread => _unread;

  DateTime get sendTime => _sendTime;

  String get bundleId => _bundleId;
}
