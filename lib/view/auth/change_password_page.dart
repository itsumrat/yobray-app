import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yo_bray/controller/auth_controller.dart';
import 'package:yo_bray/ulits/constant.dart';
import 'package:yo_bray/widgets/input_decorator.dart';

import 'package:yo_bray/config/extension.dart';
import 'package:yo_bray/widgets/toast.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final AuthController authController = Get.find();

  final currentPassword = TextEditingController();
  final passController = TextEditingController();
  final confirmPasController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Change Password'),
          centerTitle: true,
          leadingWidth: leadingWidth),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          SizedBox(height: 20),
          formWidget(),
          SizedBox(height: 20),
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
              if (value == null || value.isEmpty)
                return 'Enter Current Password';
              if (!value.isValidPassword())
                return 'Must be at least 8 characters';
              return null;
            },
            controller: currentPassword,
            obscureText: true,
            decoration: CommonDecorator.inputDecorator('Current Password')
                .copyWith(labelText: 'Current Password'),
          ),
          SizedBox(height: 16),
          TextFormField(
            validator: (String? value) {
              if (value == null || value.isEmpty) return 'Enter password';
              if (!value.isValidPassword())
                return 'Must be at least 8 characters';
              return null;
            },
            controller: passController,
            obscureText: true,
            decoration: CommonDecorator.inputDecorator('Password')
                .copyWith(labelText: 'Password'),
          ),
          SizedBox(height: 16),
          TextFormField(
            validator: (String? value) {
              if (value == null || value.isEmpty)
                return 'Enter confirm password';
              if (value != passController.text)
                return 'Password dose not match';
              return null;
            },
            controller: confirmPasController,
            obscureText: true,
            decoration: CommonDecorator.inputDecorator('Confirm Password')
                .copyWith(labelText: 'Confirm Password'),
          ),
          SizedBox(height: 16),
          TextButton(
            onPressed: _submit,
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Theme.of(context).primaryColor),
            ),
            child: Text("Submit", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final formState = _formKey.currentState;
    formState!.save();

    if (!formState.validate()) return;
    FocusScope.of(context).requestFocus(FocusNode());

    myShowDialog();
    bool isOk = await authController.changePassword(
      passController.text.trim(),
      confirmPasController.text.trim(),
      currentPassword.text.trim(),
    );
    if (Get.isDialogOpen!) Get.back();

    if (isOk) Get.back();
  }
}
