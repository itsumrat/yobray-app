import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:yo_bray/config/app_routes.dart';
import 'package:yo_bray/controller/login_shared_preference.dart';
import 'package:yo_bray/data/model/user_info_model.dart';
import 'package:yo_bray/data/service/auth_service/auth_service.dart';
import 'package:yo_bray/ulits/constant.dart';
import 'package:yo_bray/ulits/urls.dart';
import 'package:yo_bray/widgets/toast.dart';

class AuthController extends GetxController {
  final _authService = AuthService();

  bool get isLogged => kToken.isNotEmpty;
  bool isUserPaid() {
    try {
      final _now = DateTime.now();
      final expiredDate = DateTime.parse(userinfo.value.exprieredDate!);
      return _now.isBefore(expiredDate);
    } catch (e) {}
    return false;
  }

  var userinfo = Userinfo().obs;

  var getprofileLoagin = true.obs;

  @override
  void onReady() {
    super.onReady();

    final info = kProfile;
    if (info.isNotEmpty) {
      final userDecoder = Userinfo.fromJson(json.decode(info));
      userinfo(userDecoder);
    }
    // ever(_token, fireRoute);
    // ever(userinfo, (_) {
    //   appData.write(Strings.user, json.encode(userinfo.toJson()));
    // });
  }

  Future<void> logout() async {
    userinfo(null);
    LoginSharedPreference.logout();
  }

  Future<bool> signIn(String email, String password) async {
    try {
      final response = await _authService.signIn(email, password);
      print(response.data);
      final data = response.data ?? '';
      print(response.statusCode);

      if (data.contains('token')) {
        final user = userInfoModelFromJson(response.data);
        await LoginSharedPreference.setAccessToken(user.token);
        print('.............................');
        print(kToken);
        LoginSharedPreference.setLoginInformation(user.userinfo);
        userinfo(user.userinfo);
        return true;
      } else if (data.contains('Credentials not match')) {
        errorToast('Credentials not match');
      } else {
        errorToast('Some unknown error');
      }

      return false;
    } catch (e) {
      errorToast('Some unknown error');
      print(e.toString());
    }
    return false;
  }

  Future<bool> socialAuth(Map body) async {
    try {
      final response = await _authService.socialAuth(body);
      print('i am  ');
      print(response.data);

      final data = response.data ?? '';
      print(response.statusCode);

      if (response.statusCode == 200 && data.contains('token')) {
        final user = userInfoModelFromJson(response.data);
        print('i am her $user');
        await LoginSharedPreference.setAccessToken(user.token);
        print('.............................');
        print(kToken);
        LoginSharedPreference.setLoginInformation(user.userinfo);
        userinfo(user.userinfo);
        return true;
      } else if (data.contains('Credentials not match')) {
        errorToast('Credentials not match');
      } else {
        errorToast('Some unknown error');
      }

      return true;
    } catch (e) {
      errorToast('Some unknown error');
      print(e.toString());
      print('dead');
    }
    return false;
  }

  Future<bool> signUp(String name, String email, String password) async {
    final response = await _authService.signUp(name, email, password);
    print(response.data);
    final data = response.data ?? '';
    print(response.statusCode);

    if (data.contains('The email has already been taken.')) {
      errorToast('The email has already been taken');
    } else if (data.contains('Successful')) {
      // successToast('Check your mail for verification code');
    } else {
      errorToast('Some unknown error');
    }

    return data.contains('Successful');
  }

  Future<bool> changePassword(
      String pass, String confirmPass, String currentPassword) async {
    final header = {
      'Authorization': 'Bearer $kToken',
      'Content-Type': 'application/json'
    };
    try {
      final response =
          await _authService.changePassword(pass, currentPassword, header);

      print(response.data);
      print(response.data.runtimeType);
      final string = response.data ?? '';

      if (string.contains('Password Change Successful')) {
        successToast('Password change successful');
        return true;
      } else {
        errorToast('Some unknown error');
      }
    } catch (e) {
      errorToast('Some unknown error');
    }
    return false;
  }

  Future<void> getProfile() async {
    final header = {
      'Authorization': 'Bearer $kToken',
      'Content-Type': 'application/json'
    };
    try {
      getprofileLoagin(true);

      final response =
          await _authService.getProfile(header, userinfo.value.id!);

      print(response.data);
      print(response.data.runtimeType);
      final string = response.data ?? '';
      if (string.contains('id')) {
        final data = json.decode(response.data);
        final _user = Userinfo.fromJson(data);
        print(_user.toJson());
        userinfo(_user);
        LoginSharedPreference.setLoginInformation(_user);
      }
    } catch (e) {
      print(e.toString());
    }
    getprofileLoagin(false);
  }

  Future contactUs(Map<String, dynamic> body) async {
    try {
      final header = {
        'Authorization': 'Bearer $kToken',
        'Content-Type': 'application/json'
      };
      myShowDialog();
      final response = await _authService.contactUs(header, body);
      if (Get.isDialogOpen!) Get.back();

      print(response.data);
      print(response.data.runtimeType);
      final string = response.data ?? '';
      if (string.contains('success')) {
        successToast('Thank You For Your Response');
        Get.back();
      } else {
        errorToast('Some error');
      }
    } catch (e) {
      print(e.toString());
      errorToast('Some error');
    }
    if (Get.isDialogOpen!) Get.back();
  }

  Future doPaidUser() async {
    try {
      final header = {
        'Authorization': 'Bearer $kToken',
        'Content-Type': 'application/json'
      };
      myShowDialog();
      final response = await _authService.doPaidUser(header, {});
      if (Get.isDialogOpen!) Get.back();

      print(response.data);
      print(response.data.runtimeType);
      final string = response.data ?? '';
      if (string.toLowerCase().contains('success')) {
        successToast('Thank You For Subscription');
        Get.offNamed(AppRoutes.profile_view_page);
      } else {
        errorToast('Some error, Please contact our support team');
      }
    } catch (e) {
      print(e.toString());
      errorToast('Some error, Please contact our support team');
    }
    if (Get.isDialogOpen!) Get.back();
  }

  Future deleteAccount() async {
    var response = await http.get(
      Uri.parse(
          Urls.baseUrl + "/user/${userinfo.value.id}/delete/allactivities"),
      headers: {
        'Authorization': 'Bearer $kToken',
        'Content-Type': 'application/json'
      },
    );

    print("response status: ${response.statusCode}");
    print("response data: ${response.body}");
    print("response Url: ${response.request!.url.path}");
    return;
  }
}
