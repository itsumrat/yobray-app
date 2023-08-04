import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:yo_bray/controller/auth_controller.dart';
import 'package:yo_bray/ulits/constant.dart';
import 'package:yo_bray/view/setting/slider.dart';

class SubscriptionPage extends StatefulWidget {
  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  final authController = Get.find<AuthController>();

  final String _productID = GetPlatform.isAndroid
      ? 'product_yobray_plus'
      : 'product_yobray_plus_test';

  bool _available = true;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  @override
  void initState() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;

    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      setState(() {
        _listenToPurchaseUpdated(purchaseDetailsList);
      });
    }, onDone: () {
      print('onDone ');
      _subscription?.cancel();
    }, onError: (error) {
      print('error ');
      _subscription?.cancel();
    });

    _initialize();

    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _initialize() async {
    _available = await _inAppPurchase.isAvailable();
    print('product is Available $_available');

    List<ProductDetails> products =
        await _getProducts(productIds: Set<String>.from([_productID]));

    setState(() {
      _products = products;
    });

    // await InAppPurchase.instance.restorePurchases();
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      print('product status ${purchaseDetails.status}');

      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          //  _showPendingUI();
          break;
        case PurchaseStatus.purchased:
          authController.doPaidUser();
          _purchases.add(purchaseDetails);
          break;
        case PurchaseStatus.restored:
          print('restored products');

          _purchases.addAll(purchaseDetailsList);

          // bool valid = await _verifyPurchase(purchaseDetails);
          // if (!valid) {
          //   _handleInvalidPurchase(purchaseDetails);
          // }
          break;
        case PurchaseStatus.error:
          print(purchaseDetails.error!);
          // _handleError(purchaseDetails.error!);
          break;
        default:
          break;
      }

      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
    });
  }

  Future<List<ProductDetails>> _getProducts(
      {required Set<String> productIds}) async {
    ProductDetailsResponse response =
        await _inAppPurchase.queryProductDetails(productIds);
    print('get product response ${response.productDetails}');
    print('get product notFoundIDs ${response.notFoundIDs}');

    return response.productDetails;
  }

  Widget _buildProduct({required ProductDetails product}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                  fontSize: 20, letterSpacing: -1, color: Color(0xff757575)),
              children: [
                TextSpan(text: 'Yobray'),
                TextSpan(
                  text: ' Plus',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.black),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                  fontSize: 25,
                  letterSpacing: -1,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              children: [
                TextSpan(text: '${product.price}'),
                TextSpan(
                  text: '/month',
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text('The price per one user. Change \nor cancel your plan anytime',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimary,
                      padding: EdgeInsets.symmetric(vertical: 16)),
                  onPressed: () {
                    _subscribe(product: product);
                  },
                  child: Text(
                    "Upgrade to Plus",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          CarousolSlider(),
          // Text(product.description.split('*').join('\n'),
          //     textAlign: TextAlign.center,
          //     style: TextStyle(fontSize: 16, height: 1.67)),
        ],
      ),
    );
  }

  // Future _consumeAllProduct(PurchaseDetails purchase) async {
  //   print('........========= ${purchase.productID} ${purchase.purchaseID}');
  //   final InAppPurchaseAndroidPlatformAddition androidAddition = _inAppPurchase
  //       .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
  //   var res = await androidAddition.consumePurchase(purchase);
  //   print('_buildPurchase ${res.responseCode}');
  //   print('_buildPurchase ${res.debugMessage}');
  // }

  void _subscribe({required ProductDetails product}) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);

    print('purchaseParam ${purchaseParam.applicationUserName}');
    // var res = await _inAppPurchase.consumePurchase(purchase);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscription'),
        leadingWidth: leadingWidth,
      ),
      body: _available
          ? ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SizedBox(),
                ..._products
                    .map((ProductDetails productDetails) =>
                        _buildProduct(product: productDetails))
                    .toList(),
              ],
            )
          : Center(
              child: Text('Subscription not available'),
            ),
    );
  }
}
