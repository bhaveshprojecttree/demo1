import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:git_practice/models/repo_details_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RepositoryDetails extends StatefulWidget {
  final String projectName;

  const RepositoryDetails({super.key, required this.projectName});

  @override
  State<RepositoryDetails> createState() => _RepositoryDetailsState();
}

class _RepositoryDetailsState extends State<RepositoryDetails> {
  List<RepoDetailsModel>? repoDetails;

  Future<void> repositoryDetails(String projectName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? "";

    final res = await http.get(
      Uri.parse("https://api.github.com/repos/bhaveshprojecttree/$projectName/events"),
      headers: {"Authorization": "Bearer $token", "X-GitHub-Api-Version": "2022-11-28"},
    );

    if (res.statusCode == 200) {
      final List model = json.decode(res.body);
      repoDetails = model.map((e) => RepoDetailsModel.fromJson(e)).toList();
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed with StatusCode ${res.reasonPhrase}"),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    repositoryDetails(widget.projectName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          if (repoDetails != null)
            ListView.builder(
              shrinkWrap: true,
              itemCount: repoDetails?.length ?? 0,
              itemBuilder: (context, index) {
                final items = repoDetails?[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 5, left: 10, right: 10),
                  child: InkWell(
                    onTap: () {},
                    child: ListTile(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      style: ListTileStyle.list,
                      tileColor: Colors.grey.shade200,
                      title: Text("Repo : ${items?.actor?.login}"),
                      subtitle: Text("Event : ${items?.type}"),
                    ),
                  ),
                );
              },
            )
          else
            Center(
              child: CupertinoActivityIndicator(),
            )
        ],
      ),
    );
  }
}
