import 'package:flutter/material.dart';
import 'background.dart';
import 'package:flutter_svg/svg.dart';
import '../../../screens/errors/no_connection.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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

  _Body({this.loginInfo, this.onLoginBtn}) {
    //Get data from storage and update UX when loaded
    loginInfo.loadFromLocalStorage().then((_) {
      ctrlMqttServer.text = loginInfo.serverAddress;
    }).catchError((e) {
      //No data found in storage
      ctrlMqttServer.text = "";
    });
  }

  @override
  // ignore: must_call_super
  void initState() {
    //---
    // Listen for text changes and update the object loginInfo
    //---
    ctrlMqttServer
        .addListener(() => loginInfo.serverAddress = ctrlMqttServer.text);

    //Icon _iconSSL = Icon(Icons.lock_open);
    _iconWebSocket = SvgPicture.asset("assets/icons/websocket.svg",
        width: 25,
        color: _WebsocketsChecked == true
            ? Colors.purple.shade800
            : Colors.black38);

    if (_SSLchecked) {
      _iconSSL = Icon(Icons.lock_rounded, color: Colors.purple.shade800);
    } else {
      _iconSSL = Icon(Icons.lock_open_rounded);
    }
  }

  //MqttLoginInfo loginInfo;
  bool _SSLchecked = true;
  bool _WebsocketsChecked = kIsWeb == true ? true : false;
  Icon _iconSSL = Icon(Icons.lock_open);
  SvgPicture _iconWebSocket = SvgPicture.asset("assets/icons/websocket.svg",
      width: 25, color: Colors.black38);
/*
  SvgPicture _iconTcpPort = SvgPicture.asset("assets/icons/tcp_port.svg",
      width: 25, color: Colors.black38);
*/

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Server Configuration",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/config_server.svg",
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
              ),
            )),
            TextFieldContainer(
                child: TextField(
              decoration: InputDecoration(
                  icon: //const Icon(Icons.portrait),
                      SvgPicture.asset("assets/icons/tcp_port.svg",
                          width: 25, color: Colors.black38),
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: "Port number",
                  fillColor: Colors.white70),
            )),

            Container(
              child: SwitchListTile(
                value: _SSLchecked,
                onChanged: (value) {
                  setState(() {
                    _SSLchecked = value;
                    if (value == true) {
                      _iconSSL = Icon(Icons.lock_rounded,
                          color: Colors.purple.shade800);
                    } else {
                      _iconSSL = Icon(Icons.lock_open_rounded);
                    }
                  });
                },
                activeTrackColor: Colors.purple.shade800,
                activeColor: Colors.orangeAccent,
                title: const Text('SSL'),
                secondary: _iconSSL,
              ),
              decoration: BoxDecoration(
                  border: Border.all(
                color: Colors.black,
                width: 8,
              )
                  // color: Colors.pink,
                  ),
            ),

            SwitchListTile(
              value: _WebsocketsChecked,
              //Disable slider if web-platform (accept only sweb scoekts)
              onChanged: kIsWeb == true
                  ? null
                  : (value) {
                      setState(() {
                        _WebsocketsChecked = value;
                        _iconWebSocket = SvgPicture.asset(
                            "assets/icons/websocket.svg",
                            width: 25,
                            color: _WebsocketsChecked == true
                                ? Colors.purple.shade800
                                : Colors.black38);
                      });
                    },
              activeTrackColor: Colors.purple.shade800,
              activeColor: Colors.orangeAccent,
              title: const Text('WebSockets'),
              secondary: _iconWebSocket,
            ),

            const SizedBox(height: 20), // Add Space
            ButtonFieldContainer(
                child: TextButton(
              style: TextButton.styleFrom(
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))),
              onPressed: () {
                //Store text input
                loginInfo.saveToLocalStorage();
                //Execute the connection magic :)
                onLoginBtn!(context);
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
