import 'package:flutter/material.dart';
import '../../dfapi_app.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: size.width * .7,
            child: TextButton.icon(
              onPressed: () {
                DfApiApp.functions.logIn("", "");
              },
              icon: Icon(Icons.lock_open_outlined),
              label: Text(
                "Log In",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
