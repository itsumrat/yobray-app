import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yo_bray/config/app_routes.dart';
import 'package:yo_bray/controller/login_shared_preference.dart';
import 'package:yo_bray/data/model/product_response.dart';
import 'package:yo_bray/ulits/constant.dart';
import 'package:yo_bray/ulits/urls.dart';
import 'package:yo_bray/view/home/component/product_list.dart'
    show PostExpeses, PostSell, Restock, SetLowStock;
import 'package:yo_bray/view/home/controller/home_controller.dart';
import 'package:yo_bray/widgets/image_preview_page.dart';

class SingleProductViewPage extends StatefulWidget {
  const SingleProductViewPage({Key? key}) : super(key: key);

  @override
  _SingleProductViewPageState createState() => _SingleProductViewPageState();
}

class _SingleProductViewPageState extends State<SingleProductViewPage> {
  ProductModel item = Get.arguments as ProductModel;
  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Single Product View')),
      body: SingleChildScrollView(
        child: Card(
          color: kPrimary,
          child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          Get.toNamed(AppRoutes.single_product_view_page,
                              arguments: item);
                        },
                        child: Text('${item.title}',
                            overflow: TextOverflow.ellipsis,
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                    PopupMenuButton<int>(
                      onSelected: (int value) async {
                        if (0 == value) {
                          reStock(item);
                        }
                        if (1 == value)
                          Get.toNamed(AppRoutes.edit_product_page,
                              arguments: item);
                        else if (2 == value)
                          setLowStock(item);
                        else if (3 == value) {
                          _delete(item);
                        }
                      },
                      child: const Icon(Icons.more_vert, color: Colors.white),
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<int>>[
                        PopupMenuItem<int>(
                            value: 0,
                            height: kDroapDownHeight,
                            child: const Text('Restock')),
                        PopupMenuItem<int>(
                            value: 1,
                            height: kDroapDownHeight,
                            child: const Text('Edit')),
                        PopupMenuItem<int>(
                            value: 2,
                            height: kDroapDownHeight,
                            child: const Text('Set low stock')),
                        PopupMenuItem<int>(
                            value: 3,
                            height: kDroapDownHeight,
                            child: const Text('Delete')),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    Get.to(() => ImagePreviewPage(
                        imagePath: '${Urls.productImage}${item.featureImage}'));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CachedNetworkImage(
                      imageUrl: '${Urls.productImage}${item.featureImage}',
                      fit: BoxFit.contain,
                      height: 200,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          Image.asset('assets/dumy.jpg', fit: BoxFit.cover),
                    ),
                  ),
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Flexible(
                      child: Text('${item.description}',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                ..._colorSizeWidget(item.colorSize),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.white30,
                      ),
                      onPressed: () => sell(item),
                      icon: Icon(Icons.price_change),
                      label: Text("Sale"),
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.white30,
                      ),
                      onPressed: () => setExpenses(item),
                      icon: Icon(Icons.account_balance_wallet),
                      label: Text("Expense"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void reStock(ProductModel item) {
    Get.bottomSheet(
      Restock(item: item),
      enableDrag: true,
      isScrollControlled: true,
      ignoreSafeArea: true,
      clipBehavior: Clip.hardEdge,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15.0),
        ),
      ),
    );
  }

  void setLowStock(ProductModel item) {
    Get.bottomSheet(
      SetLowStock(item: item),
      enableDrag: true,
      isScrollControlled: true,
      ignoreSafeArea: true,
      clipBehavior: Clip.hardEdge,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15.0),
        ),
      ),
    );
  }

  int lowStock = LoginSharedPreference.getLowStock();

  bool isLowStock(ColorSizeModel colorSizeModel) {
    try {
      final value = int.parse(colorSizeModel.quantity ?? '0');
      int? singleLowStock;

      final singleLowStockData =
          LoginSharedPreference.getProductReminder(colorSizeModel.id!);
      if (singleLowStockData['isFind'])
        singleLowStock = singleLowStockData['value'];
      else
        singleLowStock = null;

      if (value <= lowStock ||
          (singleLowStock != null && value <= singleLowStock)) return true;
    } catch (e) {}
    return false;
  }

  void sell(ProductModel item) {
    Get.bottomSheet(
      PostSell(item: item),
      enableDrag: true,
      isScrollControlled: true,
      ignoreSafeArea: true,
      clipBehavior: Clip.hardEdge,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15.0),
        ),
      ),
    );
  }

  void setExpenses(ProductModel item) {
    Get.bottomSheet(
      PostExpeses(item: item),
      enableDrag: true,
      isScrollControlled: true,
      ignoreSafeArea: true,
      clipBehavior: Clip.hardEdge,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15.0),
        ),
      ),
    );
  }

  List<Widget> _colorSizeWidget(List<ColorSizeModel>? colorSize) {
    List<Widget> list = [];
    if (colorSize == null) return list;

    colorSize.forEach((element) {
      final card = Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: double.infinity,
                child: Text("Buy price: ${element.purcasePrice ?? ''}"),
              ),
              Container(
                width: double.infinity,
                child: Text("Sell Price: ${element.salePrice ?? ''}"),
              ),
              Container(
                width: double.infinity,
                child: Text("Quantity: ${element.quantity ?? ''}",
                    style: TextStyle(
                        color: isLowStock(element)
                            ? Colors.redAccent
                            : Colors.black)),
              ),
              Container(
                width: double.infinity,
                child: Text("Color: ${element.color ?? ''}"),
              ),
              Container(
                width: double.infinity,
                child: Text("Size: ${element.size ?? ''}"),
              ),
            ],
          ),
        ),
      );
      list.add(card);
    });

    List<Widget> returnList = [];
    for (int i = 0; i < list.length; i += 2) {
      if (i == list.length - 1) {
        final row = Row(
          children: [
            Flexible(child: list[i]),
            Flexible(child: SizedBox()),
          ],
        );
        returnList.add(row);
      } else {
        final row = Row(
          children: [
            Flexible(child: list[i]),
            Flexible(child: list[i + 1]),
          ],
        );
        returnList.add(row);
      }
    }

    return returnList;
  }

  void _delete(ProductModel item) {
    Get.defaultDialog(
      title: 'Confirm',
      content: Text('Are you sure you want to delete?'),
      actions: [
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              'Cancle',
              style: TextStyle(color: Colors.redAccent),
            )),
        TextButton(
          onPressed: () async {
            Get.back();
            final result = await controller.undoProduct(item);
            if (result == true) Get.back();
          },
          child: Text('Delete'),
        ),
      ],
    );
  }
}
