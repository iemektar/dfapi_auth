import 'package:flutter/material.dart';
import '../../dfapi_app.dart';

class DfApiErrorWidget extends StatelessWidget {
  final String message;

  const DfApiErrorWidget({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "ERROR!",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          SizedBox(height: 10),
          Text(message),
          SizedBox(height: 10),
          Divider(
            indent: 50,
            endIndent: 50,
          ),
          FlatButton(
            onPressed: () {
              DfApiApp.functions.logIn();
            },
            color: Colors.blue,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Text(
                "Try Login",
                style: TextStyle(color: Colors.white),
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          )
        ],
      ),
    );
  }
}
