import 'dart:convert';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'screens/config_server/config_server_screen.dart';
import 'screens/errors/no_connection.dart';
import 'screens/errors/unauthorized.dart';
import 'screens/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'dart:async';
import 'server.dart' if (dart.library.html) 'browser.dart' as mqttsetup;
import 'package:flutter/foundation.dart' show kIsWeb;

class MqttLoginInfo {
  MqttLoginInfo() {
    if (kIsWeb) {
      useWebSockets = true;
    }
  }

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  //Loads data from storage
  Future<void> loadFromLocalStorage() async {
    final SharedPreferences prefs = await _prefs;
/*    serverAddress = (prefs.getString('serverAddress') ?? "");
    userName = (prefs.getString('userName') ?? "");
    userPassword = (prefs.getString('userPassword') ?? "");
*/
    print("DEBUG !!! Remove This!!");
    serverAddress = "ub.langoy.in";
    userName = "usn";
    userPassword = "student2021";
  }

  //Saves data in local storage
  Future<void> saveToLocalStorage() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("serverAddress", serverAddress);
    prefs.setString("userName", userName);
    prefs.setString("userPassword", userPassword);
  }

  String serverAddress = "";
  String userName = "";
  String userPassword = "";
  bool useSSL = true;
  bool useWebSockets = false;

  bool get isEmpty {
    bool ret = false;

    if (serverAddress.isEmpty || userName.isEmpty || userPassword.isEmpty) {
      ret = false;
    } else {
      ret = true;
    }

    return ret;
  }
}

class MqClient {
  MqClient(this._loginInfo);

  final MqttLoginInfo? _loginInfo;
  MqttClient? client;

  /// The subscribed callback
  void onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
  }

//List of Topics and theis message lists
  Map<String, List<String>> _mqttMessageList =
      new HashMap<String, List<String>>();

  // new MQTT Messages is recieved
  void onMqttMessage(List<MqttReceivedMessage<MqttMessage>> messages) {
    for (var msg in messages) {
      final recMess = msg.payload as MqttPublishMessage;
      final pt = utf8.decode(recMess.payload.message!);
      print(
          'EXAMPLE::Change notification:: topic is <${msg.topic}>, payload is <-- $pt -->');

      //Store the new message
      //   If topic does not exist i list then create is
      //   get list connected to topic and add the new message/payload
      List<String> msgs4topic =
          _mqttMessageList.putIfAbsent(msg.topic, () => []);
      msgs4topic.add(pt);
    }
  }

  /// Pong callback
  void pong() {
    print('EXAMPLE::Ping response client callback invoked');
  }

  void subscribe(String topic) {
    // Subscribe to ...
    print('EXAMPLE::Subscribing to :  $topic');
    //const topic = 'home/office/temperature/luftintak'; // Not a wildcard topic
    client!.subscribe(topic, MqttQos.atMostOnce);

    // Start listening for subscribed messages"
    client!.updates!.listen((List<MqttReceivedMessage<MqttMessage>> msg) {
      onMqttMessage(msg);
    }); // end listen
  }

  Future<void> connect(BuildContext context) async {
    // Dafault show connection error page
    Widget nextPage = NoConnectionScreen(msgHeader: 'Sorry!..');
    try {
      print("ddd");

      client = mqttsetup.setup(
          _loginInfo!.serverAddress, 'My#un1que1Da', _loginInfo!.useSSL);

      print("User          :   ${_loginInfo!.userName} ");
      print("Connecting to :  ${client!.server}");

      client!.logging(on: false);
      client!.keepAlivePeriod = 20;
      client!.onDisconnected = onDisconnected;
      client!.onSubscribed = onSubscribed;

      if (client!.connectionStatus!.state == MqttConnectionState.connected) {
        client!.disconnect();
      }
      client!.pongCallback = pong;

      final connMess = MqttConnectMessage()
          .withClientIdentifier('Mqtt_MyClientUniqueIdQ1')
          .authenticateAs(_loginInfo!.userName, _loginInfo!.userPassword)
          .withWillTopic(
              'willtopic') // If you set this you must set a will message
          .withWillMessage('My Will message')
          .startClean() // Non persistent session for testing
          .withWillQos(MqttQos.atLeastOnce);
      print('EXAMPLE::Mosquitto client connecting....');
      client!.connectionMessage = connMess;

      await client!
          .connect()
          .then((value) => {
                print("---------------Connection ok ----------------------"),
                subscribe('home/office/temperature/luftintak'),
              })
          .onError((error, stackTrace) => {
                print("---------------Error Connecing----------------------"),
                //print(client!.connectionStatus),
                if (client!.connectionStatus!.returnCode ==
                    MqttConnectReturnCode.notAuthorized)
                  {
                    print("Wrong User name/password"),
                    nextPage = UnAuthorized(msgHeader: 'Sorry!..'),
                  },
                //print(client!.connectionStatus!.returnCode),
              });
    } catch (e) {
      print(e);
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) => nextPage));
  }
}

//---
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MqttLoginInfo loginInfo = MqttLoginInfo();
  runApp(MyApp(loginInfo: loginInfo));
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({Key? key, this.loginInfo}) : super(key: key);
  MqttLoginInfo? loginInfo;
  MqClient? mqClient;

  void onLoginBtn(BuildContext context) {
    print("Login button pushed");
    mqClient = MqClient(loginInfo);
    mqClient!.connect(context);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      //ConfigServerScreen
      //home: ConfigServerScreen(loginInfo: loginInfo, onLoginBtn: onLoginBtn),
      //home: const NoConnectionScreen(msgHeader: 'Sorry!..'),
      //home: UnAuthorized(msgHeader: 'Access Denied'),
      home: LoginScreen(loginInfo: loginInfo, onLoginBtn: onLoginBtn),
      //const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

//------------------------------------------
//  Orignial Home-page (to be edited..)
//-------------------------------------------
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
