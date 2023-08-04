import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yo_bray/data/model/expenses_response.dart';
import 'package:yo_bray/ulits/constant.dart';
import 'package:yo_bray/view/home/controller/home_controller.dart';
import 'package:yo_bray/widgets/input_decorator.dart';

class EditExpensesPage extends StatefulWidget {
  const EditExpensesPage({Key? key}) : super(key: key);

  @override
  _EditExpensesPageState createState() => _EditExpensesPageState();
}

class _EditExpensesPageState extends State<EditExpensesPage> {
  final HomeController controller = Get.find();
  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  ExpensType item = Get.arguments as ExpensType;
  @override
  void initState() {
    super.initState();
    nameController.text = item.name ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Expense'), leadingWidth: leadingWidth),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          SizedBox(height: 30),
          formWidget(),
        ],
      ),
    );
  }

  Widget formWidget() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            validator: (String? value) {
              if (value == null || value.isEmpty) return 'Enter expense name';
              return null;
            },
            controller: nameController,
            keyboardType: TextInputType.name,
            decoration: CommonDecorator.inputDecorator('Expenses Name')
                .copyWith(labelText: 'Expenses Name'),
          ),
          SizedBox(height: 16),
          TextButton(
            onPressed: () {
              final formState = _formKey.currentState;
              formState!.save();
              if (formState.validate()) {
                controller
                    .updateExpenses({'name': nameController.text}, item.id!);
              }
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Theme.of(context).primaryColor),
            ),
            child: Text("Update", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
