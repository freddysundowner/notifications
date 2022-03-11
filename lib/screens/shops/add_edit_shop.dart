import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/utils.dart';

enum NewShopState { Default, DB, PICK }

class NewShop extends StatelessWidget {
  late XFile image;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  NewShopState state = NewShopState.Default;
  bool selected = false;
  late String _name, _imageUrl, _mobile, _email;
  TextEditingController nameController = TextEditingController(),
      mobileController = TextEditingController(),
      descriptionController = TextEditingController(),
      emailController = TextEditingController();

  void showSnackBar(String string, String color) {
    var clr = Colors.teal;
    if (color == "red") {
      clr = Colors.red;
    }
    var snackBar = new SnackBar(
      content: new Text(
        string,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.normal,
        ),
      ),
      backgroundColor: clr,
      action: SnackBarAction(
        label: "Ok",
        textColor: Colors.white,
        onPressed: () {},
      ),
      elevation: 4.0,
    );
    if (_scaffoldKey.currentState != null)
      _scaffoldKey.currentState!.showSnackBar(snackBar);
  }

  Future<void> _selectImage() async {
    XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 40);
    image = (await ImageCropper().cropImage(
      sourcePath: image!.path,
      // ratioX: 1.0,
      // ratioY: 1.0,
      // maxWidth: 512,
      // maxHeight: 512,
      //   toolbarColor: Colors.purple,
      // toolbarWidgetColor: Colors.white,
    )) as XFile?;
    image = image;
    state = NewShopState.PICK;
    selected = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        title: Text("Add Shop "),
        actions: <Widget>[
          FlatButton(
            onPressed: () {},
            child: Center(
              child: Text(
                "SAVE",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
                child: Column(
              children: <Widget>[
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                    BoxShadow(
                      color: Colors.red,
                      blurRadius: 5.0,
                      spreadRadius: 2.0,
                    )
                  ]),
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      state == NewShopState.DB
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(_imageUrl),
                              radius: 60,
                            )
                          : state == NewShopState.Default
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "https://image.freepik.com/free-vector/doctor-character-background_1270-84.jpg"),
                                  radius: 60,
                                )
                              : CircleAvatar(
                                  radius: 60,
                                  backgroundImage: FileImage(File(image.path)),
                                ),
                      Positioned(
                        bottom: 0,
                        right: -15,
                        child: IconButton(
                          icon: Icon(
                            Icons.add_photo_alternate,
                            color: Colors.red,
                            size: 35.0,
                          ),
                          onPressed: () {
                            _selectImage();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Shop Name",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: sc_ItemTitleColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  TextField(
                    controller: nameController,
                    toolbarOptions: ToolbarOptions(
                      paste: true,
                      selectAll: false,
                    ),
                    decoration: InputDecoration(
                      fillColor: sc_InputBackgroundColor,
                      filled: true,
                      isDense: true,
                      contentPadding: EdgeInsets.all(15),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(color: sc_InputBackgroundColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: sc_InputBackgroundColor),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: sc_InputBackgroundColor),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      prefixIcon: Icon(Icons.person),
                    ),
                    textCapitalization: TextCapitalization.words,
                    autocorrect: false,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Email",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: sc_ItemTitleColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      fillColor: sc_InputBackgroundColor,
                      filled: true,
                      isDense: true,
                      contentPadding: EdgeInsets.all(15),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(color: sc_InputBackgroundColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: sc_InputBackgroundColor),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: sc_InputBackgroundColor),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Mobile No.",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: sc_ItemTitleColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  TextField(
                    controller: mobileController,
                    toolbarOptions: ToolbarOptions(
                      paste: true,
                      selectAll: false,
                    ),
                    decoration: InputDecoration(
                      fillColor: sc_InputBackgroundColor,
                      filled: true,
                      isDense: true,
                      contentPadding: EdgeInsets.all(15),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(color: sc_InputBackgroundColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: sc_InputBackgroundColor),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: sc_InputBackgroundColor),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Address",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: sc_ItemTitleColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  TextField(
                    controller: descriptionController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: 2,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: sc_InputBackgroundColor,
                      contentPadding: EdgeInsets.all(15),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(color: sc_InputBackgroundColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: sc_InputBackgroundColor),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: sc_InputBackgroundColor),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: sc_ItemTitleColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  TextField(
                    controller: descriptionController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: 5,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: sc_InputBackgroundColor,
                      contentPadding: EdgeInsets.all(15),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(color: sc_InputBackgroundColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: sc_InputBackgroundColor),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: sc_InputBackgroundColor),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('_imageUrl', _imageUrl));
  }
}
