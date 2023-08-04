import 'dart:convert';

import 'package:equatable/equatable.dart';

ProductResponse productResponseFromJson(String str) =>
    ProductResponse.fromJson(json.decode(str));

String productResponseToJson(ProductResponse data) =>
    json.encode(data.toJson());

class ProductResponse {
  ProductResponse({
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
  List<ProductModel>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      ProductResponse(
        currentPage: json["current_page"],
        data: json["data"] != null
            ? List<ProductModel>.from(
                json["data"].map((x) => ProductModel.fromJson(x)))
            : [],
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

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": data != null || data!.isNotEmpty
            ? List<dynamic>.from(data!.map((x) => x.toJson()))
            : null,
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class ProductModel {
  ProductModel({
    this.id,
    this.userId,
    this.title,
    this.featureImage,
    this.purchasePrice,
    this.salePrice,
    this.totalQuantity,
    this.description,
    this.feature,
    this.status,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.colorSize,
  });

  int? id;
  int? userId;
  String? title;
  String? featureImage;
  String? feature;
  String? purchasePrice;
  String? salePrice;
  String? totalQuantity;
  String? description;
  String? status;
  int? createdBy;
  int? updatedBy;
  String? createdAt;
  String? updatedAt;
  List<ColorSizeModel>? colorSize;

  @override
  String toString() {
    return '$title, $description, $purchasePrice';
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
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
        colorSize: json["color_size"] != null
            ? List<ColorSizeModel>.from(
                json["color_size"].map((x) => ColorSizeModel.fromJson(x)))
            : <ColorSizeModel>[],
      );
  factory ProductModel.fromJsonActivity(Map<String, dynamic> json) =>
      ProductModel(
        // id: json["id"],
        userId: json["user_id"],
        title: json["title"],
        // featureImage: json["feature_image"],
        purchasePrice: json["purchase_price"],
        salePrice: json["sale_price"],
        totalQuantity: json["total_quantity"],
        description: json["description"],
        feature: json["feature"],
        status: json["status"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        colorSize: json["color_size"] != null
            ? List<ColorSizeModel>.from(
                json["color_size"].map((x) => ColorSizeModel.fromJson(x)))
            : <ColorSizeModel>[],
      );

  Map<String, dynamic> toJson() => {
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
        "color_size": colorSize!.length > 0
            ? List<dynamic>.from(colorSize!.map((x) => x.toJson()))
            : null,
      };
}

class ColorSizeModel extends Equatable {
  ColorSizeModel({
    this.id,
    this.productId,
    this.color,
    this.size,
    this.quantity,
    this.purcasePrice,
    this.salePrice,
    this.userId,
    this.status,
    this.columnAction,
    this.createdAt,
    this.updatedAt,
  });

  List<Object?> get props =>
      [id, size, purcasePrice, color, salePrice, quantity];

  int? id;
  int? productId;
  String? color;
  String? size;
  String? quantity;
  String? purcasePrice;
  String? salePrice;
  int? userId;
  int? status;
  String? columnAction;
  String? createdAt;
  String? updatedAt;

  factory ColorSizeModel.fromJson(Map<String, dynamic> json) => ColorSizeModel(
        id: json["id"],
        productId: json["product_id"],
        color: json["color"],
        size: json["size"],
        quantity: json["quantity"],
        purcasePrice: json["purcase_price"],
        salePrice: json["sale_price"],
        userId: json["user_id"],
        status: json["status"],
        columnAction: json["column_action"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "color": color,
        "size": size,
        "quantity": quantity,
        "purcase_price": purcasePrice,
        "sale_price": salePrice,
        "user_id": userId,
        "status": status,
        "column_action": columnAction,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
