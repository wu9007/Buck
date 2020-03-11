import 'package:encrypt/encrypt.dart';

class AesHelper {
  static String decrypt(String base64Key, String encrypted) {
    Key key = Key.fromBase64(base64Key);
    Encrypter encrypter = Encrypter(AES(key, mode: AESMode.ecb));
    return encrypter.decrypt(Encrypted.fromBase64(encrypted));
  }
}
