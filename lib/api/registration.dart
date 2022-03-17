import 'dart:convert';

import 'package:firebase_crud/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class ApiSignUpScreen extends StatefulWidget {
  const ApiSignUpScreen({Key? key}) : super(key: key);

  @override
  State<ApiSignUpScreen> createState() => _ApiSignUpScreenState();
}

class _ApiSignUpScreenState extends State<ApiSignUpScreen> {
  final _nameController = TextEditingController();
  final _passController = TextEditingController();
  final _emailController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  createAccount() async {
    String url = "http://192.168.29.80/qbase-api/api/register";
    var params = {
      "name": _nameController.text,
      "email": _emailController.text,
      "roll_number": "123457",
      "password": _passController.text,
      "education": "Nanda Engineer",
      "gender_id": "1",
      "dob": "1996-10-04",
      "mobile": "7904055020",
      "city": "Tirupur",
      "state": "TN",
      "is_active": "1",
      "is_deleted": "0"
    };
    var res = await http.post(Uri.parse(url), body: params);
    print(res.statusCode);
    var response = jsonDecode(res.body);
    print(response);
    if (response['status'] == true) {
      print("Register");
      Navigator.pop(context);
      // Navigator.of(context).push(MaterialPageRoute(
      //     builder: (context) => ApiHomeScreen(
      //           response: response,
      //         )));
    } else {
      Fluttertoast.showToast(
          msg: response['error']['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      print(response['error']['message']);
    }
    debugPrint("CREATED");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("SIGN UP"),
            TextFieldWidget(
                name: "Name",
                nameController: _nameController,
                textInputType: TextInputType.name),
            TextFieldWidget(
                name: "Email",
                nameController: _emailController,
                textInputType: TextInputType.emailAddress),
            TextFieldWidget(
              name: "Password",
              nameController: _passController,
              textInputType: TextInputType.name,
            ),
            ElevatedButton(
                onPressed: () => createAccount(), child: Text("SIGN UP"))
          ],
        ),
      ),
    );
  }
}
