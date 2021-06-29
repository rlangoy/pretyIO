import 'package:flutter/material.dart';
import 'package:my_mqtt/main.dart';
import 'components/body.dart';

class ConfigServerScreen extends StatelessWidget {
  var loginInfo;
  Function? onLoginBtn;

  ConfigServerScreen({this.loginInfo, this.onLoginBtn});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(loginInfo: loginInfo, onLoginBtn: onLoginBtn),
    );
  }
}
