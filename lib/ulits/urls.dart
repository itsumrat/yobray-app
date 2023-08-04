class Urls {
  Urls._();

  static String rootUrl = 'https://api.yobray.com';
  static String baseUrl = 'https://api.yobray.com/public/api';
  static String profileImage = 'https://api.yobray.com/image/profile/';
  static String productImage =
      'https://api.yobray.com/public/image/user_upload/';
  static String feedbackFile = 'https://api.yobray.com/public/image/feedback/';
  static String signIn = baseUrl + '/login';
  static String socialAUth = baseUrl + '/socialLogin';
  static String signUp = baseUrl + '/userRegister';
  static String passwordChange = baseUrl + '/password/update';
  static String jobs = baseUrl + '/jobs';
  static String product = baseUrl + '/products';
  static String expenses = baseUrl + '/expenses';
  static String jobFeedback = baseUrl + '/feedbacks';
  static String expenseName = baseUrl + '/expense_name';
  static String sells = baseUrl + '/sells';
  static String returnSells = baseUrl + '/sell_return';
  static String contactUs = baseUrl + '/contactUs';
  static String doPaindUser = baseUrl + '/paidUser';
  static String activityJob = baseUrl + '/activities?page=1&type=job&limit=500';
  static String activityProduct =
      baseUrl + '/activities?page=1&type=Product_sale&limit=500';
  static String activityExpenses =
      baseUrl + '/activities?page=1&type=expense&limit=500';
  static String activitySellProduct =
      baseUrl + '/sells?page=1&type=Products&limit=500';
  static String activityDoneJobs =
      baseUrl + '/jobs?page=1&status=done&limit=500';
  static String activityExpenseReturn = baseUrl + '/activity_expenses';
  static String deleteExpensesProduct = baseUrl + '/soft_delete_expense';
  static String deleteProduct = baseUrl + '/soft_delete_product/';
  static String saveJOb = baseUrl + '/save_job/';
  static String deleteSaveJOb = baseUrl + '/delete_saved_job/';
  static String softDeleteJOb = baseUrl + '/soft_delete_job/';
  static String restock = baseUrl + '/restock_product';
  static String feedbackDelete = baseUrl + "/feedbacks/";
  static String feedImageDelete = baseUrl + "/delete_feedback_image";
  static String feedVideoDelete = baseUrl + "/delete_feedback_video";
}
