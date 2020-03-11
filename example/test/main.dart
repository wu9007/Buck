import 'package:buck/utils/rsa_helper.dart';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt_io.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:flutter_test/flutter_test.dart';

main() async {
  test("encrypt test", () async {
    final publicKey = await parseKeyFromFile<RSAPublicKey>('assets/keys/public_key.pem');
    final privateKey = await parseKeyFromFile<RSAPrivateKey>('assets/keys/private_key.pem');

    final plainText = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit';
    final encrypter = Encrypter(RSA(publicKey: publicKey, privateKey: privateKey));

    final encrypted = encrypter.encrypt(plainText);
    final decrypted = encrypter.decrypt(encrypted);
    print(decrypted);
  });
  test("encrypt_helper test", () async {
    final plainText =
        'Lorem ipsum dolor sit amet, consectetur adipiscing eliLorem ipsum dolor sit amet, consectetur adipiscing eliLorem ipsum dolor sit amet, consectetur adipiscing eliLorem ipsum dolor sit amet, consectetur adipiscing eliLorem ipsum dolor sit amet, consectetur adipiscing eliLorem ipsum dolor sit amet, consectetur adipiscing eliLorem ipsum dolor sit amet, consectetur adipiscing eliLorem ipsum dolor sit amet, consectetur adipiscing elit';
    RsaHelper encryptHelper = RsaHelper.getInstance();
    await encryptHelper.init(
      clientPublicKeyPath: 'assets/rsa/public_key.pem',
      clientPrivateKeyPath: 'assets/rsa/private_key.pem',
    );
    String encodeStr = encryptHelper.encodeClientData(plainText);
    String decodeStr = encryptHelper.decodeClientData(encodeStr);
    print(encodeStr);
    print(decodeStr);
  });
}
