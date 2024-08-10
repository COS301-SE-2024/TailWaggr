import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart'; // for kDebugMode
import 'package:cos301_capstone/firebase_options.dart';

class PushNotificationsManager {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      // Handle further logic here if needed (e.g., token registration)
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
      // Handle provisional permission logic
    } else {
      print('User declined or has not accepted permission');
    }
  }

  static Future<void> initializeFCM() async {
    // Request permission
    await requestPermission();

    // Get the token for this device
    String? token;

    if (DefaultFirebaseOptions.currentPlatform == DefaultFirebaseOptions.web) {
      // TODO: replace with your own VAPID key
      const String vapidKey = "BLAuB7S_X0prPAtFJro7skcOdoOKfwGkTRqs9OJ6THPMnFa0B7WQuTKCrrSarKjmVPDjaEQzdJa1VhkBotFlW90";
      token = await _messaging.getToken(vapidKey: vapidKey);
    } else {
      token = await _messaging.getToken();
    }

    if (kDebugMode) {
      print('Registration Token=$token');
    }

    // Set up foreground message handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a foreground message: ${message.messageId}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    // Set up background message handler (for non-web platforms)
    if (DefaultFirebaseOptions.currentPlatform != DefaultFirebaseOptions.web) {
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print('Handling a background message: ${message.messageId}');
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  }
}
