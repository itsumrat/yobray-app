import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yo_bray/controller/auth_controller.dart';
import 'package:yo_bray/data/model/user_info_model.dart';
import 'package:yo_bray/ulits/constant.dart';
import 'package:yo_bray/ulits/urls.dart';
import 'package:yo_bray/ulits/utils.dart';
import 'package:yo_bray/widgets/input_decorator.dart';
import 'package:yo_bray/widgets/toast.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({Key? key}) : super(key: key);

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final authController = Get.find<AuthController>();

  final email = TextEditingController();
  final name = TextEditingController();
  final userId = TextEditingController();
  final refardBy = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? image;
  late Userinfo userinfo;

  @override
  void initState() {
    super.initState();

    userinfo = authController.userinfo.value;
    email.text = userinfo.email ?? '';
    name.text = userinfo.name ?? '';
    userId.text = userinfo.uniqueId ?? '';
    refardBy.text = userinfo.referredBy ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Edit profile'),
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
          _imageView(),
          // SizedBox(height: 12),
          // TextFormField(
          //   validator: (String? value) {
          //     if (value == null || value.isEmpty) return 'Enter your user id';
          //     return null;
          //   },
          //   controller: userId,
          //   keyboardType: TextInputType.name,
          //   decoration: CommonDecorator.inputDecorator('User Id')
          //       .copyWith(labelText: 'User Id'),
          // ),
          SizedBox(height: 12),
          TextFormField(
            validator: (String? value) {
              if (value == null || value.isEmpty)
                return 'Enter your business  name';
              return null;
            },
            controller: name,
            keyboardType: TextInputType.name,
            decoration: CommonDecorator.inputDecorator('Business Name')
                .copyWith(labelText: 'Business Name'),
          ),
          SizedBox(height: 16),
          TextFormField(
            validator: (String? value) {
              if (value == null || value.isEmpty) return 'Enter Email';
              return null;
            },
            controller: email,
            keyboardType: TextInputType.emailAddress,
            decoration: CommonDecorator.inputDecorator('Email')
                .copyWith(labelText: 'Email'),
          ),
          SizedBox(height: 16),
          // TextFormField(
          //   controller: refardBy,
          //   decoration: CommonDecorator.inputDecorator('referred by')
          //       .copyWith(labelText: 'referred by'),
          // ),
          // SizedBox(height: 16),
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

  Widget _imageView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 150,
          width: 150,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(75),
            child: InkWell(
              onTap: () async {
                final imageSource = await Utils.showImageSource(context);
                if (imageSource != null) {
                  final result = await Utils.pickFile(imageSource);
                  if (result != null) {
                    image = result;
                    setState(() {});
                  }
                }
              },
              child: image != null
                  ? Image.file(image!, fit: BoxFit.cover)
                  : CachedNetworkImage(
                      imageUrl:
                          Utils.getProfilePicture(userinfo.profilePic ?? ''),
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) {
                        return SvgPicture.asset('assets/adduser.svg',
                            fit: BoxFit.cover);
                      },
                    ),
            ),
          ),
        ),
      ],
    );
  }

  dio.Dio https = dio.Dio();
  Future<void> _submit() async {
    final formState = _formKey.currentState;
    formState!.save();

    if (!formState.validate()) return;
    FocusScope.of(context).requestFocus(FocusNode());

    myShowDialog();

    final header = {
      'Authorization': 'Bearer $kToken',
      'Content-Type': 'application/json'
    };

    if (image != null) {
      final filename = image!.path.split('/').last;
      final type = filename.split('.').last;
      List<int> img = image!.readAsBytesSync();
      dio.MultipartFile multipartFile = dio.MultipartFile.fromBytes(
        img,
        filename: image!.path.split('/').last,
        contentType: MediaType('image', type),
      );

      dio.FormData formData = dio.FormData.fromMap(
        {
          'name': name.text.trim(),
          'referred_by': refardBy.text.trim(),
          'unique_id': userId.text,
          if (userinfo.email != email.text) 'email': email.text.trim(),
          'profile_pic': multipartFile,
        },
      );

      try {
        print(formData.files);
        var response = await https.post(
          Urls.baseUrl + '/user/${userinfo.id}/update',
          data: formData,
          options: dio.Options(
            headers: header,
            method: 'post',
            contentType: 'multipart/form-data;charset=UTF-8',
            responseType: dio.ResponseType.json,
          ),
        );
        if (Get.isDialogOpen!) Get.back();

        final String data = response.data ?? '';
        if (data.contains('Update Successful')) {
          userinfo.name = name.text;
          userinfo.email = email.text;
          userinfo.referredBy = refardBy.text;
          authController.userinfo(userinfo);
          authController.getProfile();
          Get.back();
        }
      } catch (e) {
        print(e.toString());
      }
    } else {
      dio.FormData formData = dio.FormData.fromMap(
        {
          'name': name.text.trim(),
          if (userinfo.email != email.text) 'email': email.text.trim(),
          'referred_by': refardBy.text.trim(),
          'unique_id': userId.text,
        },
      );

      try {
        print(formData.files);
        var response = await https.post(
          Urls.baseUrl + '/user/${userinfo.id}/update',
          data: formData,
          options: dio.Options(
            headers: header,
            method: 'post',
            contentType: 'multipart/form-data;charset=UTF-8',
            responseType: dio.ResponseType.json,
          ),
        );
        if (Get.isDialogOpen!) Get.back();

        final String data = response.data ?? '';
        print(data);
        if (data.contains('Update Successful')) {
          userinfo.name = name.text;
          userinfo.email = email.text;
          userinfo.referredBy = refardBy.text;
          authController.userinfo(userinfo);
          authController.getProfile();
          Get.back();
        }
      } catch (e) {
        print(e.toString());
      }
    }

    if (Get.isDialogOpen!) Get.back();
  }
}
