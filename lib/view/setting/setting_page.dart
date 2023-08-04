import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yo_bray/config/app_routes.dart';
import 'package:yo_bray/controller/login_shared_preference.dart';
import 'package:yo_bray/ulits/constant.dart';
import 'package:yo_bray/view/home/controller/home_controller.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  int lowStock = LoginSharedPreference.getLowStock();
  final controller = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    lowStock = LoginSharedPreference.getLowStock();

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(title: Text('Settings'), leadingWidth: leadingWidth),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          Card(
            child: ListTile(
              onTap: () => Get.toNamed(AppRoutes.expanses_list_page),
              title: Text("Expense list"),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () => _setLowStock(),
              title: Text("Set low stock for all products  $lowStock"),
              trailing: Icon(Icons.add),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () => _setReferalCode(),
              title: Text("Add Referral Code"),
              trailing: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  Future _setLowStock() {
    final _titleController = TextEditingController();
    _titleController.text = '$lowStock';
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: new Text("Set Low Stock"),
            content: new TextFormField(
              maxLines: 1,
              controller: _titleController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter stock number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              new TextButton(
                child: new Text("Set"),
                onPressed: () async {
                  if (_titleController.text.isNotEmpty) {
                    int value = int.tryParse(_titleController.text) ?? 0;
                    await LoginSharedPreference.setLowStock(value);
                    SharedPreferences _prfs = await SharedPreferences.getInstance();
                    _prfs.setInt("setLowStockForAll", value);
                    setState(() {});
                  }
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  Future _setReferalCode() {
    final codeController = TextEditingController();

    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: new Text("Add Referral Code"),
            content: new TextFormField(
              maxLines: 1,
              controller: codeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Referral Code',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              new TextButton(
                child: new Text("Add"),
                onPressed: () async {
                  Navigator.pop(context);
                  await .1.delay();
                  if (codeController.text.isNotEmpty) {
                    controller.referdBy(codeController.text);
                  }
                },
              )
            ],
          );
        });
  }
}
