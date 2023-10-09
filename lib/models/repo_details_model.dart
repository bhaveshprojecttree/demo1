// To parse this JSON data, do
//
//     final repoDetailsModel = repoDetailsModelFromJson(jsonString);

import 'dart:convert';

List<RepoDetailsModel> repoDetailsModelFromJson(String str) => List<RepoDetailsModel>.from(json.decode(str).map((x) => RepoDetailsModel.fromJson(x)));

String repoDetailsModelToJson(List<RepoDetailsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RepoDetailsModel {
  String? id;
  String? type;
  Actor? actor;
  Repo? repo;
  Payload? payload;
  bool? public;
  DateTime? createdAt;

  RepoDetailsModel({
    this.id,
    this.type,
    this.actor,
    this.repo,
    this.payload,
    this.public,
    this.createdAt,
  });

  factory RepoDetailsModel.fromJson(Map<String, dynamic> json) => RepoDetailsModel(
    id: json["id"],
    type: json["type"],
    actor: json["actor"] == null ? null : Actor.fromJson(json["actor"]),
    repo: json["repo"] == null ? null : Repo.fromJson(json["repo"]),
    payload: json["payload"] == null ? null : Payload.fromJson(json["payload"]),
    public: json["public"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "actor": actor?.toJson(),
    "repo": repo?.toJson(),
    "payload": payload?.toJson(),
    "public": public,
    "created_at": createdAt?.toIso8601String(),
  };
}

class Actor {
  int? id;
  String? login;
  String? displayLogin;
  String? gravatarId;
  String? url;
  String? avatarUrl;

  Actor({
    this.id,
    this.login,
    this.displayLogin,
    this.gravatarId,
    this.url,
    this.avatarUrl,
  });

  factory Actor.fromJson(Map<String, dynamic> json) => Actor(
    id: json["id"],
    login: json["login"],
    displayLogin: json["display_login"],
    gravatarId: json["gravatar_id"],
    url: json["url"],
    avatarUrl: json["avatar_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "login": login,
    "display_login": displayLogin,
    "gravatar_id": gravatarId,
    "url": url,
    "avatar_url": avatarUrl,
  };
}

class Payload {
  int? repositoryId;
  int? pushId;
  int? size;
  int? distinctSize;
  String? ref;
  String? head;
  String? before;
  List<Commit>? commits;
  String? refType;
  String? masterBranch;
  dynamic description;
  String? pusherType;

  Payload({
    this.repositoryId,
    this.pushId,
    this.size,
    this.distinctSize,
    this.ref,
    this.head,
    this.before,
    this.commits,
    this.refType,
    this.masterBranch,
    this.description,
    this.pusherType,
  });

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
    repositoryId: json["repository_id"],
    pushId: json["push_id"],
    size: json["size"],
    distinctSize: json["distinct_size"],
    ref: json["ref"],
    head: json["head"],
    before: json["before"],
    commits: json["commits"] == null ? [] : List<Commit>.from(json["commits"]!.map((x) => Commit.fromJson(x))),
    refType: json["ref_type"],
    masterBranch: json["master_branch"],
    description: json["description"],
    pusherType: json["pusher_type"],
  );

  Map<String, dynamic> toJson() => {
    "repository_id": repositoryId,
    "push_id": pushId,
    "size": size,
    "distinct_size": distinctSize,
    "ref": ref,
    "head": head,
    "before": before,
    "commits": commits == null ? [] : List<dynamic>.from(commits!.map((x) => x.toJson())),
    "ref_type": refType,
    "master_branch": masterBranch,
    "description": description,
    "pusher_type": pusherType,
  };
}

class Commit {
  String? sha;
  Author? author;
  String? message;
  bool? distinct;
  String? url;

  Commit({
    this.sha,
    this.author,
    this.message,
    this.distinct,
    this.url,
  });

  factory Commit.fromJson(Map<String, dynamic> json) => Commit(
    sha: json["sha"],
    author: json["author"] == null ? null : Author.fromJson(json["author"]),
    message: json["message"],
    distinct: json["distinct"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "sha": sha,
    "author": author?.toJson(),
    "message": message,
    "distinct": distinct,
    "url": url,
  };
}

class Author {
  String? email;
  String? name;

  Author({
    this.email,
    this.name,
  });

  factory Author.fromJson(Map<String, dynamic> json) => Author(
    email: json["email"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "name": name,
  };
}

class Repo {
  int? id;
  String? name;
  String? url;

  Repo({
    this.id,
    this.name,
    this.url,
  });

  factory Repo.fromJson(Map<String, dynamic> json) => Repo(
    id: json["id"],
    name: json["name"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "url": url,
  };
}
