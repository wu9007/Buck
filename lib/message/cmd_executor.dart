import 'package:buck/utils/login_client.dart';

const MANDATORY_OFFLINE = 'MandatoryOffline';

class CmdExecutor {
  static execute(String cmd) {
    if (MANDATORY_OFFLINE == cmd) {
      LoginClient.getInstance().logOut();
    }
  }
}
