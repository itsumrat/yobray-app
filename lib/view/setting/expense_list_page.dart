import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yo_bray/config/app_routes.dart';
import 'package:yo_bray/data/model/expenses_response.dart';
import 'package:yo_bray/ulits/constant.dart';
import 'package:yo_bray/view/home/controller/home_controller.dart';

class ExpansesListPage extends StatefulWidget {
  const ExpansesListPage({Key? key}) : super(key: key);

  @override
  _ExpansesListPageState createState() => _ExpansesListPageState();
}

class _ExpansesListPageState extends State<ExpansesListPage> {
  final controller = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    controller.fetchExpense();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(title: Text('Expanses List'), leadingWidth: leadingWidth),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchExpense(),
        child: Obx(() => controller.expensesLoading.value
            ? Center(child: CircularProgressIndicator())
            : _buildLoadedExpense()),
      ),
    );
  }

  Widget _buildLoadedExpense() {
    return ListView(
      padding: const EdgeInsets.all(4),
      children: [
        _buildListTitle(),
        SizedBox(height: 8),
        if (controller.expensesList.length == 0)
          Center(child: Text('No Item Found'))
        else
          ...controller.expensesList
              .map((element) => singleItem(element))
              .toList()
      ],
    );
  }

  Widget _buildListTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${controller.expensesList.length} item'),
          InkWell(
            onTap: () => Get.toNamed(AppRoutes.create_expense_page),
            child: Text('+ Create New', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  Widget singleItem(ExpensType item) {
    return Card(
      child: ListTile(
        title: Text("${item.name}"),
        trailing: PopupMenuButton<int>(
          onSelected: (int value) async {
            if (3 == value) {
              final backResult = await _showMyDialogDelete();
              if (backResult != null && backResult)
                controller.deleteExpenses(item.id!);
            }
            if (2 == value) {
              final backResult = await _showMyDialog();
              if (backResult != null && backResult)
                controller.removeExpenses(item.id!);
            } else
              Get.toNamed(AppRoutes.edit_expense_page, arguments: item);
          },
          child: const Icon(Icons.more_vert),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
            PopupMenuItem<int>(
                value: 1, height: kDroapDownHeight, child: const Text('Edit')),
            // PopupMenuItem<int>(
            //     value: 2,
            //     height: kDroapDownHeight,
            //     child: const Text('Remove')),
            PopupMenuItem<int>(
                value: 3,
                height: kDroapDownHeight,
                child: const Text('Delete')),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showMyDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove this'),
          content: Text('Do you want to really remove this'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Remove'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showMyDialogDelete() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete this'),
          content: Text('Do you want to really delete this'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
