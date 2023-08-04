import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yo_bray/data/model/jobs_response.dart';
import 'package:yo_bray/ulits/utils.dart';
import 'package:yo_bray/view/home/controller/home_controller.dart';
import 'package:yo_bray/widgets/input_decorator.dart';
import 'package:yo_bray/widgets/toast.dart';

class CopyJobPage extends StatefulWidget {
  CopyJobPage({Key? key}) : super(key: key);

  @override
  _CopyJobPageState createState() => _CopyJobPageState();
}

class _CopyJobPageState extends State<CopyJobPage> {
  final HomeController controller = Get.find();

  final _formKey = GlobalKey<FormState>();

  final _jobTitleController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  late String startDate, endDate;

  JobModel job = Get.arguments as JobModel;

  @override
  void initState() {
    super.initState();

    _jobTitleController.text = job.jobTitle ?? '';

    _startDateController.text = Utils.formatDate(job.startingTime ?? '');
    _endDateController.text = Utils.formatDate(job.endingTime ?? '');

    _priceController.text = job.budget ?? '';
    _descriptionController.text = job.description ?? '';
    startDate = job.startingTime ?? '';
    endDate = job.endingTime ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(titleSpacing: 0, title: Text("Copy Job")),
      body: Form(
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
                final date = await _showDatePicker(context, startDate);
                print(date);
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
                final date = await _showDatePicker(context, endDate);

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _submit('draft'),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(100, 35)),
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor),
                  ),
                  child: Text("Draft", style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () => _submit('active'),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(100, 35)),
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor),
                  ),
                  child: Text("Submit", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  DateTime? _chosenDateTime;

  Future<DateTime?> _showDatePicker(ctx, String dateTime) async {
    _chosenDateTime = Utils.stringToDadteTime(dateTime);
    return showCupertinoModalPopup(
      context: ctx,
      builder: (_) => CupertinoActionSheet(
        actions: [
          SizedBox(
            height: 180,
            child: CupertinoDatePicker(
                initialDateTime: _chosenDateTime,
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
      Get.back();
    }
  }
}
