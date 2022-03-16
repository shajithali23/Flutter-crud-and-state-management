import 'dart:convert';

import 'package:firebase_crud/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _password = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // if (FirebaseAuth.instance.currentUser! != null) {
    //   // wrong call in wrong place!
    //   Navigator.of(context)
    //       .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    // }
  }

  Future<void> login() async {
    String url = "https://api.qbace.in/api/login";
    var res = await http.post(Uri.parse(url),
        body: {"email": _name.text, "password": _password.text});
    print(res.statusCode);
    var response = jsonDecode(res.body);
    print(response);
    if (response['success'] == true) {
      print("LOGIN");
    } else {
      print("FAILED");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFieldWidget(
                name: "Email",
                nameController: _name,
                textInputType: TextInputType.emailAddress),
            TextFieldWidget(
                name: "Password",
                nameController: _password,
                textInputType: TextInputType.text),
            ElevatedButton(
                onPressed: () async {
                  debugPrint(_name.text);
                  debugPrint(_password.text);
                  login();
                },
                child: const Text("Login")),
          ],
        ),
      )),
    );
  }
}
