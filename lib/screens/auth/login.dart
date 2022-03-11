import 'package:flutter/material.dart';
import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/utils/utils.dart';
import 'package:get/get.dart';

class Login extends StatelessWidget {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final AuthController authController = Get.put(AuthController());

  Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Center(
              child: Text(
                "GistShop",
                style: TextStyle(fontSize: 30),
              ),
            ),
            Spacer(),
            Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey, width: 0.4)),
                    child: Padding(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                        child: TextFormField(
                            controller: email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Email',
                            ))))),
            Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey, width: 0.4)),
                    child: Padding(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                        child: TextFormField(
                          controller: password,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Password',
                          ),
                        )))),
            Obx(() => Text(
                  authController.error.value,
                  style: TextStyle(color: Colors.red),
                )),
            SizedBox(
              height: 20,
            ),
            InkWell(
                onTap: () {
                  authController.error.value = "";
                  if (email.text.isEmpty || password.text.isEmpty) {
                    authController.error.value = "All fields are required";
                    return;
                  }
                },
                child: Button(text: "Login")),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
