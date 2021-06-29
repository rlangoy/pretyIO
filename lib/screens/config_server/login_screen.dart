import 'package:flutter/material.dart';
import 'package:my_mqtt/main.dart';
import 'components/body.dart';

class LoginScreen extends StatelessWidget {
  var loginInfo;
  Function? onLoginBtn;

  LoginScreen({this.loginInfo, this.onLoginBtn});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(loginInfo: loginInfo, onLoginBtn: onLoginBtn),
    );
  }
}
