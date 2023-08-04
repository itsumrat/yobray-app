import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:yo_bray/controller/auth_controller.dart';
import 'package:yo_bray/data/model/activity_job_response_model.dart';
import 'package:yo_bray/data/model/expenses_response.dart';
import 'package:yo_bray/data/model/jobs_response.dart';
import 'package:yo_bray/data/model/product_response.dart';
import 'package:yo_bray/ulits/constant.dart';
import 'package:yo_bray/ulits/urls.dart';
import 'package:yo_bray/ulits/utils.dart';
import 'package:yo_bray/widgets/toast.dart';

import '../../../notification/notification.dart';

class HomeController extends GetConnect {
  final jobList = <JobModel>[].obs;
  var jobListActive = <JobModel>[].obs;
  var feedbacks = <ActivityJobFetch>[].obs;
  // var jobResponse = <JobResponse>[].obs;
  var jobListSchedule = <JobModel>[].obs;
  var jobListSave = <JobModel>[].obs;
  final productList = <ProductModel>[].obs;
  final expensesList = <ExpensType>[].obs;

  final authcontroller = Get.find<AuthController>();
  final feedLoading = true.obs;
  final jobLoading = true.obs;
  final productLoading = true.obs;
  final expensesLoading = true.obs;
  var persistentTabController = PersistentTabController(initialIndex: 0).obs;

