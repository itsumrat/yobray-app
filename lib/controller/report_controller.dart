import 'dart:convert';

import 'package:get/get.dart';
import 'package:yo_bray/data/model/report_details_model.dart';
import 'package:yo_bray/ulits/constant.dart';

class ReportController extends GetConnect {
  var loading = true.obs;

  final header = {
    'Authorization': 'Bearer $kToken',
    'Content-Type': 'application/json'
  };

  Future<ReportDetailsModel?> allProductReport(
      String startDate, String endDate) async {
    loading(true);
    final url =
        'https://api.yobray.com/public/api/report?fromDate=$startDate&toDate=$endDate';

    try {
      final response = await get(url, headers: header);
      loading(false);
      print(response.bodyString);

      ReportDetailsModel reportDetailsModel =
          ReportDetailsModel.fromJson(json.decode(response.body));

      return reportDetailsModel;
    } catch (e) {
      print(e.toString());
      loading(false);
    }
    print(url);
    return null;
  }

  Future<ReportDetailsModel?> allSingleProductReport(
      String startDate, String endDate, int productId, int colorSizeId) async {
    loading(true);
    final url =
        'https://api.yobray.com/public/api/report?fromDate=$startDate&toDate=$endDate&product_id=$productId&color_size_id=$colorSizeId';
    print(url);
    try {
      final response = await get(url, headers: header);
      loading(false);
      print(response.bodyString);

      ReportDetailsModel reportDetailsModel =
          ReportDetailsModel.fromJson(json.decode(response.body));

      return reportDetailsModel;
    } catch (e) {
      print(e.toString());
      loading(false);
    }
    print(url);
    return null;
  }
}
