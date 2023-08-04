import 'dart:convert';

ExpenseResponse expensesResponseFromJson(String str) =>
    ExpenseResponse.fromJson(json.decode(str));

String expensesResponseToJson(ExpenseResponse data) =>
    json.encode(data.toJson());

class ExpenseResponse {
  int? currentPage;
  List<ExpensesModel>? data;
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

  ExpenseResponse(
      {this.currentPage,
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
      this.total});

  ExpenseResponse.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    data = <ExpensesModel>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data!.add(new ExpensesModel.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class ExpensesModel {
  int? id;
  int? productId;
  int? userId;
  String? quantity;
  int? amount;
  int? expenseTypeId;
  String? createdAt;
  String? updatedAt;
  ExpensType? expensType;

  ExpensesModel(
      {this.id,
      this.productId,
      this.userId,
      this.quantity,
      this.amount,
      this.expenseTypeId,
      this.createdAt,
      this.updatedAt,
      this.expensType});

  ExpensesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    userId = json['user_id'];
    quantity = json['quantity'];
    amount = json['amount'];
    expenseTypeId = json['expense_type_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    expensType = json['expens_type'] != null
        ? new ExpensType.fromJson(json['expens_type'])
        : null;
  }

  ExpensesModel.activityJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    quantity = json['quantity'];
    amount = json['amount'];
    expenseTypeId = json['expense_type_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['user_id'] = this.userId;
    data['quantity'] = this.quantity;
    data['amount'] = this.amount;
    data['expense_type_id'] = this.expenseTypeId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.expensType != null) {
      data['expens_type'] = this.expensType?.toJson();
    }
    return data;
  }
}

class ExpensType {
  int? id;
  String? name;
  int? status;
  int? userId;
  String? createdAt;
  String? updatedAt;

  ExpensType(
      {this.id,
      this.name,
      this.status,
      this.userId,
      this.createdAt,
      this.updatedAt});

  ExpensType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
