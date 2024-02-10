import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat_wb/screens/chat_screen.dart';
import 'package:flash_chat_wb/screens/login_screen.dart';
import 'package:flash_chat_wb/screens/registration_screen.dart';
import 'package:flash_chat_wb/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const FlashChat());
}

class FlashChat extends StatelessWidget {
  const FlashChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
      },
    );
  }
}
