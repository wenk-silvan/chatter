import 'package:chatter/screens/auth_screen.dart';
import 'package:chatter/screens/chat_screen.dart';
import 'package:chatter/screens/loading_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  bool _isLoading(AsyncSnapshot snapshot) {
    return snapshot.connectionState == ConnectionState.waiting;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initializeApp(),
        builder: (context, snapshot) {
          return snapshot.hasError
              ? const Text('Something went wrong')
              : MaterialApp(
                  title: 'Chatter',
                  theme: ThemeData(
                    primarySwatch: Colors.brown,
                    backgroundColor: Colors.brown,
                    accentColor: Colors.amberAccent.shade100,
                    buttonTheme: ButtonTheme.of(context).copyWith(
                        buttonColor: Colors.amberAccent,
                        textTheme: ButtonTextTheme.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                  home: _isLoading(snapshot)
                      ? const LoadingScreen()
                      : StreamBuilder(
                          stream: FirebaseAuth.instance.authStateChanges(),
                          builder: (ctx, snapshot) {
                            if (_isLoading(snapshot)) {
                              return const LoadingScreen();
                            }
                            return snapshot.hasData
                                ? const ChatScreen()
                                : const AuthScreen();
                          }));
        });
  }

  Future<FirebaseApp> initializeApp() async {
    final firebaseApp = await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    return firebaseApp;
  }
}
