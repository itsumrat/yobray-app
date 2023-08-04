import 'package:flutter/material.dart';
import 'package:yo_bray/ulits/constant.dart';
import 'package:yo_bray/view/job/create_job_page.dart';
import 'package:yo_bray/view/product/create_product_page.dart';
import 'package:yo_bray/widgets/drawer_widget.dart';

class AddNewPage extends StatefulWidget {
  const AddNewPage({Key? key}) : super(key: key);

  @override
  _AddNewPageState createState() => _AddNewPageState();
}

class _AddNewPageState extends State<AddNewPage>
    with SingleTickerProviderStateMixin {
  String _title = 'Products';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      _title = _tabController.index == 0 ? 'Products' : 'Job';
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        drawer: DrawerWidget(),
        appBar: AppBar(
          leadingWidth: leadingWidth,
          title: Text(_title),
          // actions: [
          //   IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          // ],
        ),
        body: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              height: 45,
              child: TabBar(
                controller: _tabController,
                labelColor: kPrimary,
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(icon: Text("Product")),
                  Tab(icon: Text("Job")),
                ],
              ),
            ),

            // create widgets for each tab bar here
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // first tab bar view widget
                  CreateProductPage(),

                  // second tab bar viiew widget
                  CreateJobPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
