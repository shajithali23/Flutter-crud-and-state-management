import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crud/home_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _auth = FirebaseAuth.instance;
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

  @override
  Widget build(BuildContext context) {
    return _auth.currentUser != null
        ? HomePage()
        : SafeArea(
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
                        try {
                          await _auth.signInWithEmailAndPassword(
                              email: _name.text, password: _password.text);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Sucessfully Login.'),
                              duration: Duration(seconds: 5),
                            ),
                          );
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                              (Route<dynamic> route) => false);
                        } on FirebaseAuthException catch (e) {
                          debugPrint(e.toString());
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Ops! Login Failed'),
                              duration: Duration(seconds: 5),
                            ),
                          );
                        }
                      },
                      child: const Text("Login")),
                  ElevatedButton(
                      onPressed: () async {
                        debugPrint("Sign Up");
                        debugPrint(_name.text);
                        debugPrint(_password.text);
                        try {
                          await _auth.createUserWithEmailAndPassword(
                              email: _name.text, password: _password.text);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Sucessfully Register.You Can Login Now'),
                              duration: Duration(seconds: 5),
                            ),
                          );
                          Navigator.pop(context);
                        } on FirebaseAuthException catch (e) {
                          debugPrint(e.toString());

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Ops! Registration Failed'),
                              duration: Duration(seconds: 5),
                            ),
                          );
                        }
                      },
                      child: const Text("Sign Up")),
                ],
              ),
            )),
          );
  }
}
