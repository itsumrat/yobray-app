import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:yo_bray/ulits/constant.dart';
import 'package:yo_bray/view/add_new/add_new_page.dart';
import 'package:yo_bray/view/home/component/job_list.dart';
import 'package:yo_bray/view/home/controller/home_controller.dart';
import 'package:yo_bray/view/report/product_repot_page.dart';

import 'activity/activity_page.dart';
import 'home/home_page.dart';

class AppPage extends StatefulWidget {
  const AppPage({Key? key}) : super(key: key);

  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  HomeController controller = Get.put(HomeController());
  bool isShowDialog = false;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Timer.periodic(Duration(seconds: 5), (timer) async {
        await controller.fetchJobs(DateTime.now(), false);
        controller.jobList.forEach((element) async {
          log(isShowDialog.toString());
          if (isShowReviewButton(
              context: context,
              serverDate: element.endingTime,
              endTime: element.endingTime)) {
            if (!isShowDialog) {
              isShowDialog = true;
              await Future.delayed(
                  Duration.zero,
                  () => showAlert(context, element.jobTitle, element.endingTime,
                      element.budget, element));
              isShowDialog = false;
            }
          }
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PersistentTabView(
        context,
        controller: controller.persistentTabController.value,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset: true,
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows: true,
        decoration: NavBarDecoration(
          // borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties(
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
            NavBarStyle.style6, // Choose the nav bar style with this property.
      ),
    );
  }

  List<Widget> _buildScreens() {
    return [HomePage(), ActivityPage(), AddNewPage(), ProductReportPage()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: ("Home"),
        activeColorPrimary: kPrimary,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.arrow_clockwise),
        title: ("Activity"),
        activeColorPrimary: kPrimary,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.add_circled_solid),
        title: ("Add New"),
        activeColorPrimary: kPrimary,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.graph_circle),
        title: ("Report"),
        activeColorPrimary: kPrimary,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }
}
