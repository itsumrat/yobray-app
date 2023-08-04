import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yo_bray/config/app_routes.dart';
import 'package:yo_bray/controller/auth_controller.dart';
import 'package:yo_bray/data/model/user_info_model.dart';
import 'package:yo_bray/ulits/constant.dart';
import 'package:yo_bray/ulits/utils.dart';

class ProfileViewPage extends StatefulWidget {
  ProfileViewPage({Key? key}) : super(key: key);

  @override
  _ProfileViewPageState createState() => _ProfileViewPageState();
}

class _ProfileViewPageState extends State<ProfileViewPage> {
  final controller = Get.find<AuthController>();

  late Userinfo userinfo;
  final key = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    controller.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: AppBar(title: Text('Profile'), leadingWidth: leadingWidth),
      body: RefreshIndicator(
        onRefresh: () => controller.getProfile(),
        child: Obx(() {
          userinfo = controller.userinfo.value;
          return controller.getprofileLoagin.value
              ? Center(child: CircularProgressIndicator())
              : buildBody(context);
        }),
      ),
    );
  }

  ListView buildBody(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(8),
      children: [
        SizedBox(height: 30),
        _imageView(),
        // SizedBox(height: 10),
        // Container(
        //   color: Colors.white,
        //   padding: EdgeInsets.symmetric(vertical: 12),
        //   child: Center(child: Text('User Id: ${userinfo.uniqueId ?? ''}')),
        // ),
        SizedBox(height: 10),
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Center(child: Text('${userinfo.name ?? ''}')),
        ),
        SizedBox(height: 10),
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Center(child: Text('${userinfo.email ?? ''}')),
        ),
        SizedBox(height: 10),
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SelectableText(
                  'Your Referral Code: ${userinfo.referralCode ?? ''}'),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(
                      new ClipboardData(text: userinfo.referralCode ?? ''));
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                      content: new Text("Copied to Clipboard"),
                    ));
                },
                child: Icon(Icons.copy),
              )
            ],
          ),
        ),
        SizedBox(height: 20),
        TextButton(
          onPressed: () {
            Get.toNamed(AppRoutes.edit_profile_page);
          },
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Theme.of(context).primaryColor),
          ),
          child: Text("Edit Profile", style: TextStyle(color: Colors.white)),
        ),
        SizedBox(height: 10),
        if (!userinfo.profilePic!.startsWith('https://'))
          TextButton(
            onPressed: () {
              Get.toNamed(AppRoutes.change_password_page);
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Theme.of(context).primaryColor),
            ),
            child:
                Text("Change Password", style: TextStyle(color: Colors.white)),
          ),
        SizedBox(height: 10),
        TextButton(
          onPressed: () async {
            var result = await Get.defaultDialog(
              title: 'Are you sure?',
              content: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Do you want to delete your account?',
                  textAlign: TextAlign.center,
                ),
              ),
              titlePadding: EdgeInsets.all(20),
              actions: [
                RawMaterialButton(
                  child: Text('Cancel'),
                  onPressed: () => Get.back(result: false),
                ),
                RawMaterialButton(
                  child: Text('Confirm', style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    Get.back(result: true);
                  },
                ),
              ],
            );

            if (result == true) {
              await controller.deleteAccount();
              await controller.logout();
              Get.offAllNamed(AppRoutes.signin_page);
            }
          },
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Theme.of(context).colorScheme.error),
          ),
          child: Text("Delete Profile", style: TextStyle(color: Colors.white)),
        ),
        SizedBox(height: 20),
        if (controller.isUserPaid()) ...[
          Text("Plus Membership Status", style: TextStyle(fontSize: 25)),
          SizedBox(height: 4),
          Text(
              'Membership date:        ${Utils.formatDate(userinfo.renewDate)}'),
          Text(
              'Membership end date: ${Utils.formatDate(userinfo.exprieredDate)}'),
        ]
      ],
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
            child: CachedNetworkImage(
              imageUrl: Utils.getProfilePicture(userinfo.profilePic ?? ''),
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  SvgPicture.asset('assets/adduser.svg', fit: BoxFit.cover),
            ),
          ),
        ),
      ],
    );
  }
}
