import 'dart:convert';

ActivityJob activityJobFromJson(String str) =>
    ActivityJob.fromJson(json.decode(str));

// String activityJobToJson(ActivityJob data) => json.encode(data.toJson());

class ActivityJob {
  ActivityJob({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  int? currentPage;
  List<ActivityJobModel>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  String? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  factory ActivityJob.fromJson(Map<String, dynamic> json) => ActivityJob(
        currentPage: json["current_page"],
        data: List<ActivityJobModel>.from(
            json["data"].map((x) => ActivityJobModel.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  // Map<String, dynamic> toJson() => {
  //       "current_page": currentPage,
  //       "data": List<dynamic>.from(data.map((x) => x.toJson())),
  //       "first_page_url": firstPageUrl,
  //       "from": from,
  //       "last_page": lastPage,
  //       "last_page_url": lastPageUrl,
  //       "next_page_url": nextPageUrl,
  //       "path": path,
  //       "per_page": perPage,
  //       "prev_page_url": prevPageUrl,
  //       "to": to,
  //       "total": total,
  //     };
}

class ActivityJobModel {
  ActivityJobModel({
    this.id,
    this.userId,
    this.type,
    this.action,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? userId;
  String? type;
  String? action;
  String? description;
  String? createdAt;
  String? updatedAt;

  factory ActivityJobModel.fromJson(Map<String, dynamic> json) =>
      ActivityJobModel(
        id: json["id"],
        userId: json["user_id"],
        type: json["type"],
        action: json["action"],
        description: json["description"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "type": type,
        "action": action,
        "description": description,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
