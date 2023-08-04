import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:yo_bray/config/app_routes.dart';
import 'package:yo_bray/data/model/color_name.dart';
import 'package:yo_bray/ulits/urls.dart';

class Utils {
  static ImagePicker _picker = ImagePicker();
  static DateTime _selectedDate = DateTime.now();
  static TimeOfDay _initialTime = TimeOfDay.now();

  static String getSecondToMinute(int s) {
    final minute = Duration(seconds: s);
    return minute.toString().split('.')[0];
  }

  static String numberCompact(int number) =>
      NumberFormat.compact().format(number);

  static String formatPrice(double price) => '\$${price.toStringAsFixed(1)}';

  static String formatDate(String? date) {
    try {
      if (date == null) return '--';
      final dateTime = DateTime.parse(date).toLocal();

      return DateFormat('dd-MM-yy hh:mm a').format(dateTime);
    } catch (e) {
      return '--';
    }
  }

  static String formatDateApi(String? date) {
    try {
      if (date == null) return '--';
      final dateTime = DateTime.parse(date).toLocal();
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    } catch (e) {
      return '--';
    }
  }

  static DateTime stringToDadteTime(String date) {
    return DateTime.parse(date).toLocal();
  }

  static Future<DateTime?> selectDate(BuildContext context) => showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(1990, 1),
        lastDate: DateTime(2050),
      );

  static Future<TimeOfDay?> selectTime(BuildContext context) =>
      showTimePicker(context: context, initialTime: _initialTime);

  static Future<File?> pickFile(ImageSource imageSource) async {
    final XFile? image =
        await _picker.pickImage(source: imageSource, imageQuality: 50);
    if (image == null) return null;

    return File(image.path);
  }

  static Future<File?> pickVideo(ImageSource imageSource) async {
    final XFile? image = await _picker.pickVideo(source: imageSource);
    if (image == null) return null;
    return File(image.path);
  }

  static Future<String?> pickColor(BuildContext context) async {
    String color = 'White';

    void changeColor(String col) => color = col;

    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade200,
          titlePadding: const EdgeInsets.all(0.0),
          contentPadding: const EdgeInsets.all(0.0),
          content: SingleChildScrollView(
            child: Column(
              children: colorNameList
                  .map(
                    (ColorName item) => ListTile(
                      onTap: () {
                        changeColor(item.name);
                        Get.back(result: color);
                      },
                      title: Text(item.name),
                      trailing: getColorArea(item.color),
                    ),
                  )
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Cancle', style: const TextStyle(color: Colors.red)),
            ),
            TextButton(
                onPressed: () {
                  Get.back(result: color);
                },
                child: const Text('Pick')),
          ],
        );
      },
    );
  }

  static Future<void> showSubscriptionWorning(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade200,
          title: const Text("This is for paid user"),
          content: Text("Would you like to become paid user"),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child:
                  Text('Dissmiss', style: const TextStyle(color: Colors.red)),
            ),
            TextButton(
                onPressed: () {
                  Get.back();
                  Get.toNamed(AppRoutes.subscription_page);
                },
                child: const Text('Buy Now')),
          ],
        );
      },
    );
  }

  static Widget getColorArea(Color color) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  static double getProgress(
      String? startingTime, String? endingTime, String? createdTime) {
    if (startingTime == null || endingTime == null || createdTime == null)
      return 0;
    try {
      final _now = DateTime.now();
      final startDate = DateTime.parse(startingTime).toLocal();
      final endDate = DateTime.parse(endingTime).toLocal();
      final createdDate = DateTime.parse(createdTime).toLocal();
      print(
          'startDate: ${startDate.toString()}, endDate: ${endDate.toString()}, createdDate: ${createdDate.toString()}');

      if (startDate.isAfter(_now)) {
        final createdToStartDiff = startDate.difference(createdDate);
        final nowToStartDiff = startDate.difference(_now);
        print("createdDifference difference: " +
            createdToStartDiff.inSeconds.toString());
        print(
            "nowdifference difference: " + nowToStartDiff.inSeconds.toString());
        print("progress: " +
            (1 -
                    (nowToStartDiff.inSeconds.abs() /
                        createdToStartDiff.inSeconds.abs()))
                .toString());
        return (1 -
            (nowToStartDiff.inSeconds.abs() /
                createdToStartDiff.inSeconds.abs()));
      }
      if (endDate.isBefore(_now)) return 1;

      final totalDifference = endDate.difference(startDate).inSeconds.abs();
      final doneDifference = _now.difference(startDate).inSeconds.abs();
      // print(totalDifference);
      // print(doneDifference);

      final progres = doneDifference / totalDifference;
      // print('progres $progres');
      if (progres > 1) return 1;
      return progres;
    } catch (e) {
      print(e.toString());
    }
    return 0;
  }

  static Future<ImageSource?> showImageSource(BuildContext context) async {
    if (Platform.isIOS)
      return showCupertinoModalPopup<ImageSource>(
        context: context,
        builder: (_) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Get.back(result: ImageSource.camera);
                // Navigator.of(context).pop(ImageSource.camera);
              },
              child: Text("Camera"),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Get.back(result: ImageSource.gallery);
                // Navigator.of(context).pop(ImageSource.gallery);
              },
              child: Text("Gallery"),
            )
          ],
        ),
      );
    else
      return showModalBottomSheet(
        context: context,
        builder: (_) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("Camera"),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            ListTile(
              leading: Icon(Icons.image),
              title: Text("Gallery"),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            )
          ],
        ),
      );
  }

  static String getProfilePicture(String pic) {
    if (pic.startsWith('https://') || pic.startsWith('www.')) {
      return pic;
    }
    return Urls.profileImage + pic;
  }
}
