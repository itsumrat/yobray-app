import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yo_bray/config/app_routes.dart';
import 'package:yo_bray/controller/auth_controller.dart';
import 'package:yo_bray/ulits/constant.dart';
import 'package:yo_bray/ulits/strings.dart';
import 'package:yo_bray/view/auth/social_auth.dart';
import 'package:yo_bray/widgets/input_decorator.dart';
import 'package:yo_bray/widgets/toast.dart';
import 'package:yo_bray/config/extension.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController authController = Get.find();

  final emailController = TextEditingController();
  final passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _socialAuthController = SocialAuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Login'), centerTitle: true, leadingWidth: leadingWidth),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          SizedBox(height: 30),
          _imageView(),
          SizedBox(height: 20),
          formWidget(),
          SizedBox(height: 20),
          TextButton(
            onPressed: () {
              Get.offNamed(AppRoutes.signup_page);
            },
            child: Text("Don't have account? SignUp",
                style: TextStyle(color: Colors.black)),
          ),
          Text.rich(
            TextSpan(
              text: 'By logging into Yobray, you agree to our\n',
              children: [
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      if (await canLaunch(Strings.privacyUrl))
                        launch(Strings.privacyUrl);
                    },
                  text: 'Terms of use',
                  style: TextStyle(
                      decoration: TextDecoration.underline, color: kPrimary),
                ),
                TextSpan(text: ' and '),
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      if (await canLaunch(Strings.privacyUrl))
                        launch(Strings.privacyUrl);
                    },
                  text: 'Privacy Policy.',
                  style: TextStyle(
                      decoration: TextDecoration.underline, color: kPrimary),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
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
              if (value == null || value.isEmpty) return 'Enter email';
              if (!GetUtils.isEmail(value)) return 'Enter valid email';
              return null;
            },
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: CommonDecorator.inputDecorator('Email')
                .copyWith(labelText: 'Email'),
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
          TextButton(
            onPressed: _submit,
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Theme.of(context).primaryColor),
            ),
            child: Text("Login", style: TextStyle(color: Colors.white)),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SignInButton.mini(
                buttonType: ButtonType.google,
                onPressed: () async {
                  final result = await _socialAuthController.signInWithGoogle();
                  print(result);
                  print("googleAut");
                  socialAuth(result);
                },
              ),
              SignInButton.mini(
                buttonType: ButtonType.facebookDark,
                onPressed: () async {
                  final result =
                      await _socialAuthController.signInWithFacebook();
                  print(result);

                  socialAuth(result);
                },
              ),
              if (Platform.isIOS)
                SignInButton.mini(
                  buttonType: ButtonType.apple,
                  onPressed: () async {
                    final result =
                        await _socialAuthController.signInWithApple();
                    print(result);

                    socialAuth(result);
                  },
                ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> socialAuth(Map? body) async {
    if (body == null) {
      errorToast('Social Authentication failed');
      return;
    }

    FocusScope.of(context).requestFocus(FocusNode());
    myShowDialog();
    bool isOk = await authController.socialAuth(body);
    if (Get.isDialogOpen!) Get.back();

    if (isOk) Get.offAndToNamed(AppRoutes.home_page);
  }

  Future<void> _submit() async {
    final formState = _formKey.currentState;
    formState!.save();
    if (formState.validate()) {
      FocusScope.of(context).requestFocus(FocusNode());
      myShowDialog();
      bool isOk = await authController.signIn(
          emailController.text.trim(), passController.text);
      if (Get.isDialogOpen!) Get.back();

      if (isOk) Get.offAndToNamed(AppRoutes.home_page);
    }
  }

  Widget _imageView() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Image.asset(
          'assets/logo.png',
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
