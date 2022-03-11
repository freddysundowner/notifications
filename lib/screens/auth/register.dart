import 'package:flutter/material.dart';
import 'package:fluttergistshop/controllers/auth_controller.dart';
import 'package:fluttergistshop/utils/utils.dart';
import 'package:get/get.dart';

class Register extends StatelessWidget {
  final TextEditingController email = TextEditingController();
  final TextEditingController firstname = TextEditingController();
  final TextEditingController lastname = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final AuthController authController = Get.put(AuthController());

  Register({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              controller: firstname,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: 'First Name',
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
                              controller: lastname,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Last Name',
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
                              controller: username,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Username',
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
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    }

                    // authController.error.value = "";
                    // if (firstname.text.isEmpty ||
                    //     lastname.text.isEmpty ||
                    //     username.text.isEmpty ||
                    //     email.text.isEmpty ||
                    //     password.text.isEmpty) {
                    //   authController.error.value = "All fields are required";
                    //   return;
                    // }
                  },
                  child: Button(text: "Register")),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
