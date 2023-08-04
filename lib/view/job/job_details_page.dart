import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yo_bray/config/app_routes.dart';
import 'package:yo_bray/controller/auth_controller.dart';
import 'package:yo_bray/data/model/jobs_response.dart';
import 'package:yo_bray/ulits/constant.dart';
import 'package:yo_bray/ulits/urls.dart';
import 'package:yo_bray/ulits/utils.dart';
import 'package:yo_bray/view/home/controller/home_controller.dart';
import 'package:yo_bray/widgets/image_preview_page.dart';
import 'package:yo_bray/widgets/video_player.dart';
import 'package:yo_bray/widgets/video_preview_page.dart';

import 'add_feed_page.dart';

class JobDetailsScreen extends StatefulWidget {
  JobDetailsScreen({Key? key, this.isFromActivity = false}) : super(key: key);
  final bool isFromActivity;

  @override
  _JobDetailsScreenState createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  final controller = Get.find<HomeController>();
  final authController = Get.find<AuthController>();

  JobModel item = Get.arguments as JobModel;
  @override
  void initState() {
    controller.feedback(id: item.id.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Job Details'), leadingWidth: leadingWidth),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          jobDetailsCard(),
          Divider(color: Colors.grey, height: 40),
          SizedBox(height: 10),
          Text("Feed", style: TextStyle(fontSize: 24)),
          SizedBox(height: 20),
          Obx(() => controller.feedLoading.value
              ? Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: controller.feedbacks[0].feedbacks!
                      .map((element) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 3,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    getFileWidget(element.file ?? ''),
                                    getFileWidget(element.video ?? ''),
                                    _buildTextOrSizeBox(
                                        element.productTitle ?? ''),
                                    _buildTextOrSizeBox(
                                        element.description ?? ''),
                                    _buildTextOrSizeBox(Utils.formatDate(
                                        element.createdAt ?? '')),
                                    Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        _buildClickItem(
                                            Icons.delete,
                                            'delete',
                                            () => _showDialog(item, false,
                                                id: element.id)),
                                        _buildClickItem(
                                            Icons.edit,
                                            'edit',
                                            () => Get.to(
                                                () => AddFeedPage(
                                                      isFromActivity:
                                                          widget.isFromActivity,
                                                      note: element.description,
                                                      networkImage:
                                                          element.file,
                                                      isEditPage: true,
                                                      id: element.id,
                                                    ),
                                                arguments: item.id!)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                )),
          // getJobNote(controller.feedbacks[0].feedbacks),
        ],
      ),
    );
  }

  Widget jobDetailsCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${item.jobTitle}",
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 15),
        LinearProgressIndicator(
          color: Utils.getProgress(item.startingTime, item.endingTime, item.createdAt) >= 0.9
              ? Colors.red
              : Color(0xff0000FD),
          value: Utils.getProgress(item.startingTime, item.endingTime, item.createdAt),
          backgroundColor: Colors.grey.shade300,
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                '${Utils.formatDate(item.startingTime ?? '')} - ${Utils.formatDate(item.endingTime ?? '')}',
              ),
            ),
            Text('\$${item.budget}', style: TextStyle(color: Colors.blue)),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (!widget.isFromActivity) ...[
              _buildClickItem(Icons.check, 'Done', () {
                _showDoneDialog(item);
              }),
              _buildClickItem(Icons.delete_outline, 'Delete', () {
                _showDialog(item, true);
              }),
              _buildClickItem(Icons.edit_outlined, 'Edit', () {
                Get.offNamed(AppRoutes.edit_job_page, arguments: item);
              }),
            ],
            _buildClickItem2(
                Icons.close,
                'Edit',
                Image.asset(
                  'assets/save.png',
                  height: 100,
                ),
                true, () {
              controller.saveJob(item.id!).then((value) {});
            }),
            // _buildClickItem(Icons.copy, 'Copy', () {
            //   if (authController.isUserPaid())
            //     Get.offNamed(AppRoutes.copy_job_page, arguments: item);
            //   else {
            //     Utils.showSubscriptionWorning(context);
            //   }
            // }),
            _buildClickItem(
              Icons.add_box_outlined,
              'Add Feed',
              () async {
                //wait for feedback page back
                final result = await Get.to(
                    () => AddFeedPage(
                          isFromActivity: widget.isFromActivity,
                          isEditPage: false,
                        ),
                    arguments: item.id!);
                //if feedback submit ok then update the item where item from activity job
                if (result != null && result && widget.isFromActivity) {
                  // final activityController = Get.find<ActivityController>();
                  // item = activityController.jobList.firstWhere(
                  //     (element) => element.id == item.id,
                  //     orElse: () => item);
                  setState(() {});
                }
                //if feedback submit ok then update the item where item from home job
                if (result != null && result && !widget.isFromActivity) {
                  item = controller.jobList.firstWhere(
                      (element) => element.id == item.id,
                      orElse: () => item);
                  setState(() {});
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildClickItem2(IconData iconData, String text, Widget icon,
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
          Text('Save')
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildClickItem(IconData iconData, String text, Function()? onTap) {
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
            child: Icon(iconData),
          ),
          SizedBox(height: 4),
          Text(text)
        ],
      ),
      onTap: onTap,
    );
  }

  _showDialog(JobModel item, bool isjobdelete, {int? id}) {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("Delete"),
            content: Text("are you sure to delete ? "),
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
                  if (isjobdelete) {
                    controller.deleteJob(item);
                  } else {
                    controller.deletefeed(id: id, jobId: item.id);
                  }
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
            title: new Text("Select your option"),
            content: Text("Are you sure, your job done?"),
            actions: <Widget>[
              new TextButton(
                child: new Text("Done"),
                onPressed: () {
                  Get.back();
                  item.status = 'done';
                  controller.updateJob(item, "done");
                },
              ),
              new TextButton(
                child: new Text("Dismiss"),
                onPressed: () {
                  Get.back();
                },
              )
            ],
          );
        });
  }

  // Widget getJobNote(List<Feedbacks>? feedbacks) {
  //   // if (feedbacks.length == 0) return SizedBox();
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: feedbacks!.map((e) => singleFeeb(e)).toList(),
  //   );
  // }

  Widget _buildTextOrSizeBox(String str) {
    if (str.isNotEmpty) return Text(str);
    return SizedBox();
  }

  Widget getFileWidget(String file) {
    if (file.isEmpty) return SizedBox();

    return Wrap(
      children: file.split(',').map((e) {
        if (GetUtils.isImage(e))
          return imageView(e);
        else if (GetUtils.isVideo(e)) return videoView(e);
        return videoView(e);
      }).toList(),
    );
  }

  Widget videoView(String e) {
    return InkWell(
      onTap: () {
        Get.to(() => VideoPreviewPage(path: e));
      },
      child: VideoPlayerWidget(path: e),
    );
  }

  Widget imageView(String e) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 130,
        maxWidth: 130,
      ),
      child: InkWell(
        onTap: () {
          Get.to(() => ImagePreviewPage(imagePath: Urls.feedbackFile + e));
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: CachedNetworkImage(
            imageUrl: Urls.feedbackFile + e,
            fit: BoxFit.contain,
            placeholder: (context, url) =>
                Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>
                Image.asset('assets/dumy.jpg', fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
