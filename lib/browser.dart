///  browser.dart Code for running MQTT using websocket g web-application
///
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';

MqttClient setup(String serverAddress, String uniqueID, bool useSSL) {
  //Connect using Websocket on SSL
  String preix = 'ws://';
  if (useSSL) preix = 'wss://';

  var client = MqttBrowserClient(preix + serverAddress, uniqueID);
  client.port = 8811; //  Port

  return client; //MqttBrowserClient.withPort(serverAddress, uniqueID, port);
}
