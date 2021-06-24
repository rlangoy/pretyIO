import 'package:flutter/material.dart';

class NoConnectionScreen extends StatelessWidget {
  const NoConnectionScreen(
      {Key? key,
      this.message = "Something went wrong\nPlease try again",
      this.msgHeader = "Opps!"})
      : super(key: key);
  final String msgHeader;
  final String message;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/No_Connection_Bck.png",
            fit: BoxFit.cover,
          ),
          Positioned(
              bottom: 170,
              left: 30,
              child: Text(msgHeader,
                  style: const TextStyle(fontSize: 48.0, color: Colors.white))),
          Positioned(
              bottom: 110,
              left: 30,
              child: Text(message,
                  style: const TextStyle(fontSize: 20.0, color: Colors.white))),
          Positioned(
            bottom: 50,
            left: 30,
            child: TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  primary: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))),
              onPressed: () {},
              child: Text("  Retry  ".toUpperCase()),
            ),
          )
        ],
      ),
    );
  }
}
