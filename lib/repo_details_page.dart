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
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (repoDetails != null)
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: repoDetails?.length ?? 0,
                  itemBuilder: (context, index) {
                    final items = repoDetails?[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 5, left: 10, right: 10),
                      child: InkWell(
                        onTap: () {},
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Repo : ${items?.actor?.login}",style: TextStyle(fontWeight: FontWeight.w500)),
                                Text("Event : ${items?.type}",style: TextStyle(color: Colors.grey.shade600)),
                                Text("Created at : ${items?.createdAt}",style: TextStyle(color: Colors.grey.shade600)),
                              ],
                            ),
                          ),
                        )
                      ),
                    );
                  },
                ),
              )
            else
              CupertinoActivityIndicator()
          ],
        ),
      ),
    );
  }
}
