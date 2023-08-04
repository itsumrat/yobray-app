
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';
import 'package:yo_bray/data/model/jobs_response.dart';
import 'package:yo_bray/ulits/strings.dart';
import 'package:yo_bray/ulits/utils.dart';
import 'package:yo_bray/view/activity/activity_controller.dart';
import 'package:yo_bray/view/home/controller/home_controller.dart';
import 'package:yo_bray/view/job/job_details_page.dart';

class ActivityJobList extends StatefulWidget {
  ActivityJobList({Key? key}) : super(key: key);

  @override
  _ActivityJobListState createState() => _ActivityJobListState();
}

class _ActivityJobListState extends State<ActivityJobList> {
  final controller = Get.find<ActivityController>();

  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => controller.fetchActivityJobs(),
      child: Obx(() => controller.jobLoading.value
          ? Center(child: CircularProgressIndicator())
          : _buildLoadedWidget()),
    );
  }

  Widget _buildLoadedWidget() {
    if (controller.jobList.length == 0)
      return ListView(
        children: [
          SizedBox(height: 20),
          Center(child: Text('No Item')),
        ],
      );

    return ListView.builder(
      padding: EdgeInsets.all(8),
      itemCount: controller.jobList.length,
      itemBuilder: (BuildContext ctx, int index) =>
          controller.jobList[index].description!.status == "done"
              ? _jobCard(controller.jobList[index])
              : Container(),
    );
  }

  Widget _jobCard(Data item) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${item.description!.jobTitle.toString()}',
              style: TextStyle(color: Colors.blue),
            ),
            SizedBox(height: 4),
            Text("🕒 ${Utils.formatDate(item.updatedAt)}"),
            SizedBox(height: 4),
            Row(
              children: [
                SizedBox(width: 2),
                Image.asset("assets/currency.png", height: 14, width: 14),
                SizedBox(width: 4),
                Text(_getPrice(item.description!.budget)),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                actionIcon(
                  child: Icon(Icons.delete),
                  text: 'Delete',
                  onTap: () {
                    controller.deleteJob(jobId: item.id).then((value) {
                      controller.fetchActivityJobs();
                    });
                  },
                ),
                // actionIcon(
                //   child: Image.asset('assets/save.png'),
                //   text: 'Save',
                //   onTap: () {
                //     Get.toNamed(AppRoutes.copy_job_page, arguments: item);
                //   },
                // ),
                actionIcon(
                  child: Icon(Icons.remove_red_eye_outlined),
                  text: 'Details',
                  onTap: () {
                    Get.to(() => JobDetailsScreen(isFromActivity: true),
                        arguments: item.description);
                  },
                ),
                actionIcon(
                  child: Icon(Icons.share),
                  text: 'Share',
                  onTap: () {
                    Share.share(Strings.jobShare);
                  },
                ),
                // actionIcon(
                //   child: Icon(Icons.undo_outlined),
                //   text: 'Undo',
                //   onTap: () {
                //     _showDoneDialog(item);
                //   },
                // ),
                // actionIcon(
                //   child: Transform.rotate(
                //     angle: 45 * pi / 180,
                //     child: Icon(Icons.wifi),
                //   ),
                //   text: 'Feed',
                //   onTap: () {
                //     Get.toNamed(AppRoutes.add_feed_page, arguments: item.id!);
                //   },
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Future _showDoneDialog(JobModel item) {
  //   return showDialog(
  //       context: context,
  //       builder: (_) {
  //         return AlertDialog(
  //           title: new Text("Are you sure"),
  //           content: Text("Do you want to undo job"),
  //           actions: <Widget>[
  //             new ElevatedButton(
  //               style: ElevatedButton.styleFrom(primary: Colors.redAccent),
  //               child: new Text("Cancel"),
  //               onPressed: () {
  //                 Get.back();
  //               },
  //             ),
  //             new ElevatedButton(
  //               child: new Text("Ok"),
  //               onPressed: () async {
  //                 Get.back();
  //                 item.status = 'active';
  //                 final isDone = await homeController.updateJob(item);
  //                 if (isDone) controller.fetchActivityJobs();
  //               },
  //             ),
  //           ],
  //         );
  //       });
  // }

  Widget actionIcon(
      {required String text,
      required Widget child,
      required VoidCallback onTap}) {
    return InkWell(
      child: Column(
        children: [
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: child,
          ),
          SizedBox(height: 4),
          Text(
            text,
            style: TextStyle(fontSize: 12),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  String _getPrice([String? budget = '0.0']) {
    try {
      final value = double.parse(budget!);
      return Utils.formatPrice(value);
    } catch (e) {
      return '0';
    }
  }
}
