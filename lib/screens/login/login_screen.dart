import 'package:flutter/material.dart';
import 'package:my_mqtt/main.dart';
import 'components/body.dart';

class LoginScreen extends StatelessWidget {
  var loginInfo;

  LoginScreen({this.loginInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(loginInfo: loginInfo),
    );
  }
}
