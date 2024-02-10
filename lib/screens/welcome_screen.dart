import 'package:flash_chat_wb/screens/login_screen.dart';
import 'package:flash_chat_wb/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat_wb/components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {

  static const String id = 'WelcomeScreen';

  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {

    super.initState();

    controller = AnimationController(vsync: this, duration: const Duration(seconds: 3),);

    animation = CurvedAnimation(parent: controller, curve: Curves.bounceOut)
    ..addListener(() {
      setState(() {
        print(animation.value);
      });
    });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: animation.value * 90,
                  ),
                ),
                Expanded(
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Flash Chat',
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 45.0,
                          fontWeight: FontWeight.bold,
                        ),
                        speed: const Duration(seconds: 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            RoundedButton(colour: Colors.lightBlueAccent, title: 'Log In', onPress: () => Navigator.pushNamed(context, LoginScreen.id),),
            RoundedButton(colour: Colors.blueAccent, title: 'Register', onPress: () => Navigator.pushNamed(context, RegistrationScreen.id),),
          ],
        ),
      ),
    );
  }
}
