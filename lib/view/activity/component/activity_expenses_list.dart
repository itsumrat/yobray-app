
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';
import 'package:yo_bray/data/model/activity_expense_model.dart';
import 'package:yo_bray/ulits/strings.dart';
import 'package:yo_bray/ulits/urls.dart';
import 'package:yo_bray/ulits/utils.dart';
import 'package:yo_bray/view/activity/activity_controller.dart';
import 'package:yo_bray/view/home/controller/home_controller.dart';
import 'package:yo_bray/widgets/toast.dart';

class ActivitExpensesList extends StatelessWidget {
  ActivitExpensesList({Key? key}) : super(key: key);

  final controller = Get.find<ActivityController>();
  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => controller.fetchActivityExpense(),
      child: Obx(() => controller.expensesLoading.value
          ? Center(child: CircularProgressIndicator())
          : _buildLoadedWidget()),
    );
  }

  Widget _buildLoadedWidget() {
    if (controller.expenseList.length == 0)
      return ListView(
        children: [
          SizedBox(height: 20),
          Center(child: Text('No Item')),
        ],
      );

    return ListView.builder(
      padding: EdgeInsets.all(8),
      itemCount: controller.expenseList.length,
      itemBuilder: (BuildContext ctx, int index) =>
          _expenseCard(controller.expenseList[index]),
    );
  }

  Widget _expenseCard(Datum item) {
    //  print(jsonData);
    // print(item.toJson());
    // print(item.toJson().toString());
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      '${Urls.productImage}${item.description!.productFeature ?? ''}',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return Center(child: Text("Image not found"));
                      },
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${item.description!.productTitle ?? ''}',
                        style: TextStyle(color: Colors.blue)),
                    SizedBox(height: 4),
                    Text('${item.description!.expenseName ?? ''}'),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        SizedBox(width: 2),
                        Image.asset("assets/currency.png",
                            height: 14, width: 14),
                        SizedBox(width: 4),
                        Text(Utils.formatPrice(
                            _getPrice('${item.description!.amount}'))),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                actionIcon(
                  child: Icon(Icons.delete),
                  text: 'Delete',
                  onTap: () async {
                    myShowDialog();
                    await controller.deleteExpenses(expenseId: item.id!);
                    if (Get.isDialogOpen!) Get.back();
                  },
                ),
                actionIcon(
                  child: Icon(Icons.undo_outlined),
                  text: 'Undo',
                  onTap: () async {
                    myShowDialog();
                    await controller.returnExpense(item.id!);
                    if (Get.isDialogOpen!) Get.back();
                  },
                ),
                actionIcon(
                  child: Icon(Icons.share),
                  text: 'Share',
                  onTap: () {
                    Share.share(Strings.expenseShare);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _getPrice(String? salePrice) {
    try {
      if (salePrice == null) return 0;
      return double.parse(salePrice);
    } catch (e) {
      print('cant convert to double');
    }
    return 0;
  }

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
}
