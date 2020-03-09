import 'package:encrypt/encrypt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:pointycastle/asymmetric/api.dart';

final parser = RSAKeyParser();

class EncryptHelper {
  static final EncryptHelper _instance = EncryptHelper._();
  Encrypter _clientEncrypter;
  Encrypter _backendEncrypter;
  String _clientPublicKeyString;
  String _clientPrivateKeyString;

  EncryptHelper._();

  static getInstance() {
    return _instance;
  }

  /// 程序初始时加载客户端的私钥和公钥
  init({
    @required String clientPublicKeyPath,
    @required String clientPrivateKeyPath,
  }) async {
    _clientPublicKeyString = await rootBundle.loadString(clientPublicKeyPath);
    _clientPrivateKeyString = await rootBundle.loadString(clientPrivateKeyPath);
    RSAPublicKey clientPublicKey = parser.parse(_clientPublicKeyString);
    RSAPrivateKey clientPrivateKey = parser.parse(_clientPrivateKeyString);
    _clientEncrypter = Encrypter(RSA(publicKey: clientPublicKey, privateKey: clientPrivateKey));
  }

  /// 程序启动后向后台请求公钥
  setBackendPublicKey(String publicKeyStr) {
//    if (_backendEncrypter == null) {
      RSAPublicKey backendPublicKey = parser.parse(publicKeyStr);
      _backendEncrypter = Encrypter(RSA(publicKey: backendPublicKey));
//    }
  }

  String encodeClientData(String src) {
    return _clientEncrypter.encrypt(src).base64;
  }

  String decodeClientData(String decoded) {
    return _clientEncrypter.decrypt(Encrypted.fromBase64(decoded));
  }

  String encodeBackendData(String src) {
    return _backendEncrypter.encrypt(src).base64;
  }

  String get clientPublicKeyString => _clientPublicKeyString;
}
