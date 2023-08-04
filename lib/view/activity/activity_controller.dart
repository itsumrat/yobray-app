import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:yo_bray/data/model/activity_expense_model.dart';
import 'package:yo_bray/data/model/activity_job_response.dart';
import 'package:yo_bray/data/model/activity_sell_response.dart';
import 'package:yo_bray/data/model/jobs_response.dart';
import 'package:yo_bray/ulits/constant.dart';
import 'package:yo_bray/ulits/urls.dart';
import 'package:yo_bray/widgets/toast.dart';

class ActivityController extends GetConnect {
  final jobLoading = true.obs;
  final productLoading = true.obs;
  final expensesLoading = true.obs;

  final jobList = <Data>[].obs;
  final productList = <ActivityJobModel>[].obs;
  final expenseList = <Datum>[].obs;
  final sellProductList = <SellProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchActivitySellProduct();
    fetchActivityJobs();
    fetchActivityExpense();
    httpClient.timeout = Duration(seconds: 5);
  }

  Future<void> fetchActivityJobs() async {
    print('object');
    final header = {
      'Authorization': 'Bearer $kToken',
      'Content-Type': 'application/json'
    };
    print(header);
    log(header.toString());
    log(Urls.activityJob);
    try {
      jobList.clear();
      jobLoading(true);

      Response response =
          await httpClient.get(Urls.activityJob, headers: header);
      if (response.isOk) {
        print(response.body);
        var res = jsonDecode(response.body);
        res['data'].forEach((data) {
          Data jobModel = Data.fromJson(data);
          jobList.add(jobModel);
        });
      }
    } catch (e) {
      print('error on job fetch');
      print(e.toString());
    }
    jobLoading(false);
  }

  Future<void> fetchActivitySellProduct() async {
    final header = {
      'Authorization': 'Bearer $kToken',
      'Content-Type': 'application/json'
    };
    sellProductList.clear();
    productLoading(true);
    Response response =
        await httpClient.get(Urls.activityProduct, headers: header);
    if (response.isOk) {
      log(response.body);
      final jobresponse = activitySellProductResponseFromJson(response.body);
      sellProductList.addAll(jobresponse.data!);
      print(response.body);
    }
    productLoading(false);
  }

  Future<void> fetchActivityExpense() async {
    log('message');
    try {
      final header = {
        'Authorization': 'Bearer $kToken',
        'Content-Type': 'application/json'
      };
      expenseList.clear();
      expensesLoading(true);
      Response response =
          await httpClient.get(Urls.activityExpenses, headers: header);
      if (response.isOk) {
        log(response.body);
        final jobresponse = expenseResponseFromJson(response.body);
        expenseList.addAll(jobresponse.data!);
      }
    } catch (e) {
      errorToast(e.toString());
    }
    expensesLoading(false);
  }

  final header = {
    'Authorization': 'Bearer $kToken',
    'Content-Type': 'application/json'
  };
  Future<bool> returnExpense(int id) async {
    try {
      final url = Urls.activityExpenseReturn + '/$id/delete';
      final Response response = await get(url, headers: header);
      final data = response.bodyString ?? '';
      if (data.contains('Undo Success')) {
        successToast('Undo expense successful');
        expenseList.removeWhere((element) => element.id == id);
        return true;
      } else {
        errorToast('Error on expense return');
      }
    } catch (e) {
      errorToast('Error on expense return');
    }
    return false;
  }

  Future<bool> deleteExpenses({
    int? expenseId,
  }) async {
    try {
      final Response response = await get(
          Urls.deleteExpensesProduct + '/${expenseId!}',
          headers: header);
      if (Get.isDialogOpen!) Get.back();
      final str = jsonDecode(response.body) ?? '';
      if (str['Success'] == "Deleted Successfully") {
        successToast('Expense delete successful');
        expenseList.removeWhere((element) => element.id == expenseId);
        return true;
      } else {
        errorToast("Expense delete error");
      }
    } catch (e) {
      errorToast('Error on expense delete');
      print(e.toString());
    }
    return false;
  }

  Future<bool> deleteJob({
    int? jobId,
  }) async {
    try {
      myShowDialog();
      final Response response =
          await get(Urls.softDeleteJOb + '${jobId!}', headers: header);
      print(Urls.softDeleteJOb + '${jobId}');
      if (Get.isDialogOpen!) Get.back();
      print(response.body);
      print(response.statusCode);
      final str = jsonDecode(response.body) ?? '';
      if (str['Success'] == "Deleted Successfully") {
        jobLoading(false);
        successToast('Job deleted successfully');
        return true;
      } else {
        if (Get.isDialogOpen!) Get.back();
        errorToast("Job delete error");
      }
    } catch (e) {
      jobLoading(false);
      errorToast('Error on Job delete');
      print(e.toString());
    }
    return false;
  }
}
