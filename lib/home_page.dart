import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:git_practice/ex_page.dart';
import 'package:git_practice/login_page.dart';
import 'package:git_practice/models/details_model.dart';
import 'package:git_practice/models/response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  ResponseModel? model;
  DetailsResponseModel? repos;

  Future<void> loginResponse() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    final res = await http.get(
      Uri.parse("https://api.github.com/user"),
      headers: {"Authorization": "Bearer $token", "X-GitHub-Api-Version": "2022-11-28"},
    );

    if (res.statusCode == 200) {
      model = ResponseModel.fromJson(jsonDecode(res.body));
      setState(() {});
      detailsResponse();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed with StatusCode ${res.statusCode}"),
        ),
      );
    }
  }

  Future<void> detailsResponse() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    final res = await http.get(
      Uri.https(
        "api.github.com",
        "/search/repositories",
        {"q": "user:${model?.login}"},
      ),
      headers: {"Authorization": "Bearer $token", "X-GitHub-Api-Version": "2022-11-28"},
    );

    if (res.statusCode == 200) {
      repos = DetailsResponseModel.fromJson(jsonDecode(res.body));
      setState(() {});
    } else {
      throw Exception(
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed with StatusCode ${res.statusCode}"),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loginResponse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
        actions: [
          TextButton(
            onPressed: () async {
              final SharedPreferences prefs = await _prefs;
              await prefs.remove("token");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Login(),
                ),
              );
            },
            child: Text("LogOut", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          if (model != null)
            Card(
              child: Column(
                children: [
                  Image.network(model?.avatarUrl ?? ""),
                  Text("User : ${model?.login ?? ""}"),
                  Text("Id : ${model?.id.toString() ?? ""}"),
                  Text("Created at : ${model?.createdAt ?? ""}"),
                  Text("Updated at : ${model?.updatedAt ?? ""}"),
                ],
              ),
            ),
          if (repos != null)
            ListView.builder(
              shrinkWrap: true,
              itemCount: repos?.items?.length ?? 0,
              itemBuilder: (context, index) {
                final items = repos?.items?[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 5, left: 10, right: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GitHubOAuth()/*RepositoryDetails(
                            projectName: items?.name ?? "",
                          ),*/
                        ),
                      );
                    },
                    child: ListTile(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      style: ListTileStyle.list,
                      tileColor: Colors.grey.shade200,
                      leading: items?.private == false ? Icon(Icons.public) : Icon(Icons.lock),
                      title: Text("Repo : ${items?.name}"),
                    ),
                  ),
                );
              },
            )
        ],
      ),
    );
  }
}
