// To parse this JSON data, do
//
//     final expenseResponse = expenseResponseFromJson(jsonString);

import 'dart:convert';

ExpenseResponseModel expenseResponseFromJson(String str) =>
    ExpenseResponseModel.fromJson(json.decode(str));

String expenseResponseToJson(ExpenseResponseModel data) =>
    json.encode(data.toJson());

class ExpenseResponseModel {
  ExpenseResponseModel({
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
  List<Datum>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  dynamic nextPageUrl;
  String? path;
  String? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  factory ExpenseResponseModel.fromJson(Map<String, dynamic> json) =>
      ExpenseResponseModel(
        currentPage: json["current_page"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
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

class Datum {
  Datum({
    this.id,
    this.userId,
    this.type,
    this.action,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  int? id;
  int? userId;
  String? type;
  String? action;
  Description? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        type: json["type"],
        action: json["action"],
        description: Description.fromJson(json["description"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "type": type,
        "action": action,
        "description": description!.toJson(),
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

class Description {
  Description({
    this.productId,
    this.productTitle,
    this.productFeature,
    this.quantity,
    this.amount,
    this.expenseTypeId,
    this.expenseName,
    this.expenseId,
  });

  int? productId;
  String? productTitle;
  String? productFeature;
  int? quantity;
  String? amount;
  String? expenseTypeId;
  String? expenseName;
  int? expenseId;

  factory Description.fromJson(Map<String, dynamic> json) => Description(
        productId: json["product_id"],
        productTitle: json["product_title"],
        productFeature: json["product_feature"],
        quantity: json["quantity"],
        amount: json["amount"],
        expenseTypeId: json["expense_type_id"],
        expenseName: json["expense_name"],
        expenseId: json["expense_id"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_title": productTitle,
        "product_feature": productFeature,
        "quantity": quantity,
        "amount": amount,
        "expense_type_id": expenseTypeId,
        "expense_name": expenseName,
        "expense_id": expenseId,
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
