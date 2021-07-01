import 'package:flutter/material.dart';

class MqttMessageList extends StatefulWidget {
  List<ListItem>? items;

  MqttMessageList({Key? key, List<ListItem>? items}) : super(key: key) {
    this.items = items;
  }

  @override
  State<StatefulWidget> createState() => _MqttMessageList(items: items!);
}

class _MqttMessageList extends State<MqttMessageList> {
  List<ListItem>? items;
  _MqttMessageList({List<ListItem>? items}) {
    this.items = items;
  }
  @override
  void initState() {
    //Add heading
    items!.add(HeadingItem("HeadingItem: Hei"));
    items!.add(
        MessageItem("MessageItem.Sender: Me", "MessageItem.body: Så Hyggelig"));
  }

  @override
  Widget build(BuildContext context) {
    final title = 'Mixed List';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ListView.builder(
          // Let the ListView know how many items it needs to build.
          itemCount: items!.length,
          // Provide a builder function. This is where the magic happens.
          // Convert each item into a widget based on the type of item it is.
          itemBuilder: (context, index) {
            final item = items![index];

            return ListTile(
              title: item.buildTitle(context),
              subtitle: item.buildSubtitle(context),
            );
          },
        ),
      ),
    );
  }
}

/// The base class for the different types of items the list can contain.
abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context);
}

/// A ListItem that contains data to display a heading.
class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headline5,
    );
  }

  @override
  Widget buildSubtitle(BuildContext context) => SizedBox();
}

/// A ListItem that contains data to display a message.
class MessageItem implements ListItem {
  final String sender;
  final String body;

  MessageItem(this.sender, this.body);

  @override
  Widget buildTitle(BuildContext context) => Text(sender);

  @override
  Widget buildSubtitle(BuildContext context) => Text(body);
}
