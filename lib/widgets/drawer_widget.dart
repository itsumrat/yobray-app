import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yo_bray/config/app_routes.dart';
import 'package:yo_bray/controller/auth_controller.dart';
import 'package:yo_bray/ulits/constant.dart';
import 'package:yo_bray/ulits/strings.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yo_bray/ulits/utils.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final userinfo = authController.userinfo.value;

    return Drawer(
      child: Container(
        color: kPrimary,
        child: ListView(
          children: [
            SizedBox(height: 4),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Get.toNamed(AppRoutes.profile_view_page);
              },
              child: UserAccountsDrawerHeader(
                accountName: Text("${userinfo.name ?? ''}"),
                accountEmail: Text("${userinfo.email ?? ''}"),
                currentAccountPicture: SizedBox(
                  height: 100,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CachedNetworkImage(
                      imageUrl:
                          Utils.getProfilePicture(userinfo.profilePic ?? ''),
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => SvgPicture.asset(
                          'assets/adduser.svg',
                          fit: BoxFit.cover),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Divider(color: Colors.white),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Get.toNamed(AppRoutes.profile_view_page);
              },
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.account_circle_outlined),
              ),
              title: Text(
                'Profile',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Get.toNamed(AppRoutes.setting_page);
              },
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.settings),
              ),
              title: Text(
                'Settings',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Get.toNamed(AppRoutes.subscription_page);
              },
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: FaIcon(FontAwesomeIcons.paypal),
              ),
              title: Text(
                'Plus',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Get.toNamed(AppRoutes.contact_us_page);
              },
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.contact_support_rounded),
              ),
              title: Text('Contact Us', style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Share.share(Strings.appUrl);
              },
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.share_outlined),
              ),
              title: Text(
                'Invite Friend',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              onTap: () async {
                Navigator.pop(context);

                if (await canLaunch(Strings.privacyUrl))
                  launch(Strings.privacyUrl);
              },
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.privacy_tip),
              ),
              title: Text('Terms & Privacy Policy',
                  style: TextStyle(color: Colors.white)),
            ),
            if (!authController.isLogged)
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Get.toNamed(AppRoutes.signin_page);
                },
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.logout_outlined),
                ),
                title: Text(
                  'Log In',
                  style: TextStyle(color: Colors.white),
                ),
              )
            else
              ListTile(
                onTap: () async {
                  Navigator.pop(context);
                  await authController.logout();
                  Get.offAllNamed(AppRoutes.signin_page);
                },
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.logout_outlined),
                ),
                title: Text(
                  'Log Out',
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
