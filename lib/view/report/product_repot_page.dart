import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yo_bray/controller/auth_controller.dart';
import 'package:yo_bray/controller/report_controller.dart';
import 'package:yo_bray/data/model/product_response.dart';
import 'package:yo_bray/data/model/report_details_model.dart';
import 'package:yo_bray/ulits/constant.dart';
import 'package:yo_bray/ulits/utils.dart';
import 'package:yo_bray/view/report/search_product_color_size_page.dart';
import 'package:yo_bray/widgets/drawer_widget.dart';
import 'package:yo_bray/widgets/my_line_chart.dart';
import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ProductReportPage extends StatefulWidget {
  const ProductReportPage({Key? key}) : super(key: key);

  @override
  _ProductReportPageState createState() => _ProductReportPageState();
}

class _ProductReportPageState extends State<ProductReportPage> {
  final controller = Get.put(ReportController());
  final authController = Get.find<AuthController>();

  late ReportDetailsModel reportDetailsModel;
  bool loading = true;

  late String startDate, endDate;

  Map<String, dynamic>? _selectedProduct;
  DateTime get _now => DateTime.now();

  final idolReport = ReportDetailsModel(
      bestSell: '',
      lastSaleDate: '',
      profit: 0,
      sell: 0,
      expense: 0,
      totalMoney: 0,
      totalStock: 0,
      totalOutOfStock: 0,
      totalProduct: 0,
      sellReturn: 0,
      customSale: 0,
      expensesRrap: [],
      profitGrap: [],
      sellGrap: []);

  @override
  void initState() {
    super.initState();

    endDate = _now.toIso8601String().split('T').first;
    startDate =
        _now.subtract(Duration(days: 0)).toIso8601String().split('T').first;

    _loadData();
  }

  Future<void> _loadData() async {
    loading = true;

    _selectedProduct = null;
    reportDetailsModel = idolReport;

    changeState();
    final value = await controller.allProductReport(startDate, endDate);
    if (value != null)
      reportDetailsModel = value;
    else
      reportDetailsModel = idolReport;
    loading = false;
    changeState();
  }

  Future<void> _loadSingleProduct() async {
    loading = true;
    changeState();
    final getProduct = _selectedProduct!['color_size'] as ColorSizeModel;
    final value = await controller.allSingleProductReport(
        startDate, endDate, getProduct.productId!, getProduct.id!);
    if (value != null)
      reportDetailsModel = value;
    else
      reportDetailsModel = idolReport;
    loading = false;
    changeState();
  }

  void changeState() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text('Products Report'),
        leadingWidth: leadingWidth,
        actions: [
          IconButton(onPressed: () => _loadData(), icon: Icon(Icons.refresh)),
        ],
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    if (loading) return Center(child: CircularProgressIndicator());

    return ListView(
      padding: EdgeInsets.all(8),
      children: [
        graphSelectCard(reportDetailsModel.profit, reportDetailsModel.sell,
            reportDetailsModel.expense),
        _chartHeader(),
        MyLineChart(
          profitData: reportDetailsModel.profitGrap,
          sellData: reportDetailsModel.sellGrap,
          expenseData: reportDetailsModel.expensesRrap,
          isPaid: authController.isUserPaid(),
        ),
        _priceTable()
      ],
    );
  }

  Widget _chartHeader() {
    return ListTile(
      title: InkWell(
        onTap: () async {
          final returnData = await Get.to(() => SearchProductColorSizePage(),
              fullscreenDialog: true);
          if (returnData != null) {
            _selectedProduct = returnData;
            _loadSingleProduct();
            changeState();
          }
        },
        child: Text(_getTitle()),
      ),
      subtitle: Text('$startDate- $endDate'),
      trailing: IconButton(
          onPressed: pickRangeDate, icon: Icon(Icons.calendar_today)),
    );
  }

  void pickRangeDate() {
    DateTimeRangePicker(
        startText: "From",
        endText: "To",
        doneText: "Yes",
        cancelText: "Cancel",
        interval: 5,
        initialStartTime: _now.subtract(Duration(days: 1)),
        initialEndTime: _now,
        mode: DateTimeRangePickerMode.date,
        minimumTime: _now.subtract(Duration(days: 500)),
        maximumTime: _now.add(Duration(days: 30)),
        onConfirm: (start, end) {
          startDate = start.toIso8601String().split('T').first;
          endDate = end.toIso8601String().split('T').first;
          if (_selectedProduct == null)
            _loadData();
          else
            _loadSingleProduct();
        }).showPicker(context);
  }

  Widget _priceTable() {
    if (_selectedProduct != null)
      return Column(
        children: [
          termCard('Total sales', isPaidText('\$${reportDetailsModel.sell}')),
          termCard('Custom sales amount',
              isPaidText('\$${reportDetailsModel.customSale}')),
          termCard('Return amount',
              isPaidText('\$${reportDetailsModel.sellReturn}')),
          termCard(
              'Last sale date',
              isPaidText(
                  '${Utils.formatDate(reportDetailsModel.lastSaleDate)}')),
          termCard(
              'Last out of stock',
              isPaidText(
                  '${Utils.formatDate(reportDetailsModel.lastOutOfStockDate?.outOfStock)}')),
          // termCard('Best sold product',
          //     isPaidText('${reportDetailsModel.bestSell}')),
          termCard('Most Sale', getMostSale(reportDetailsModel.mostSale)),
        ],
      );
    return Column(
      children: [
        termCard('Total money worth of stock',
            isPaidText('\$${reportDetailsModel.totalMoney}')),
        termCard(
            'Total product', isPaidText('${reportDetailsModel.totalProduct}')),
        termCard('Total out of stock',
            isPaidText('${reportDetailsModel.totalOutOfStock}')),
        termCard(
            'Best sold product', isPaidText('${reportDetailsModel.bestSell}')),
      ],
    );
  }

  Widget termCard(String text, String amount) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      margin: EdgeInsets.symmetric(horizontal: 8),
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(text), Text(amount)],
      ),
    );
  }

  Widget graphSelectCard(double profit, double sell, double expense) {
    return Row(
      children: [
        graphCard('Profit', Utils.formatPrice(profit), 'assets/money-bag.png'),
        graphCard('Sales', Utils.formatPrice(sell), 'assets/currency.png'),
        // if (!authController.isUsrePaid())
        //   graphCardNonPaidUser(
        //       'Expense ', Utils.formatPrice(expense), 'assets/expenses.png')

        graphCard('Expense ', isPaidText(Utils.formatPrice(expense)),
            'assets/expenses.png'),
      ],
    );
  }

  Widget graphCard(String name, price, image) {
    return Flexible(
      flex: 1,
      child: Card(
        child: Container(
          padding: EdgeInsets.all(4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.asset(image,
                    fit: BoxFit.cover, height: 30, width: 30),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name),
                    AutoSizeText(
                      price,
                      maxLines: 1,
                      minFontSize: 4,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String _getTitle() {
    if (_selectedProduct != null) return "${_selectedProduct!['title']}";
    return 'All product >';
  }

  String isPaidText(String s) {
    return authController.isUserPaid() ? s : 'Not available';
  }

  String getMostSale(MostSale? mostSale) {
    if (mostSale == null) return isPaidText("");
    return isPaidText(
        "${mostSale.date} | ${Utils.formatPrice(mostSale.amount!)}");
  }
}
