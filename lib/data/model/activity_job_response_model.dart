// To parse this JSON data, do
//
//     final activityJobFetch = activityJobFetchFromJson(jsonString);

import 'dart:convert';

ActivityJobFetch activityJobFetchFromJson(String str) =>
    ActivityJobFetch.fromJson(json.decode(str));

String activityJobFetchToJson(ActivityJobFetch data) =>
    json.encode(data.toJson());

class ActivityJobFetch {
  ActivityJobFetch({
    this.id,
    this.jobTitle,
    this.description,
    this.budget,
    this.status,
    this.startingTime,
    this.endingTime,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.feedbacks,
  });

  int? id;
  String? jobTitle;
  String? description;
  String? budget;
  String? status;
  DateTime? startingTime;
  DateTime? endingTime;
  int? userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  List<Feedbacks>? feedbacks;

  factory ActivityJobFetch.fromJson(Map<String, dynamic> json) =>
      ActivityJobFetch(
        id: json["id"],
        jobTitle: json["job_title"],
        description: json["description"],
        budget: json["budget"],
        status: json["status"],
        startingTime: DateTime.parse(json["starting_time"]),
        endingTime: DateTime.parse(json["ending_time"]),
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        feedbacks: List<Feedbacks>.from(
            json["feedbacks"].map((x) => Feedbacks.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "job_title": jobTitle,
        "description": description,
        "budget": budget,
        "status": status,
        "starting_time": startingTime!.toIso8601String(),
        "ending_time": endingTime!.toIso8601String(),
        "user_id": userId,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "deleted_at": deletedAt,
        "feedbacks": List<dynamic>.from(feedbacks!.map((x) => x.toJson())),
      };
}

class Feedbacks {
  Feedbacks({
    this.id,
    this.jobId,
    this.title,
    this.productTitle,
    this.description,
    this.file,
    this.video,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? jobId;
  dynamic title;
  dynamic productTitle;
  String? description;
  dynamic file;
  dynamic video;
  int? userId;
  String? createdAt;
  String? updatedAt;

  factory Feedbacks.fromJson(Map<String, dynamic> json) => Feedbacks(
        id: json["id"],
        jobId: json["job_id"],
        title: json["title"],
        productTitle: json["product_title"],
        description: json["description"],
        file: json["file"],
        video: json["video"],
        userId: json["user_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "job_id": jobId,
        "title": title,
        "product_title": productTitle,
        "description": description,
        "file": file,
        "video": video,
        "user_id": userId,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
