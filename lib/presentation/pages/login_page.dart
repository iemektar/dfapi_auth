import 'package:dfapi_auth/dfapi_app.dart';
import 'package:dfapi_auth/presentation/widgets/rounded_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key key,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String username;
  String password;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        body: Center(
          child: Container(
            width: size.width * .85,
            alignment: Alignment.center,
            child: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(MaterialCommunityIcons.fingerprint, size: 35),
                      SizedBox(width: 10),
                      Text(
                        "AUTHENTICATION",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                RoundedTextField(
                  hintText: "Username",
                  icon: MaterialCommunityIcons.account_circle_outline,
                  onChanged: (value) => setState(() => username = value),
                ),
                SizedBox(height: 10),
                RoundedTextField(
                  hintText: "Password",
                  icon: MaterialCommunityIcons.textbox_password,
                  isObscure: true,
                  onChanged: (value) => setState(() => password = value),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextButton.icon(
                    onPressed: () {
                      if (username.isEmpty || password.isEmpty) return;

                      DfApiApp.functions.logIn(username, password);
                    },
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(
                        Size(double.infinity, 0),
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      overlayColor: MaterialStateProperty.all(
                          Colors.white.withOpacity(.15)),
                    ),
                    icon: Icon(MaterialCommunityIcons.lock_outline,
                        size: 20, color: Colors.white),
                    label: Text("Login"),
                  ),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