  @override
  void onInit() {
    super.onInit();
    fetchExpense();
    fetchProduct();
    fetchJobs(DateTime.now());

    ever(jobList, (_) {
      // jobListActive.value = jobList.where((e) => e.status == 'active').toList();
      // jobListSave.value = jobList.where((e) => e.status == 'cancel').toList();
      // jobResponse.forEach((element) {
      //   jobListSchedule.value = element.schedules!;
      //   print(element.schedules);
      // });
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  final header = {
    'Authorization': 'Bearer $kToken',
    'Content-Type': 'application/json'
  };

  Future<void> fetchJobs(time, [bool isLoading = true]) async {
    var date = Utils.formatDateApi(time.toString());
    print(date);
    try {
      jobLoading(isLoading);
      String url = '${Urls.jobs}?current_time=$date';
      Response response = await get(url, headers: header);
      print(url);
      print('object');

      print(response.bodyString);
      if (response.isOk) {
        jobList.clear();
        jobListSchedule.clear();
        jobListSave.clear();
        final jobresponse = jobResponseFromJson(response.bodyString);
        print(jobresponse.actives!.length.toString());
        jobList.addAll(jobresponse.actives!);
        jobListSave.addAll(jobresponse.saved!.data!);
        jobListSchedule.addAll(jobresponse.schedules!);
      }
    } catch (e) {
      print('error on job fetch');
      print(e.toString());
    }
    jobLoading(false);
  }

  Future deleteFeedImage({int? id, String? imageName}) async {
    Map data = {
      "id": id,
      "image_name": imageName,
    };
    print(data);
    try {
      final Response response = await post(
        Urls.feedImageDelete,
        data,
        headers: header,
      );
      final returnData = jsonDecode(response.body);
      successToast(returnData.toString());
    } catch (e) {
      errorToast(e.toString());
    }
  }

  Future deleteFeedVideo({int? id, String? videoName}) async {
    Map data = {
      "id": id,
      "video_name": videoName,
    };
    print(data);
    try {
      final Response response = await post(
        Urls.feedVideoDelete,
        data,
        headers: header,
      );
      final returnData = jsonDecode(response.body);
      successToast(returnData.toString());
    } catch (e) {
      errorToast(e.toString());
    }
  }

  Future<void> fetchProduct() async {
    try {
      productList.clear();
      productLoading(true);

      Response response = await get(Urls.product, headers: header);
      if (response.isOk) {
        final productResponse = productResponseFromJson(response.body);
        productList.addAll(productResponse.data!);
        print("product data ${productResponse.data!}");
      }
    } catch (e) {
      errorToast(e.toString());
    }
    productLoading(false);
  }

  Future<void> feedback({String? id}) async {
    log('message');
    feedLoading(true);
    feedbacks.clear();
    try {
      Response response = await get(Urls.jobs + '/$id', headers: header);
      if (response.isOk) {
        print(response.body);
        final feedback = activityJobFetchFromJson(response.body);
        feedbacks.add(feedback);
        feedLoading(false);
      }
    } catch (e) {
      // errorToast(e.toString());
    }
    productLoading(false);
  }

  Future restock({int? id, int? quantity}) async {
    try {
      final Response response = await get(
          Urls.restock + '?id=$id&quantity=$quantity',
          headers: header);
      print(response.body);
      if (response.isOk) {
        if (jsonDecode(response.body) == "Restocked successfully") {
          fetchProduct();
          successToast('Product Restocked successfully');
        } else {
          successToast(jsonDecode(response.body));
        }
      }
    } catch (e) {
      errorToast(e.toString());
    }
  }

  Future<bool> deleteProduct({int? id}) async {
    myShowDialog();
    try {
      final Response response =
          await get(Urls.deleteProduct + id.toString(), headers: header);
      if (Get.isDialogOpen!) Get.back();
      print(Urls.deleteProduct + id.toString());
      print(response.body);
      print(response.statusCode);
      var res = jsonDecode(response.body);
      if (res['Success'] == "Deleted Successfully") {
        successToast('Product delete successful');
        return true;
      } else {
        errorToast("Product delete error");
      }
    } catch (e) {
      errorToast("Product delete error");
      print('Product delete error');
      print(e.toString());
    }
    return false;
  }

  Future<bool> undoProduct(ProductModel productModel) async {
    myShowDialog();
    try {
      final Response response = await get(
          Urls.baseUrl + '/product' + '/${productModel.id}/delete',
          headers: header);
      if (Get.isDialogOpen!) Get.back();
      print(response.body);
      print(response.statusCode);

      final String str = response.body ?? '';
      if (str.contains('success')) {
        successToast('Product delete successful');
        productList.remove(productModel);
        return true;
      } else {
        errorToast("Product delete error");
      }
    } catch (e) {
      errorToast("Product delete error");
      print('Product delete error');
      print(e.toString());
    }
    if (Get.isDialogOpen!) Get.back();
    return false;
  }

  Future<void> fetchExpense() async {
    try {
      expensesList.clear();
      expensesLoading(true);

      Response response = await get(Urls.expenseName, headers: header);
      if (response.isOk) {
        final dataBody = json.decode(response.body)['data'];
        print("data body $dataBody");
        final productResponse =
            List<ExpensType>.from(dataBody.map((x) => ExpensType.fromJson(x)));
        expensesList.addAll(productResponse);
      }
    } catch (e) {
      print('expenses load error ${e.toString()}');
    }
    expensesLoading(false);
  }

  Future<bool> saveJob(int id) async {
    AuthController authController = Get.find<AuthController>();
    if (authController.isUserPaid()) {
      myShowDialog();
      try {
        final Response response =
            await get(Urls.saveJOb + '$id', headers: header);
        print(response.body);
        if (response.status.isUnauthorized) errorToast('Unauthorized');
        if (response.status.isServerError) errorToast('Network Problem');
        print(response.isOk);
        if (response.isOk) {
          if (Get.isDialogOpen!) Get.back();
          if (response.bodyString!.contains('"Success":"Already Saved"')) {
            successToast("Job Is Already saved");
          } else if (response.bodyString!
              .contains('"Success":"Save Successfully"')) {
            successToast("Job Save Successfully");
            fetchJobs(DateTime.now());
          }
        }
      } catch (e) {
        errorToast("Error saving job");
        // errorToast(e.toString());
      }
      return true;
    } else {
      errorToast('Subscribe to save job');
      return false;
    }
  }

  Future<bool> deleteSaveJob(int? id) async {
    myShowDialog();
    try {
      final Response response =
          await get(Urls.deleteSaveJOb + '$id', headers: header);
      print(Urls.deleteSaveJOb + '$id');
      print(response.body);
      if (response.status.isUnauthorized) errorToast('Unauthorized');
      if (response.status.isServerError) errorToast('Network Problem');
      print(response.isOk);
      if (response.isOk) {
        if (Get.isDialogOpen!) Get.back();
        if (response.bodyString!.contains('"Success":"Deleted Successfully"')) {
          fetchJobs(DateTime.now());
          successToast("Job Unsave Successfully");
        } else if (response.bodyString!
            .contains('"Success":"Something is Wrong"')) {
          successToast("Something is wrong");
          fetchJobs(DateTime.now());
        }
      }
    } catch (e) {
      errorToast("Error saving job");
      // errorToast(e.toString());
    }
    return true;
  }

  Future<bool> createJob(JobModel job) async {
    try {
      final Response response =
          await post(Urls.jobs, job.toJson(), headers: header);

      print(response.body);
      print(response.statusCode);
      final data = response.bodyString ?? '';

      if (response.status.isUnauthorized) errorToast('Unauthorized');
      if (response.status.isServerError)
        errorToast('Network Problem');
      else if (data.contains('0')) {
        // jobList.add(jobResponse);
        fetchJobs(DateTime.now());
        successToast('Job post create successful');

        print(
            "start data is: ${DateTime.parse(job.startingTime!).subtract(Duration(minutes: 10))}");
        print(
            "end data is: ${DateTime.parse(job.endingTime!).subtract(Duration(minutes: 2))}");

        //set notification here
        LocalNotificationService.notification(
          id: DateTime.parse(job.endingTime!).millisecondsSinceEpoch ~/ 10000,
          title: "${job.jobTitle}",
          body: "This job will be start after 10 Minutes",
          scheduledDate: DateTime.parse("${job.startingTime!}")
              .subtract(Duration(minutes: 10)),
        );

        //set notification here
        LocalNotificationService.notification(
          id: DateTime.parse(job.startingTime!).millisecondsSinceEpoch ~/ 1000,
          title: "${job.jobTitle}",
          body: "Job is be start",
          scheduledDate: DateTime.parse("${job.startingTime!}"),
        );

        //set notification here
        LocalNotificationService.notification(
          id: DateTime.parse(job.endingTime!).millisecondsSinceEpoch ~/ 1000,
          title: "${job.jobTitle}",
          body: "This job will be complete after 2 Minutes",
          scheduledDate:
              DateTime.parse(job.endingTime!).subtract(Duration(minutes: 2)),
        );

        return true;
      }
    } catch (e) {
      print('job create error');
      print(e.toString());
    }
    return false;
  }

  Future<bool> jobFeedBack(Map<String, dynamic> feed, File? file) async {
    try {
      myShowDialog();

      if (file != null) feed['feedback_file'] = await file.readAsBytes();
      print(feed);

      final Response response =
          await post(Urls.jobFeedback, json.encode(feed), headers: header);
      if (Get.isDialogOpen!) Get.back();
      print(response.body);
      print(response.statusCode);

      final body = response.bodyString ?? '';

      if (response.status.isUnauthorized) errorToast('Unauthorized');
      if (response.status.isServerError)
        errorToast('Network Problem');
      else if (body.contains('Successful')) {
        successToast('Feedback successful');
        return true;
      }
    } catch (e) {
      print('Feedback create error');
      print(e.toString());
    }
    if (Get.isDialogOpen!) Get.back();
    return false;
  }

  Future<bool> updateJob(JobModel job, String status) async {
    Map data = {
      "id": job.id,
      "job_title": job.jobTitle,
      "budget": job.budget,
      "starting_time": job.startingTime,
      "ending_time": job.endingTime,
      "status": status,
    };
    print(data.toString() + job.id.toString());
    myShowDialog();
    try {
      final Response response =
          await post(Urls.jobs + '/${job.id}', data, headers: header);
      print(Urls.jobs + '/${job.id}');
      if (Get.isDialogOpen!) Get.back();
      print(response.body);
      print(response.body.runtimeType);
      final body = response.bodyString ?? '';
      if (response.status.isUnauthorized) errorToast('Unauthorized');
      if (response.status.isServerError)
        errorToast('Network Problem');
      else if (body.contains('"success":"Update"')) {
        successToast('Job update successful');
        jobList.remove(job);
        jobList.add(job);
        // fetchJobs();
        return true;
      }
    } catch (e) {
      print('job update error');
      print(e.toString());
    }
    if (Get.isDialogOpen!) Get.back();
    return false;
  }

  Future<void> deleteJob(JobModel job) async {
    myShowDialog();
    try {
      final Response response =
          await get(Urls.jobs + '/${job.id}/delete', headers: header);
      print(Urls.jobs + '/${job.id}/delete');
      if (Get.isDialogOpen!) Get.back();
      print(response.body);
      print(response.statusCode);

      if (response.status.isUnauthorized) errorToast('Unauthorized');
      if (response.status.isServerError) errorToast('Network Problem');

      final String str = response.body ?? '';
      if (str.contains('success')) {
        successToast('Job delete successful');
        fetchJobs(DateTime.now());
      } else {
        errorToast("Job delete error");
      }
    } catch (e) {
      errorToast("Job delete error");
      print(e.toString());
    }
    if (Get.isDialogOpen!) Get.back();
  }

  Future<void> deletefeed({int? id, int? jobId}) async {
    myShowDialog();
    try {
      final Response response =
          await delete(Urls.feedbackDelete + '$id', headers: header);
      print(Urls.feedbackDelete + '$id');
      if (Get.isDialogOpen!) Get.back();
      print(response.body);
      print(response.statusCode);
      if (response.status.isUnauthorized) errorToast('Unauthorized');
      if (response.status.isServerError) errorToast('Network Problem');
      final String str = jsonDecode(response.body) ?? '';
      if (str == "Deleted Successfully") {
        feedback(id: jobId.toString());
        successToast('feed delete successful');
      } else {
        errorToast("feed delete error");
      }
    } catch (e) {
      errorToast("feed delete error");
      print(e.toString());
    }
    if (Get.isDialogOpen!) Get.back();
  }

  Future<void> createExpenses(Map<String, dynamic> body) async {
    try {
      myShowDialog();

      final Response response =
          await post(Urls.expenseName, json.encode(body), headers: header);
      final data = response.bodyString ?? '';
      print(data);
      if (Get.isDialogOpen!) Get.back();
      if (data.contains('Successful')) {
        successToast('Expenses create successful');
        fetchExpense();
        Get.back();
      } else {
        errorToast('Error on Expenses create');
      }
    } catch (e) {
      errorToast('Error on Expenses create');
    }
    if (Get.isDialogOpen!) Get.back();
  }

  Future<void> updateExpenses(Map<String, dynamic> body, int id) async {
    try {
      myShowDialog();

      final Response response = await post(
          Urls.expenseName + "/$id", json.encode(body),
          headers: header);
      print(response.body);
      print(response.statusCode);
      final str = response.bodyString ?? '';

      if (Get.isDialogOpen!) Get.back();
      if (str.contains('Successful')) {
        successToast('Expense update successful');
        fetchExpense();
        Get.back();
      } else {
        errorToast('Error on expense update');
      }
    } catch (e) {
      errorToast('Error on expense update');
    }
    if (Get.isDialogOpen!) Get.back();
  }

  Future<void> removeExpenses(int id) async {
    try {
      myShowDialog();
      final Response response =
          await get(Urls.expenseName + "/$id" + '/remove', headers: header);
      print(response.body);
      print(response.statusCode);
      final str = response.bodyString ?? '';

      if (Get.isDialogOpen!) Get.back();
      if (str.contains('Successful')) {
        successToast('Expense remove successful');
        fetchExpense();
      } else {
        errorToast('Error on remove update');
      }
    } catch (e) {
      errorToast('Error on remove update');
    }
    if (Get.isDialogOpen!) Get.back();
  }

  Future<void> deleteExpenses(int id) async {
    try {
      myShowDialog();
      final Response response =
          await get(Urls.expenseName + "/$id" + '/delete', headers: header);
      print(response.body);
      print(response.statusCode);
      final str = response.bodyString ?? '';

      if (Get.isDialogOpen!) Get.back();
      if (str.contains('Successful')) {
        successToast('Expense delete successful');
        fetchExpense();
      } else {
        errorToast('Error on delete update');
      }
    } catch (e) {
      errorToast('Error on delete update');
    }
    if (Get.isDialogOpen!) Get.back();
  }

  Future<void> referdBy(String code) async {
    try {
      myShowDialog();
      final url = Urls.baseUrl +
          "/user/${authcontroller.userinfo.value.id}" +
          '/update';
      final Response response =
          await post(url, {'referred_by': code}, headers: header);
      print(response.body);
      print(response.statusCode);
      final str = response.bodyString ?? '';

      if (Get.isDialogOpen!) Get.back();
      if (str.contains('Successful')) {
        successToast('Code add successful');
        authcontroller.getProfile();
      } else if (str.contains('Already Exits')) {
        errorToast('You already submit refeal code');
      } else {
        errorToast('Error on refered code');
      }
    } catch (e) {
      errorToast('Error on refered code');
    }
    if (Get.isDialogOpen!) Get.back();
  }

  Future<void> submitProductExpense(Map<String, dynamic> body) async {
    try {
      final Response response =
          await post(Urls.expenses, json.encode(body), headers: header);
      print(response.body);
      print(response.statusCode);

      if (response.isOk) {
        successToast('Expenses add successful');
      } else {
        errorToast('Error on Expenses add');
      }
    } catch (e) {
      errorToast('Error on Expenses add');
      print(e.toString());
    }
  }

  Future<void> submitProductSell(Map<String, dynamic> body) async {
    try {
      final Response response =
          await post(Urls.sells, json.encode(body), headers: header);
      print(response.body);
      final data = response.bodyString ?? '';
      print(response.statusCode);

      if (data.contains('Sell Success')) {
        fetchProduct();
        successToast('Sale successful');
      } else {
        errorToast('Error on Sale');
      }
    } catch (e) {
      errorToast('Error on Sale');
      print(e.toString());
    }
  }

  Future<bool> returnProductSell(int id) async {
    try {
      final Response response =
          await get(Urls.returnSells + '/$id/return', headers: header);
      print(response.body);
      final data = response.bodyString ?? '';
      print(response.statusCode);

      if (data.contains('Success')) {
        fetchProduct();
        successToast('Sell return successful');
        return true;
      } else {
        errorToast('Error on Sell return');
      }
    } catch (e) {
      errorToast('Error on Sell return');
      print(e.toString());
    }
    return false;
  }
}
