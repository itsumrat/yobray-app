import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yo_bray/controller/auth_controller.dart';
import 'package:yo_bray/ulits/constant.dart';
import 'package:yo_bray/widgets/input_decorator.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final emailText = TextEditingController();
  final bodyText = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Contact Us'),
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

  String? subJect;
  final options = ['SUBMIT PROBLEM', 'SUBMIT FEEDBACK'];
  Widget formWidget() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            validator: (String? value) {
              if (value == null || value.isEmpty) return "Can't empty";
              if (!GetUtils.isEmail(value)) return "Enter correct email";
              return null;
            },
            controller: emailText,
            keyboardType: TextInputType.emailAddress,
            decoration: CommonDecorator.inputDecorator('Email'),
          ),
          SizedBox(height: 16),
          DropdownButtonFormField(
            items: options.map((String item) {
              return new DropdownMenuItem(value: item, child: Text("$item"));
            }).toList(),
            validator: (String? id) {
              if (id == null) return 'Select subject';
              return null;
            },
            onChanged: (newValue) {
              subJect = newValue as String;
            },
            value: subJect,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
              filled: true,
              border: InputBorder.none,
              fillColor: Colors.grey[200],
              hintText: 'Select Subject',
            ),
          ),
          SizedBox(height: 16),
          TextFormField(
            validator: (String? value) {
              if (value == null || value.isEmpty) return "Can't empty";
              return null;
            },
            keyboardType: TextInputType.multiline,
            maxLines: null,
            minLines: 5,
            controller: bodyText,
            decoration: CommonDecorator.inputDecorator('Body'),
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

  final controller = Get.find<AuthController>();

  Future<void> _submit() async {
    final formState = _formKey.currentState;
    formState!.save();
    if (!formState.validate()) return;
    FocusScope.of(context).requestFocus(FocusNode());

    final body = <String, dynamic>{
      'email': emailText.text,
      'subject': subJect ?? '',
      'body': bodyText.text,
    };
    await controller.contactUs(body);
  }
}
