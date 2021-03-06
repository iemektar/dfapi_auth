import 'package:flutter/material.dart';
import '../../dfapi_app.dart';

class DfApiErrorWidget extends StatelessWidget {
  final String message;

  const DfApiErrorWidget({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width * .90,
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
          TextButton(
            onPressed: () {
              DfApiApp.functions.logOut();
            },
            child: Text(
              "Login Page",
              style: TextStyle(color: Colors.white),
            ),
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              padding: MaterialStateProperty.all(
                EdgeInsets.symmetric(vertical: 10, horizontal: 50),
              ),
              overlayColor: MaterialStateProperty.all(
                Colors.white.withOpacity(.15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
