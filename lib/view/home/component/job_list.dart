import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yo_bray/config/app_routes.dart';
import 'package:yo_bray/controller/auth_controller.dart';
import 'package:yo_bray/data/model/jobs_response.dart';
import 'package:yo_bray/notification/notification.dart';
import 'package:yo_bray/ulits/constant.dart';
import 'package:yo_bray/ulits/utils.dart';
import 'package:yo_bray/view/activity/activity_controller.dart';
import 'package:yo_bray/view/home/controller/home_controller.dart';
import 'package:yo_bray/widgets/group_btns.dart';

class JobTab extends StatefulWidget {
  @override
  _JobTabState createState() => _JobTabState();
}

class _JobTabState extends State<JobTab> {
  final controller = Get.find<HomeController>();
  final activitycontroller = Get.put(ActivityController());
  final authController = Get.find<AuthController>();
  bool isShowDialog = false;
  bool isDraft = true;
  @override
  void initState() {
    // isShowDialog = true;
    // SchedulerBinding.instance!.addPostFrameCallback((_) {
    //   controller.jobList.forEach((element) {
    //     log(isShowDialog.toString());
    //     if (isShowReviewButton(
    //         context: context,
    //         serverDate: element.endingTime,
    //         endTime: element.endingTime)) {
    //       if (isShowDialog) {
    //         isShowDialog = true;
    //         Future.delayed(
    //             Duration.zero,
    //             () => showAlert(context, element.jobTitle, element.endingTime,
    //                 element.budget, element));
    //       }
    //     }
    //   });
    // });
    super.initState();
  }

