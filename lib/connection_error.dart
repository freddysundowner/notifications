import 'package:flutter/material.dart';
import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/utils/styles.dart';
import 'package:fluttergistshop/widgets/default_button.dart';

class ConnectionFailed extends StatelessWidget {
  const ConnectionFailed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Connection failed, please contact your administrator, before that please check you have a stable internet connection and click refresh button below",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            DefaultButton(
                color: primarycolor,
                text: "Refresh",
                press: () => AuthController().handleAuth())
          ],
        ),
      ),
    );
  }
}
