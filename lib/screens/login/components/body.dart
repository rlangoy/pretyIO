import 'package:flutter/material.dart';
import 'background.dart';
import 'package:flutter_svg/svg.dart';

//Rounded text field input
class TextFieldContainer extends StatelessWidget {
  final Widget? child;
  const TextFieldContainer({
    Key? key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}

class ButtonFieldContainer extends StatelessWidget {
  final Widget? child;
  const ButtonFieldContainer({
    Key? key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.purple.shade600,
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}

// ignore: must_be_immutable
class Body extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  var loginInfo;
  Function? onLoginBtn;

  Body({
    Key? key,
    this.loginInfo,
    this.onLoginBtn,
  }) : super(key: key);

  @override
  State<Body> createState() =>
      // ignore: no_logic_in_create_state
      _Body(loginInfo: loginInfo, onLoginBtn: onLoginBtn);
}

class _Body extends State<Body> {
  // ignore: prefer_typing_uninitialized_variables
  var loginInfo;
  Function? onLoginBtn;

  TextEditingController ctrlMqttServer = TextEditingController();
  TextEditingController ctrlUserName = TextEditingController();
  TextEditingController ctrlUserPassword = TextEditingController();

  _Body({this.loginInfo, this.onLoginBtn}) {
    //Get data from storage and update UX when loaded
    loginInfo.loadFromLocalStorage().then((_) {
      ctrlMqttServer.text = loginInfo.serverAddress;
      ctrlUserName.text = loginInfo.userName;
      ctrlUserPassword.text = loginInfo.userPassword;
    }).catchError((e) {
      //No data found in storage
      ctrlMqttServer.text = "";
      ctrlUserName.text = "";
      ctrlUserPassword.text = "";
    });
  }

  //MqttLoginInfo loginInfo;
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            TextFieldContainer(
                child: TextField(
              controller: ctrlMqttServer,
              decoration: InputDecoration(
                icon: const Icon(Icons.link_rounded),
                hintStyle: TextStyle(color: Colors.grey[800]),
                hintText: "MQTT Server Address",
                // fillColor: Colors.white70
              ),
            )),
            TextFieldContainer(
                child: TextField(
              controller: ctrlUserName,
              decoration: InputDecoration(
                  icon: const Icon(Icons.person),
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: "User name",
                  fillColor: Colors.white70),
            )),
            TextFieldContainer(
                child: TextField(
              obscureText: _obscureText,
              controller: ctrlUserPassword,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    }, //_togglePasswordStatus,
                    color: Colors.grey[800],
                  ),
                  icon: const Icon(Icons.lock),
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: "Password",
                  fillColor: Colors.white70),
            )),

            const SizedBox(height: 20), // Add Space
            ButtonFieldContainer(
                child: TextButton(
              style: TextButton.styleFrom(
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))),
              onPressed: () {
                //Update and store the info
                loginInfo.serverAddress = ctrlMqttServer.text;
                loginInfo.userName = ctrlUserName.text;
                loginInfo.userPassword = ctrlUserPassword.text;
              },
              child: Text("LOGIN".toUpperCase()),
            )),

            //SizedBox(height: size.height * 0.03),
          ],
        ),
      ),
    );
  }
}