  @override
  void dispose() {
    isShowDialog = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        if (isDraft == false) {
          setState(() {
            isDraft = true;
          });
        }
        return controller.fetchJobs(DateTime.now());
      },
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 16),
        child: Obx(() => controller.jobLoading.value
            ? Center(child: CircularProgressIndicator())
            : buildLoadedJobs()),
      ),
    );
  }

  Widget buildLoadedJobs() {
    if (controller.jobListSchedule.length == 0 &&
        controller.jobList.length == 0 &&
        controller.jobListSave.length == 0)
      return Center(
        child: RawMaterialButton(
          fillColor: kPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          onPressed: () {
            HomeController controller = Get.find<HomeController>();
            controller.persistentTabController.value.jumpToTab(2);
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Add new job',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Row(
            children: [
              Container(
                width: 70,
                decoration: BoxDecoration(
                    color: kPrimary, borderRadius: BorderRadius.circular(15.0)),
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: Center(
                  child: Text(
                    "Active",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        activeJobList(),
        SizedBox(height: 8),
        GroupBtns(onTap: (int va) {
          print(va);
          isDraft = va == 0;
          setState(() {});
        }),
        jobList(),
      ],
    );
  }

  Widget jobList() {
    print(isDraft);
    final lenght = isDraft
        ? controller.jobListSchedule.length
        : controller.jobListSave.length;
    final list = isDraft ? controller.jobListSchedule : controller.jobListSave;

    if (lenght == 0)
      return Container(
        height: 200,
        margin: const EdgeInsets.only(top: 20),
        child: Center(
          child: Text('No Item'),
        ),
      );

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: lenght,
      itemBuilder: (_, int i) {
        print('testing dialog');
        return buildJobCard(list[i], isActive: false);
      },
    );
  }

  Widget buildJobCard(JobModel item,
      {double width = double.infinity, bool isActive = false}) {
    return InkWell(
      onTap: () => Get.toNamed(AppRoutes.job_details_page, arguments: item),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Card(
          elevation: 3,
          child: Container(
            padding: const EdgeInsets.all(8),
            height: 160,
            width: width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text('${item.jobTitle}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${Utils.formatDate(item.startingTime ?? '')} - ${Utils.formatDate(item.endingTime ?? '')}',
                      style: TextStyle(fontSize: 10),
                    ),
                    Text('\$${item.budget}'),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  color: Utils.getProgress(item.startingTime, item.endingTime,
                              item.createdAt) >=
                          0.9
                      ? Colors.red
                      : Color(0xff0000FD),
                  value: Utils.getProgress(
                      item.startingTime, item.endingTime, item.createdAt),
                  backgroundColor: Colors.grey.shade300,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (isActive)
                      _buildClickItem(Icons.check, 'Done', Container(), false,
                          () {
                        if (isShowReviewButton(
                            context: context,
                            serverDate: item.endingTime,
                            endTime: item.endingTime)) {
                          showAlert(context, item.jobTitle, item.endingTime,
                              item.budget, item);
                        } else {
                          _showDoneDialog(item);
                        }
                      }),
                    if (isActive || isDraft)
                      _buildClickItem(
                          Icons.delete_outline, 'Delete', Container(), false,
                          () {
                        _showDialog(item);
                      }),
                    _buildClickItem(
                        Icons.edit_outlined, 'Edit', Container(), false, () {
                      Get.toNamed(AppRoutes.edit_job_page, arguments: item);
                    }),
                    isActive
                        ? _buildClickItem(
                            Icons.close,
                            'Save',
                            Image.asset(
                              'assets/save.png',
                              height: 100,
                            ),
                            true, () {
                            controller.saveJob(item.id!).then((value) {
                              if (isDraft == false) {
                                setState(() {
                                  isDraft = true;
                                });
                              }
                            });
                          })
                        : _buildClickItem(
                            Icons.close,
                            isDraft ? 'save' : 'Unsave',
                            Image.asset(
                              'assets/save.png',
                              height: 100,
                            ),
                            isDraft ? true : false, () {
                            isDraft
                                ? controller.saveJob(item.id!).then((value) {
                                    if (isDraft == false) {
                                      setState(() {
                                        isDraft = true;
                                      });
                                    }
                                  })
                                : controller
                                    .deleteSaveJob(item.id!)
                                    .then((value) {
                                    if (isDraft == false) {
                                      setState(() {
                                        isDraft = true;
                                      });
                                    }
                                  });
                          }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showDialog(JobModel item) {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("Delete"),
            content: Text("are you sure to delete ? "),
            // content: Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     // new ElevatedButton(
            //     //   child: const Text("Cancel"),
            //     //   onPressed: () {
            //     //     Get.back();
            //     //     item.status = 'cancel';
            //     //     item.createdAt = null;
            //     //     item.updatedAt = null;
            //     //     controller.updateJob(item);
            //     //   },
            //     // ),
            //     new ElevatedButton(
            //       child: const Text("Delete"),
            //       onPressed: () {
            //         Get.back();
            //         controller.deleteJob(item);
            //       },
            //     )
            //   ],
            // ),
            actions: <Widget>[
              TextButton(
                child: const Text("Dismiss"),
                onPressed: () {
                  Get.back();
                },
              ),
              TextButton(
                child: const Text("Delete"),
                onPressed: () {
                  Get.back();
                  controller.deleteJob(item);
                },
              )
            ],
          );
        });
  }

  _showDoneDialog(JobModel item) {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("Select your option"),
            content: const Text("Are you sure, your job done?"),
            actions: <Widget>[
              TextButton(
                child: const Text("Done"),
                onPressed: () {
                  Get.back();
                  item.status = 'done';
                  item.createdAt = null;
                  item.updatedAt = null;
                  controller.updateJob(item, 'done').then((value) {
                    controller.fetchJobs(DateTime.now());
                    activitycontroller.fetchActivityJobs();
                  });
                },
              ),
              TextButton(
                child: const Text("Dismiss"),
                onPressed: () {
                  Get.back();
                },
              )
            ],
          );
        });
  }

  Widget _buildClickItem(IconData iconData, String text, Widget icon,
      bool isWidget, Function()? onTap) {
    return InkWell(
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: isWidget ? icon : Icon(iconData),
          ),
          SizedBox(height: 4),
          Text(text),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget activeJobList() {
    if (controller.jobList.length == 0)
      return Container(
        height: 200,
        child: Center(
          child: Text('No Active Job'),
        ),
      );

    return Container(
      height: 160,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 8),
        scrollDirection: Axis.horizontal,
        itemCount: controller.jobList.length,
        itemBuilder: (BuildContext ctx, int index) =>
            buildJobCard(controller.jobList[index], width: 260, isActive: true),
      ),
    );
  }

  bool isShowReviewButton({String? serverDate, String? endTime, context}) {
    DateTime currentDate = DateTime.now();
    var date = DateTime.parse(serverDate!);
    String formattedCurrentDate = DateFormat('yyyy-MM-dd').format(currentDate);
    String formattedserverDate = DateFormat('yyyy-MM-dd').format(date);
    var convertedCurrentDate = DateTime.parse(formattedCurrentDate);
    var convertedServerDate = DateTime.parse(formattedserverDate);
    print(convertedServerDate.difference(convertedCurrentDate).inDays);
    print(formattedserverDate);
    print('time logic');

    var now = DateTime.now();
    print(DateFormat('HH:mm').format(now));
    var format = DateFormat("HH:mm");
    var firstone = format.format(date);
    var one = format.parse(firstone);
    var two = format.parse(DateFormat('HH:mm').format(now));
    print(one);
    print(two);
    print(one.difference(two).inMinutes);

    if (convertedServerDate
        .difference(convertedCurrentDate)
        .inDays
        .isNegative) {
      print('this day is not come');
      return true;
    } else if (convertedServerDate.difference(convertedCurrentDate).inDays >
        0) {
      print(convertedServerDate.difference(convertedCurrentDate).inDays);
      print('greater');
      return false;
    } else if (convertedServerDate.difference(convertedCurrentDate).inDays ==
            0 &&
        one.difference(two).inMinutes.isNegative) {
      print('this is the current');
      return true;
    } else {
      return false;
    }
  }

  void showAlert(context, String? title, String? time, String? price,
      JobModel item) async {
    await Get.dialog(
      AlertDialog(
        title: Text("Job Time Expired"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Title: " + title.toString()),
              Text("End time: " + Utils.formatDate(time.toString())),
              Text("Budget: " + price.toString()),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () async {

                      LocalNotificationService.stopNotification(DateTime.parse(item.startingTime!).millisecondsSinceEpoch ~/ 1000,);
                      LocalNotificationService.stopNotification(DateTime.parse(item.startingTime!).millisecondsSinceEpoch ~/ 1000,);
                      LocalNotificationService.stopNotification(DateTime.parse(item.endingTime!).millisecondsSinceEpoch ~/ 1000,);

                      HomeController controller = Get.find();
                      item.status = 'done';
                      await controller.updateJob(item, "done");
                      await controller.fetchJobs(DateTime.now());
                      Get.back();
                    },
                    child: Text('Mark as done'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      HomeController controller = Get.find();
                      var date = await showCustomDatePicker(context);
                      date ??= DateTime.now();
                      item.endingTime = date.toString();
                      print(item.endingTime);
                      await controller.updateJob(item, 'active');
                      Get.back();
                    },
                    child: Text('Extend Time'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    isShowDialog = false;
  }

  Future<DateTime?> showCustomDatePicker(ctx) async {
    DateTime? date;
    return showCupertinoModalPopup(
      context: ctx,
      builder: (_) => CupertinoActionSheet(
        actions: [
          SizedBox(
            height: 180,
            child: CupertinoDatePicker(
                initialDateTime: DateTime.now(),
                onDateTimeChanged: (val) {
                  date = val;
                }),
          ),
        ],
        cancelButton: CupertinoButton(
          child: Text('OK'),
          onPressed: () => Get.back(result: date),
        ),
      ),
    );
  }
}

bool isShowReviewButton({String? serverDate, String? endTime, context}) {
  DateTime currentDate = DateTime.now();
  var date = DateTime.parse(serverDate!);
  String formattedCurrentDate = DateFormat('yyyy-MM-dd').format(currentDate);
  String formattedserverDate = DateFormat('yyyy-MM-dd').format(date);
  var convertedCurrentDate = DateTime.parse(formattedCurrentDate);
  var convertedServerDate = DateTime.parse(formattedserverDate);
  print(convertedServerDate.difference(convertedCurrentDate).inDays);
  print(formattedserverDate);
  print('time logic');

  var now = DateTime.now();
  print(DateFormat('HH:mm').format(now));
  var format = DateFormat("HH:mm");
  var firstone = format.format(date);
  var one = format.parse(firstone);
  var two = format.parse(DateFormat('HH:mm').format(now));
  print(one);
  print(two);
  print(one.difference(two).inMinutes);

  if (convertedServerDate.difference(convertedCurrentDate).inDays.isNegative) {
    print('this day is not come');
    return true;
  } else if (convertedServerDate.difference(convertedCurrentDate).inDays > 0) {
    print(convertedServerDate.difference(convertedCurrentDate).inDays);
    print('greater');
    return false;
  } else if (convertedServerDate.difference(convertedCurrentDate).inDays == 0 &&
      one.difference(two).inMinutes.isNegative) {
    print('this is the current');
    return true;
  } else {
    return false;
  }
}

void showAlert(
    context, String? title, String? time, String? price, JobModel item) async {
  await Get.dialog(
    AlertDialog(
      title: Text("Job Time Expired"),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Title: " + title.toString()),
            Text("End time: " + Utils.formatDate(time.toString())),
            Text("Budget: " + price.toString()),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    HomeController controller = Get.find();
                    item.status = 'done';
                    await controller.updateJob(item, "done");
                    await controller.fetchJobs(DateTime.now());
                    Get.back();
                  },
                  child: Text('Mark as done'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    HomeController controller = Get.find();
                    var date = await showCustomDatePicker(context);
                    date ??= DateTime.now();
                    item.endingTime = date.toString();
                    print(item.endingTime);
                    await controller.updateJob(item, 'active');
                    Get.back();
                  },
                  child: Text('Extend Time'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Future<DateTime?> showCustomDatePicker(ctx) async {
  DateTime? date;
  return showCupertinoModalPopup(
    context: ctx,
    builder: (_) => CupertinoActionSheet(
      actions: [
        SizedBox(
          height: 180,
          child: CupertinoDatePicker(
              initialDateTime: DateTime.now(),
              onDateTimeChanged: (val) {
                date = val;
              }),
        ),
      ],
      cancelButton: CupertinoButton(
        child: Text('OK'),
        onPressed: () => Get.back(result: date),
      ),
    ),
  );
}
