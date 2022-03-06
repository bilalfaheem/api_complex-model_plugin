import 'dart:convert';

import 'package:api_3_complex_json_plugin/Model/user/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  List<User> user = [];

  Future<List<User>> getUserApi() async {
    final response =
        await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));
    var dataa = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      user.clear();
      for (Map i in dataa) {
        user.add(User.fromJson(i));
      }
      return user;
    } else {
      return user;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
            future: getUserApi(),
            builder: (context, AsyncSnapshot<List<User>> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Container(
                    height: 60,
                    width: 60,
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              return ListView.builder(
                  itemCount: user.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Column(
                        children: [
                          RowData_widget(
                              title: "Name",
                              value: snapshot.data![index].name.toString()),
                          RowData_widget(
                              title: "Email",
                              value: snapshot.data![index].email.toString()),
                          RowData_widget(
                              title: "City",
                              value: snapshot.data![index].address!.city
                                  .toString()),
                          RowData_widget(
                              title: "Geo Lat",
                              value: snapshot.data![index].address!.geo!.lat
                                  .toString())
                        ],
                      ),
                    );
                  });
            },
          ))
        ],
      ),
    );
  }
}

class RowData_widget extends StatelessWidget {
  String title, value;
  RowData_widget({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(title), Text(value)],
    );
  }
}
