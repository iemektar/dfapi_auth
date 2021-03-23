import 'package:dfapi_auth/dfapi_app.dart';
import 'package:dfapi_auth/models/auth_configuration.dart';
import 'package:dfapi_auth/models/dfapi_auth_request.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  var demoIdentityServerConfig = AuthConfig(
    address: "https://demo.identityserver.io",
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Container(
          child: DfApiApp(
            request: DfApiAuthRequest(
              child: Container(
                  color: Colors.white,
                  child: OutlinedButton(
                    onPressed: () {
                      DfApiApp.functions.logOut();
                    },
                    child: Text("Log Out"),
                  )),
              configuration: demoIdentityServerConfig,
            ),
          ),
        ),
      ),
    );
  }
}
