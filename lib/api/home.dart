import 'package:flutter/material.dart';

class ApiHomeScreen extends StatefulWidget {
  var response;
  ApiHomeScreen({Key? key, required this.response}) : super(key: key);

  @override
  State<ApiHomeScreen> createState() => _ApiHomeScreenState();
}

class _ApiHomeScreenState extends State<ApiHomeScreen> {
  var circleName = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    circleName = widget.response['record']["name"].toString().split(" ");
    List profileList = [for (var i in circleName) '${i[0]}'];
    circleName = profileList;
    debugPrint(circleName.length.toString());
    debugPrint(profileList.toString());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFECF2FB),
        appBar: AppBar(
          backgroundColor: Color(0xFFECF2FB),
          iconTheme: IconThemeData(color: Colors.black),
          automaticallyImplyLeading: false,
          title: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.black,
                  ),
                  onPressed: () {},
                ))
          ],
          elevation: 0.0,
        ),
        body: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "My Profile",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: CircleAvatar(
                  backgroundColor: Colors.pink,
                  radius: 28,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      circleName.join(),
                      style: TextStyle(color: Colors.black, fontSize: 26),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  widget.response["record"]["name"],
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text("Email : ${widget.response["record"]["email"]}"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text("DOB : ${widget.response["record"]["dob"]}"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                    "Education : ${widget.response["record"]["education"]}"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text("City : ${widget.response["record"]["city"]}"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                    "Contact Number : ${widget.response["record"]["mobile"]}"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
