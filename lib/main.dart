import 'package:flutter/material.dart';
import 'screens/errors/no_connection.dart';
import 'screens/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MqttLoginInfo {
  MqttLoginInfo();

  //Loads data from storage
  Future<void> loadFromLocalStorage() async {
    final SharedPreferences prefs = await _prefs;
    _serverAddress = (prefs.getString('serverAddress') ?? "");
    _userName = (prefs.getString('userName') ?? "");
    _userPassword = (prefs.getString('userPassword') ?? "");
  }

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String _serverAddress = "";
  String _userName = "";
  String _userPassword = "";

  String get serverAddress {
    return _serverAddress;
  }

  String get userName {
    return _userName;
  }

  String get userPassword {
    return _userPassword;
  }

  // Stores data loacay and persistant
  set serverAddress(String serverAddress) {
    SharedPreferences.getInstance().then((res) {
      res.setString("serverAddress", _serverAddress = serverAddress);
    });
  }

  set userName(String userName) {
    SharedPreferences.getInstance().then((res) {
      res.setString("userName", _userName = userName);
    });
  }

  set userPassword(String userPassword) {
    SharedPreferences.getInstance().then((res) {
      res.setString("userPassword", _userPassword = userPassword);
    });
  }

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

  void onLoginBtn() {
    //print("Login button pushed");
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
      //home: const NoConnectionScreen(msgHeader: 'Sorry!..'),
      home: LoginScreen(loginInfo: loginInfo, onLoginBtn: onLoginBtn),
      //const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

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
