import 'package:firebase_messaging/firebase_messaging.dart';
import 'JwtService.dart';

class PushNotificacaoService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  initNotificacao() {
    _firebaseMessaging.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("=== FCM onMessage ===");
      print(message.data);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("=== FCM onMessageOpenedApp ===");
      print(message.data);
    });

    Future<void> _firebaseMessagingBackgroundHandler(
        RemoteMessage message) async {
      print("=== FCM onBackgroundMessage ===");
      print(message.data);
    }

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  sendFMC() {
    _firebaseMessaging.getToken().then((fmcToken) {
      JwtService().sendFMC(fmcToken ?? '');
    });
  }
}
