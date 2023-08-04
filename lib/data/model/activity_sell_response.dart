import 'dart:convert';

ActivitySellProductResponse activitySellProductResponseFromJson(String str) =>
    ActivitySellProductResponse.fromJson(json.decode(str));

String activitySellProductResponseToJson(ActivitySellProductResponse data) =>
    json.encode(data.toJson());

class ActivitySellProductResponse {
  ActivitySellProductResponse({
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
  List<SellProductModel>? data;
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

  factory ActivitySellProductResponse.fromJson(Map<String, dynamic> json) =>
      ActivitySellProductResponse(
        currentPage: json["current_page"],
        data: List<SellProductModel>.from(
            json["data"].map((x) => SellProductModel.fromJson(x))),
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

class SellProductModel {
  SellProductModel({
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
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;

  factory SellProductModel.fromJson(Map<String, dynamic> json) =>
      SellProductModel(
        id: json["id"],
        userId: json["user_id"],
        type: json["type"],
        action: json["action"],
        description: Description.fromJson(json["description"]),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "type": type,
        "action": action,
        "description": description!.toJson(),
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
      };
}

class Description {
  Description({
    this.productId,
    this.quantity,
    this.price,
    this.colorSize,
    this.colorSizeId,
    this.sellPrice,
    this.id,
    this.userId,
    this.title,
    this.featureImage,
    this.purchasePrice,
    this.salePrice,
    this.totalQuantity,
    this.description,
    this.status,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  String? productId;
  String? quantity;
  String? price;
  String? colorSize;
  String? colorSizeId;
  String? sellPrice;
  int? id;
  int? userId;
  String? title;
  String? featureImage;
  dynamic purchasePrice;
  dynamic salePrice;
  dynamic totalQuantity;
  String? description;
  dynamic status;
  int? createdBy;
  int? updatedBy;
  String? createdAt;
  String? updatedAt;

  factory Description.fromJson(Map<String, dynamic> json) => Description(
        productId: json["product_id"].toString(),
        quantity: json["quantity"].toString(),
        price: json["price"],
        colorSize: json["color_size"],
        colorSizeId: json["color_size_id"],
        sellPrice: json["sell_price "],
        id: json["id"],
        userId: json["user_id"],
        title: json["title"],
        featureImage: json["feature_image"],
        purchasePrice: json["purchase_price"],
        salePrice: json["sale_price"],
        totalQuantity: json["total_quantity"],
        description: json["description"],
        status: json["status"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "quantity": quantity,
        "price": price,
        "color_size": colorSize,
        "color_size_id": colorSizeId,
        "sell_price ": sellPrice,
        "id": id,
        "user_id": userId,
        "title": title,
        "feature_image": featureImage,
        "purchase_price": purchasePrice,
        "sale_price": salePrice,
        "total_quantity": totalQuantity,
        "description": description,
        "status": status,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt,
        "updated_at": updatedAt,
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
