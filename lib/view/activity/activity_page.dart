import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yo_bray/ulits/constant.dart';
import 'package:yo_bray/widgets/drawer_widget.dart';
import 'activity_controller.dart';
import 'component/activity_expenses_list.dart';
import 'component/activity_job_list.dart';
import 'component/activity_sell_product_list.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  // final activityController = Get.find<ActivityController>();
  final activityController = Get.put(ActivityController());

  final _tabs = <Widget>[
    Tab(icon: Text("Products")),
    Tab(icon: Text("Jobs")),
    Tab(icon: Text("Expenses")),
  ];

  @override
  void initState() {
    super.initState();
    print('activity page load');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        drawer: DrawerWidget(),
        appBar: AppBar(
          leadingWidth: leadingWidth,
          title: Text('Activity'),
          actions: [
            IconButton(
                onPressed: () {
                  activityController.fetchActivitySellProduct();
                  activityController.fetchActivityJobs();
                  activityController.fetchActivityExpense();
                },
                icon: Icon(Icons.refresh_outlined)),
          ],
        ),
        body: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              height: 45,
              child: TabBar(
                labelColor: kPrimary,
                unselectedLabelColor: Colors.black,
                tabs: _tabs,
              ),
            ),

            // create widgets for each tab bar here
            Expanded(
              child: TabBarView(
                children: [
                  // first tab bar view widget
                  ActivitySellProductList(),

                  // second tab bar viiew widget
                  ActivityJobList(),

                  // theird tab bar viiew widget
                  ActivitExpensesList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
