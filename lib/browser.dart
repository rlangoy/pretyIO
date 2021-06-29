///  browser.dart Code for running MQTT using websocket g web-application
///
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';

MqttClient setup(String serverAddress, String uniqueID, int port) {
  if (port == 0) {
    port = 8080;
  }

  //Connect using Websocket on SSL
  var client = MqttBrowserClient('wss://' + serverAddress, uniqueID);
  client.port = 8811; //  Port

  return client; //MqttBrowserClient.withPort(serverAddress, uniqueID, port);
}
