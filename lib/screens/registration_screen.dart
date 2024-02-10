import 'package:flash_chat_wb/components/rounded_button.dart';
import 'package:flash_chat_wb/constants.dart';
import 'package:flash_chat_wb/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {

  static const String id = 'RegistrationScreen';

  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  bool showSpinner = false;
  bool isPasswordVisible = false;
  late String email;
  late String password;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                style: kTextFieldStyle,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: !isPasswordVisible,
                style: kTextFieldStyle,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password.',
                  suffixIcon: IconButton(onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  }, icon: Icon(
                    isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(colour: Colors.blueAccent, title: 'Register', onPress: () {
                registerUser(context);
              }),
            ],
          ),
        ),
      ),
    );
  }

  void registerUser(BuildContext context) async {

    setState(() {
      showSpinner = true;
    });

    try {
      final data = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (data.user != null) {
        Navigator.pushNamedAndRemoveUntil(context, ChatScreen.id, (route) => false);
      } else {
        print(data);
      }

      setState(() {
        showSpinner = false;
      });

    } catch(e) {
      print(e);
      setState(() {
        showSpinner = false;
      });
    }
  }
}
