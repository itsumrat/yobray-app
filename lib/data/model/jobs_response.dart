// To parse this JSON data, do
//
//     final jobResponse = jobResponseFromJson(jsonString);

import 'dart:convert';

JobResponse jobResponseFromJson(String? str) =>
    JobResponse.fromJson(json.decode(str!));

String jobResponseToJson(JobResponse data) => json.encode(data.toJson());

class JobResponse {
  JobResponse({
    this.actives,
    this.schedules,
    this.saved,
  });

  List<JobModel>? actives;
  List<JobModel>? schedules;
  Saved? saved;

  factory JobResponse.fromJson(Map<String, dynamic> json) => JobResponse(
        actives: List<JobModel>.from(
            json["actives"].map((x) => JobModel.fromJson(x))),
        schedules: List<JobModel>.from(
            json["schedules"].map((x) => JobModel.fromJson(x))),
        saved: Saved.fromJson(json["saved"]),
      );

  Map<String, dynamic> toJson() => {
        "actives": List<dynamic>.from(actives!.map((x) => x.toJson())),
        "schedules": List<dynamic>.from(schedules!.map((x) => x.toJson())),
        "saved": saved!.toJson(),
      };
}

class Data {
  int? id;
  int? userId;
  String? type;
  String? action;
  JobModel? description;
  String? createdAt;
  String? updatedAt;
  Null deletedAt;

  Data(
      {this.id,
      this.userId,
      this.type,
      this.action,
      this.description,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    type = json['type'];
    action = json['action'];
    description = json['description'] != null
        ? new JobModel.fromJson(json['description'])
        : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['type'] = this.type;
    data['action'] = this.action;
    if (this.description != null) {
      data['description'] = this.description!.toJson();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class JobModel {
  JobModel({
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
  });

  int? id;
  String? jobTitle;
  String? description;
  String? budget;
  String? status;
  String? startingTime;
  String? endingTime;
  int? userId;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;

  factory JobModel.fromJson(Map<String, dynamic> json) => JobModel(
        id: json["id"],
        jobTitle: json["job_title"],
        description: json["description"],
        budget: json["budget"],
        status: json["status"],
        startingTime: json["starting_time"],
        endingTime: json["ending_time"],
        userId: json["user_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "job_title": jobTitle,
        "description": description,
        "budget": budget,
        "status": status,
        "starting_time": startingTime,
        "ending_time": endingTime,
        "user_id": userId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
      };
}

class Saved {
  Saved({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  int? currentPage;
  List<JobModel>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  factory Saved.fromJson(Map<String, dynamic> json) => Saved(
        currentPage: json["current_page"],
        data:
            List<JobModel>.from(json["data"].map((x) => JobModel.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": List<dynamic>.from(links!.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Link {
  Link({
    this.url,
    this.label,
    this.active,
  });

  String? url;
  String? label;
  bool? active;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"] == null ? null : json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url == null ? null : url,
        "label": label,
        "active": active,
      };
}
