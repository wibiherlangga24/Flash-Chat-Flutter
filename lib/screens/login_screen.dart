import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_wb/components/rounded_button.dart';
import 'package:flash_chat_wb/constants.dart';
import 'package:flash_chat_wb/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {

  static const String id = 'LoginScreen';

  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool showSpinner = false;
  late String email;
  late String password;
  bool isPasswordShow = false;

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
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email.'),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: !isPasswordShow,
                textAlign: TextAlign.center,
                style: kTextFieldStyle,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password.',
                    suffixIcon: IconButton(onPressed: () {
                      setState(() {
                        isPasswordShow = !isPasswordShow;
                      });
                    }, icon: Icon(isPasswordShow ? Icons.visibility_off : Icons.visibility)),),
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(colour: Colors.lightBlueAccent, title: 'Log In', onPress: () {
                signIn(context);
              }),
            ],
          ),
        ),
      ),
    );
  }

  void signIn(BuildContext context) async {

    setState(() {
      showSpinner = true;
    });

    try {
      final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if(result.user != null) {
        Navigator.pushNamed(context, ChatScreen.id);
      }
      setState(() {
        showSpinner = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        showSpinner = false;
      });
    }
  }
}
