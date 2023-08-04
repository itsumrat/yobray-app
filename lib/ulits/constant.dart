//

import 'package:flutter/material.dart';
import 'package:yo_bray/controller/login_shared_preference.dart';

final double leadingWidth = 35.0, kDroapDownHeight = 45;
String get kToken => LoginSharedPreference.getAccessToken();
String get kProfile => LoginSharedPreference.getLoginInformation();
Color kPrimary = Color(0xff768afb);
