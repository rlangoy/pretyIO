import 'package:flutter/material.dart';

class MqttMessageList extends StatefulWidget {
  var mqClient;

  MqttMessageList({Key? key, var mqClient}) : super(key: key) {
    this.mqClient = mqClient;
  }

  @override
  State<StatefulWidget> createState() => _MqttMessageList(mqClient: mqClient!);
}

class _MqttMessageList extends State<MqttMessageList> {
  var mqClient;
  _MqttMessageList({var mqClient}) {
    this.mqClient = mqClient;
  }

  @override
  void initState() {
    //Listen for status-updates from mqClient
    //  If update run set-state
    mqClient.statusUpdate.listen((String msg) => msgRecieved(msg));
  }

  void msgRecieved(String msg) {
    //Update the widged (by runing ...build(..)  )
    setState(() {
      topics = mqClient.mqttMessageList.keys.toList();

      latestTopicsPayloads = [];
      mqClient.mqttMessageList
          .forEach((key, value) => latestTopicsPayloads.add(value.last));
    });
  }

  List<String> topics = <String>['A', 'B', 'C'];
  List<String> latestTopicsPayloads = <String>['A', 'B', 'C'];

  @override
  Widget build(BuildContext context) {
    final title = 'Mixed List';

    return MaterialApp(
      title: title,
      home: Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: topics.length,
            itemBuilder: (BuildContext context, int index) {
//----------------Bygg Egen gui her :)--------------------------------
              return Container(
                height: 50,
                color: Colors.amber[100],
                child: Center(child: Text('Entry ${topics[index]}')),
              );
//------------------------------------------------
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          )),
    );
  }
}
