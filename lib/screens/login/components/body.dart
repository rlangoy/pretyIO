import 'package:flutter/material.dart';
import 'background.dart';
import 'package:flutter_svg/svg.dart';

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

class Body extends StatelessWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            TextFieldContainer(
                child: TextField(
              decoration: InputDecoration(
                //filled: true,
                icon: const Icon(Icons.link_rounded),
                hintStyle: TextStyle(color: Colors.grey[800]),
                hintText: "MQTT Server Address",
                // fillColor: Colors.white70
              ),
            )),
            TextFieldContainer(
                child: TextField(
              decoration: InputDecoration(
                  // filled: true,
                  icon: const Icon(Icons.person),
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: "User name",
                  fillColor: Colors.white70),
            )),
            TextFieldContainer(
                child: TextField(
              decoration: InputDecoration(
                  // filled: true,
                  icon: const Icon(Icons.lock),
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: "Password",
                  fillColor: Colors.white70),
            )),

            const SizedBox(height: 20), // Add Space
            ButtonFieldContainer(
                child: TextButton(
              style: TextButton.styleFrom(
                  // backgroundColor: Colors.purple.shade200,
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))),
              onPressed: () {},
              child: Text("LOGIN".toUpperCase()),
            )),
            //SizedBox(height: size.height * 0.03),
          ],
        ),
      ),
    );
  }
}
