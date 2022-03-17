import 'dart:convert';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'model_api.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  Future fetchUsers() async {
    final response =
        await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));
    final data = json.decode(response.body);
    print(data); // debugPrint(response.statusCode.toString());
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

      return parsed.map<User>((json) => User.fromMap(json)).toList();
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: FutureBuilder(
              future: fetchUsers(),
              builder: (context, AsyncSnapshot snapshot) {
                debugPrint(snapshot.data.toString());
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 2,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.amber,
                                child: Text(snapshot.data[index].name[0]),
                              ),
                              title: Column(
                                children: [
                                  Text(snapshot.data[index].name),
                                  Text("Address :"),
                                  Text(snapshot.data[index].address.geo.lat
                                      .toString()),
                                ],
                              ),
                              trailing:
                                  Text(snapshot.data[index].id.toString()),
                            ),
                          ),
                        );
                      });
                }
                return Container(color: Colors.black);
              })),
    );
  }
}
