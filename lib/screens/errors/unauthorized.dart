import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UnAuthorized extends StatelessWidget {
  const UnAuthorized(
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
          SvgPicture.asset(
            "assets/icons/error_unauthorized.svg",
            //height: size.height * 0.35,
          ),
          Positioned(
              bottom: 170,
              left: 30,
              child: Text(msgHeader,
                  style: const TextStyle(fontSize: 48.0, color: Colors.black))),
          Positioned(
              bottom: 110,
              left: 30,
              child: Text(message,
                  style: const TextStyle(fontSize: 20.0, color: Colors.black))),
          Positioned(
            bottom: 50,
            left: 30,
            child: TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  primary: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))),
              onPressed: () {
                Navigator.pop(context); // Return to previous page
              },
              child: Text("  Retry  ".toUpperCase()),
            ),
          )
        ],
      ),
    );
  }
}
