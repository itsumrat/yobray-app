import 'package:yo_bray/data/model/line_data_model.dart';

class ReportDetailsModel {
  String bestSell, lastSaleDate;
  int totalStock, totalProduct, totalOutOfStock;
  double profit, sell, expense, totalMoney, customSale, sellReturn;
  List<LineDataModel> expensesRrap;
  List<LineDataModel> profitGrap;
  List<LineDataModel> sellGrap;
  MostSale? mostSale;
  LastOutOfStockDate? lastOutOfStockDate;

  ReportDetailsModel({
    required this.bestSell,
    required this.lastSaleDate,
    required this.sellReturn,
    required this.profit,
    required this.sell,
    required this.expense,
    required this.totalMoney,
    required this.totalStock,
    required this.totalOutOfStock,
    required this.totalProduct,
    required this.customSale,
    required this.expensesRrap,
    required this.profitGrap,
    required this.sellGrap,
    this.mostSale,
    this.lastOutOfStockDate,
  });

  static List<LineDataModel> getJsonToList(Map sellGrapData) {
    List<LineDataModel> sellGrapModelData = [];
    try {
      sellGrapData.forEach((key, value) {
        final dateValue = value as List;
        double v = double.parse("${dateValue[1]}");
        String k = key.split('-').skip(1).join('/');
        sellGrapModelData.add(LineDataModel(k, v));
      });
    } catch (e) {
      print(e.toString());
    }
    return sellGrapModelData;
  }

  static double jsonToDouble(var str) {
    double value = 0.0;
    try {
      value = double.parse('$str');
    } catch (e) {}
    return value;
  }

  factory ReportDetailsModel.fromJson(Map<String, dynamic> json) {
    final sellgrap = json['sell_grap'] as Map;
    final profitgrap = json['profit_grap'] as Map;
    final expensegrap = json['expenses_grap'] as Map;

    return ReportDetailsModel(
        bestSell: json['bestSell'] ?? '',
        lastSaleDate: getLastDate(json['last_sale_date']),
        profit: jsonToDouble(json['profit']),
        sell: jsonToDouble(json['sell']),
        expense: jsonToDouble(json['expense']),
        totalMoney: jsonToDouble(json['totalMoney']),
        totalStock: json['totalStock'] as int,
        totalOutOfStock: json['totalOutOfStock'] as int,
        totalProduct: json['totalProduct'] as int,
        customSale: jsonToDouble(json['custom_sale']),
        sellReturn: jsonToDouble(json['sell_return']),
        profitGrap: getJsonToList(profitgrap),
        expensesRrap: getJsonToList(expensegrap),
        sellGrap: getJsonToList(sellgrap),
        mostSale: json['most_sale'] != null
            ? new MostSale.fromJson(json['most_sale'])
            : null,
        lastOutOfStockDate: json['lastOutOfStockDate'] != null
            ? LastOutOfStockDate.fromJson(json['lastOutOfStockDate'])
            : null);
  }

  static String getLastDate(Map? json) {
    if (json == null) return '';
    return (json['created_at'] ?? '') as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bestSell'] = bestSell;
    data['last_sale_date'] = lastSaleDate;
    data['sell_return'] = sellReturn;
    data['profit'] = profit;
    data['sell'] = sell;
    data['expense'] = expense;
    data['totalMoney'] = totalMoney;
    data['totalStock'] = totalStock;
    data['totalProduct'] = totalProduct;
    data['custom_sale'] = customSale;
    data['profitGrap'] = profitGrap;
    data['expensesRrap'] = expensesRrap;
    data['sellGrap'] = sellGrap;
    return data;
  }
}

class MostSale {
  String? date;
  double? amount;

  MostSale({this.date, this.amount});

  static double jsonToDouble(var str) {
    double value = 0.0;
    try {
      value = double.parse('$str');
    } catch (e) {}
    return value;
  }

  MostSale.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    amount = jsonToDouble(json['amount']);
  }
}

class LastOutOfStockDate {
  int? id;
  int? productId;
  String? color;
  String? size;
  String? quantity;
  String? purcasePrice;
  String? salePrice;
  int? userId;
  int? status;
  String? outOfStock;
  String? createdAt;
  String? updatedAt;

  LastOutOfStockDate({
    this.id,
    this.productId,
    this.color,
    this.size,
    this.quantity,
    this.purcasePrice,
    this.salePrice,
    this.userId,
    this.status,
    this.outOfStock,
    this.createdAt,
    this.updatedAt,
  });

  LastOutOfStockDate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    color = json['color'];
    size = json['size'];
    quantity = json['quantity'];
    purcasePrice = json['purcase_price'];
    salePrice = json['sale_price'];
    userId = json['user_id'];
    status = json['status'];
    outOfStock = json['out_of_stock'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
