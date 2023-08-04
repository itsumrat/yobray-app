import 'package:get/get.dart';
import 'package:yo_bray/view/auth/change_password_page.dart';
import 'package:yo_bray/view/account/profile_view_page.dart';
import 'package:yo_bray/view/add_new/add_new_page.dart';
import 'package:yo_bray/view/app_page.dart';
import 'package:yo_bray/view/auth/login_page.dart';
import 'package:yo_bray/view/account/profile_edit_page.dart';
import 'package:yo_bray/view/auth/signup_page.dart';
import 'package:yo_bray/view/account/contact_us_page.dart';
import 'package:yo_bray/view/expenses/create_expenses_page.dart';
import 'package:yo_bray/view/expenses/edit_expenses_page.dart';
import 'package:yo_bray/view/home/component/single_product_view_page.dart';
import 'package:yo_bray/view/job/add_feed_page.dart';
import 'package:yo_bray/view/job/copy_job_page.dart';
import 'package:yo_bray/view/job/create_job_page.dart';
import 'package:yo_bray/view/job/edit_job_page.dart';
import 'package:yo_bray/view/job/job_details_page.dart';
import 'package:yo_bray/view/product/create_product_page.dart';
import 'package:yo_bray/view/product/edit_product_page.dart';
import 'package:yo_bray/view/report/product_repot_page.dart';
import 'package:yo_bray/view/setting/expense_list_page.dart';
import 'package:yo_bray/view/setting/set_low_stock_page.dart';
import 'package:yo_bray/view/setting/setting_page.dart';
import 'package:yo_bray/view/setting/subscription_page.dart';

class AppRoutes {
  static const home_page = '/';
  static const add_feed_page = '/add_feed_page';

  //jobs
  static const create_new_job = '/create_new_job';
  static const edit_job_page = '/edit_job_page';
  static const copy_job_page = '/copy_job_page';
  static const job_details_page = '/job_details_page';

  //settings
  static const setting_page = '/setting_page';
  static const set_low_stock_page = '/set_low_stock_page';
  static const expanses_list_page = '/expanses_list_page';
  static const product_report_page = '/product_report_page';
  static const subscription_page = '/subscription_page';

  //auth
  static const signin_page = '/signin_page';
  static const signup_page = '/signup_page';
  static const profile_view_page = '/profile_view_page';
  static const edit_profile_page = '/edit_profile_page';
  static const change_password_page = '/change_password_page';

  //expenses
  static const create_expense_page = '/create_expense_page';
  static const edit_expense_page = '/edit_expense_page';
  static const contact_us_page = '/contact_us_page';

  //product
  static const create_product_page = '/create_product_page';
  static const edit_product_page = '/edit_product_page';
  static const single_product_view_page = '/single_product_view_page';

  //add new page
  static const add_new_page = '/add_new_page';

  //dev
  static const notfound_page = '/notfound';

  static final routes = [
    GetPage(name: home_page, page: () => AppPage()),
    GetPage(name: create_new_job, page: () => CreateJobPage()),
    GetPage(name: job_details_page, page: () => JobDetailsScreen()),
    GetPage(name: add_feed_page, page: () => AddFeedPage()),
    GetPage(name: setting_page, page: () => SettingPage()),
    GetPage(name: set_low_stock_page, page: () => SetLowStockPage()),
    GetPage(name: expanses_list_page, page: () => ExpansesListPage()),
    GetPage(name: product_report_page, page: () => ProductReportPage()),
    GetPage(name: signin_page, page: () => LoginPage()),
    GetPage(name: signup_page, page: () => SignupPage()),
    GetPage(name: edit_profile_page, page: () => ProfileEditPage()),
    GetPage(name: create_expense_page, page: () => CreateExpensesPage()),
    GetPage(name: create_product_page, page: () => CreateProductPage()),
    GetPage(name: add_new_page, page: () => AddNewPage()),
    GetPage(name: contact_us_page, page: () => ContactUsPage()),
    GetPage(name: profile_view_page, page: () => ProfileViewPage()),
    GetPage(name: change_password_page, page: () => ChangePasswordPage()),
    GetPage(name: subscription_page, page: () => SubscriptionPage()),
    GetPage(name: edit_product_page, page: () => EditProductPage()),
    GetPage(name: edit_job_page, page: () => EditJobPage()),
    GetPage(name: copy_job_page, page: () => CopyJobPage()),
    GetPage(name: edit_expense_page, page: () => EditExpensesPage()),
    GetPage(
        name: single_product_view_page, page: () => SingleProductViewPage()),
  ];
}
