import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yo_bray/data/model/jobs_response.dart';
import 'package:yo_bray/ulits/utils.dart';
import 'package:yo_bray/view/home/controller/home_controller.dart';
import 'package:yo_bray/widgets/input_decorator.dart';
import 'package:yo_bray/widgets/toast.dart';

class CreateJobPage extends StatefulWidget {
  CreateJobPage({Key? key}) : super(key: key);

  @override
  _CreateJobPageState createState() => _CreateJobPageState();
}

class _CreateJobPageState extends State<CreateJobPage> {
  final HomeController controller = Get.find();

  File? file;

  final _formKey = GlobalKey<FormState>();

  final _jobTitleController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  late String startDate, endDate;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(8),
        children: [
          SizedBox(height: 12),
          TextFormField(
            validator: (String? s) {
              if (s == null || s.isEmpty) return 'Not Empty';
              return null;
            },
            controller: _jobTitleController,
            keyboardType: TextInputType.name,
            decoration: CommonDecorator.inputDecorator('Job title'),
          ),
          SizedBox(height: 12),
          TextFormField(
            onTap: () async {
              FocusScope.of(context).requestFocus(new FocusNode());
              final date = await _showDatePicker(context);
              if (date != null) {
                _startDateController.text = Utils.formatDate(date.toString());
                startDate = date.toString();
                setState(() {});
              }
            },
            validator: (String? s) {
              if (s == null || s.isEmpty) return 'Not Empty';
              return null;
            },
            controller: _startDateController,
            keyboardType: TextInputType.name,
            decoration: CommonDecorator.inputDecorator('Start Date'),
          ),
          SizedBox(height: 12),
          TextFormField(
            onTap: () async {
              FocusScope.of(context).requestFocus(new FocusNode());
              final date = await _showDatePicker(context);
              if (date != null) {
                _endDateController.text = Utils.formatDate(date.toString());
                endDate = date.toString();
                setState(() {});
              }
            },
            validator: (String? s) {
              if (s == null || s.isEmpty) return 'Not Empty';
              return null;
            },
            controller: _endDateController,
            keyboardType: TextInputType.name,
            decoration: CommonDecorator.inputDecorator('End Date'),
          ),
          SizedBox(height: 12),
          // DateTimePicker(
          //   // decoration: CommonDecorator.inputDecorator('Start Date'),
          //   type: DateTimePickerType.dateTime,
          //   dateMask: 'MM/dd/yyyy hh:mm a',
          //   icon: Icon(Icons.event),
          //   controller: _startDateController,
          //   firstDate: DateTime(2015),
          //   lastDate: DateTime(2500),
          //   dateLabelText: 'Start Date',
          //   use24HourFormat: true,
          //   locale: Locale('en', 'US'),
          //   onChanged: (val) => setState(() => print(val)),
          //   validator: (val) {
          //     if (val != null && val.isEmpty) return 'Select Start Date';
          //     return null;
          //   },
          //   // onSaved: (val) => setState(() => _valueSaved1 = val ?? ''),
          // ),
          // SizedBox(height: 12),
          // DateTimePicker(
          //   // decoration: CommonDecorator.inputDecorator('End Date'),
          //   type: DateTimePickerType.dateTime,
          //   dateMask: 'MM/dd/yyyy hh:mm a',
          //   controller: _endDateController,
          //   //initialValue: _initialValue,
          //   firstDate: DateTime(2015),
          //   lastDate: DateTime(2500),
          //   icon: Icon(Icons.event),
          //   dateLabelText: 'End Date',
          //   use24HourFormat: true,
          //   locale: Locale('en', 'US'),
          //   // onChanged: (val) => setState(() => _valueChanged2 = val),
          //   validator: (val) {
          //     if (val != null && val.isEmpty) return 'Select End Date';
          //     return null;
          //   },
          //   // onSaved: (val) => setState(() => _valueSaved1 = val ?? ''),
          // ),

          SizedBox(height: 12),
          TextFormField(
            validator: (String? s) {
              if (s == null || s.isEmpty) return 'Not Empty';
              return null;
            },
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: CommonDecorator.inputDecorator('Price'),
          ),
          SizedBox(height: 12),
          TextFormField(
            controller: _descriptionController,
            minLines: 5,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            // validator: (String? s) {
            //   if (s == null || s.isEmpty) return 'Not Empty';
            //   return null;
            // },
            decoration: InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide.none),
              fillColor: Color(0xffF2F2F2),
              filled: true,
              hintText: 'Description',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
          SizedBox(height: 30),
          Row(
            children: [
              // ElevatedButton(
              //   onPressed: () => _submit('draft'),
              //   style: ButtonStyle(
              //     minimumSize: MaterialStateProperty.all(Size(100, 35)),
              //     backgroundColor:
              //         MaterialStateProperty.all(Theme.of(context).primaryColor),
              //   ),
              //   child: Text("Draft", style: TextStyle(color: Colors.white)),
              // ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _submit('active'),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(100, 35)),
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor),
                  ),
                  child: Text("Submit", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  DateTime? _chosenDateTime;

  Future<DateTime?> _showDatePicker(ctx) async {
    _chosenDateTime = DateTime.now();
    return showCupertinoModalPopup(
      context: ctx,
      builder: (_) => CupertinoActionSheet(
        actions: [
          SizedBox(
            height: 180,
            child: CupertinoDatePicker(
                initialDateTime: DateTime.now(),
                onDateTimeChanged: (val) {
                  setState(() {
                    _chosenDateTime = val;
                  });
                }),
          ),
        ],
        cancelButton: CupertinoButton(
          child: Text('OK'),
          onPressed: () => Get.back(result: _chosenDateTime),
        ),
      ),
    );
  }

  Future<void> _submit(String status) async {
    final formState = _formKey.currentState;
    formState!.save();
    if (!formState.validate()) return;

    //keyboard hide
    FocusScope.of(context).requestFocus(FocusNode());

    final job = JobModel(
        jobTitle: _jobTitleController.text,
        description: _descriptionController.text,
        budget: _priceController.text,
        startingTime: startDate,
        endingTime: endDate,
        status: status);
    print(job.toJson());

    myShowDialog();
    final isOk = await controller.createJob(job);
    if (Get.isDialogOpen!) Get.back();
    if (isOk) {
      _jobTitleController.clear();
      _descriptionController.clear();
      _priceController.clear();
      _startDateController.clear();
      _endDateController.clear();
      HomeController homeController = Get.find();
      homeController.persistentTabController().jumpToTab(0);
    }
  }
}
