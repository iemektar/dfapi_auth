import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../../dfapi_app.dart';

class DfApiErrorPage extends StatelessWidget {
  final String message;

  const DfApiErrorPage({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  MaterialCommunityIcons.close_circle_outline,
                  color: Colors.red[300],
                  size: 40,
                ),
                SizedBox(width: 10),
                Text(
                  "ERROR!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Colors.red[300],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Text(message, textAlign: TextAlign.center),
          ),
          Container(
            width: size.width * .8,
            padding: const EdgeInsets.only(top: 20),
            child: TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(Colors.red[400]),
                overlayColor: MaterialStateProperty.all(
                  Colors.white.withOpacity(.1),
                ),
              ),
              onPressed: () => DfApiApp.functions.logOut(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Go to Login",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    MaterialCommunityIcons.arrow_right,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
