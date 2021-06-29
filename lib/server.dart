///  server.dart Code for MQTT wen not using web-application
///
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

MqttClient setup(String serverAddress, String uniqueID, int port) {
  //Connect using  SSL
  var client = MqttServerClient(serverAddress, uniqueID);
  client.secure = true; // Set secure working
  client.port = 8883; // SSL Port
  return client; //MqttServerClient.withPort(serverAddress, uniqueID, port);
}
