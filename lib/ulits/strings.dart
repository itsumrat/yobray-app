import 'dart:io';

class Strings {
  Strings._();

  static const String darkmode = "darkmode";
  static const String profile = "profile";
  static const String lowStockList = "lowStockList";
  static const String score = "score";
  static const String token = "token";
  static const String stock = 'stock';
  static const String defaultLowStock = "defaultLowStock";

  static const String privacyUrl = "https://yobray.com/terms.php";

  static String get appId => "com.yobrayapp.app";
  static String appUrl = Platform.isAndroid
      ? "https://play.google.com/store/apps/details?id=$appId"
      : "https://apps.apple.com/il/app/yobray/id1555987445";
  static String expenseShare =
      "I am maintaining my business expense in yobray. Try $appUrl";
  static String jobShare =
      "I am maintaining job activities in yobray. Try $appUrl";
  static String productShare =
      "I have just sold products by yobray. Try $appUrl";
}
