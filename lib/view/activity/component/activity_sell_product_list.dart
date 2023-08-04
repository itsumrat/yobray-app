import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';
import 'package:yo_bray/data/model/activity_sell_response.dart';
import 'package:yo_bray/ulits/strings.dart';
import 'package:yo_bray/ulits/urls.dart';
import 'package:yo_bray/ulits/utils.dart';
import 'package:yo_bray/view/activity/activity_controller.dart';
import 'package:yo_bray/view/home/controller/home_controller.dart';
import 'package:yo_bray/widgets/toast.dart';

class ActivitySellProductList extends StatelessWidget {
  ActivitySellProductList({Key? key}) : super(key: key);
  final controller = Get.find<ActivityController>();
  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => controller.fetchActivitySellProduct(),
      child: Obx(() => controller.productLoading.value
          ? Center(child: CircularProgressIndicator())
          : _buildLoadedWidget()),
    );
  }

  Widget _buildLoadedWidget() {
    if (controller.sellProductList.length == 0)
      return ListView(
        children: [
          SizedBox(height: 20),
          Center(child: Text('No Item')),
        ],
      );

    return ListView.builder(
      padding: EdgeInsets.all(8),
      itemCount: controller.sellProductList.length,
      itemBuilder: (BuildContext ctx, int index) =>
          _productCard(controller.sellProductList[index]),
    );
  }

  Widget _productCard(SellProductModel item) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      '${Urls.productImage}${item.description?.featureImage}',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return Center(child: Text("Image not found"));
                      },
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${item.description?.title ?? ''} ',
                      maxLines: 3,
                      style: TextStyle(color: Colors.blue),
                    ),
                    SizedBox(height: 4),
                    Text(
                        '${item.description!.sellPrice.toString()} item sold at'),
                    SizedBox(height: 4),
                    Text(
                        'Color & Size: ${item.description!.colorSize.toString()}'),
                    SizedBox(height: 4),
                    Text('🕒 ${Utils.formatDate(item.updatedAt ?? '')}'),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        SizedBox(width: 2),
                        Image.asset("assets/currency.png",
                            height: 14, width: 14),
                        SizedBox(width: 4),
                        Text(
                          Utils.formatPrice(_getPrice(item.description!.price)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                actionIcon(
                  child: Icon(Icons.delete),
                  text: 'Delete',
                  onTap: () => undoProduct(item, false),
                ),
                actionIcon(
                  child: Icon(Icons.undo_outlined),
                  text: 'Undo',
                  onTap: () => undoProduct(item, true),
                ),
                actionIcon(
                  child: Icon(Icons.share),
                  text: 'Share',
                  onTap: () => Share.share(Strings.productShare),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget actionIcon(
      {required String text,
      required Widget child,
      required VoidCallback onTap}) {
    return InkWell(
      child: Column(
        children: [
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: child,
          ),
          SizedBox(height: 4),
          Text(
            text,
            style: TextStyle(fontSize: 12),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  double _getPrice(String? salePrice) {
    try {
      if (salePrice == null) return 0;
      return double.parse(salePrice);
    } catch (e) {
      print('cant convert to double');
    }
    return 0;
  }

  Future<void> undoProduct(SellProductModel item, bool isUndo) async {
    Get.defaultDialog(
      title: 'Confirm',
      content: isUndo
          ? Text('Are you sure you want to Undo ?')
          : Text('Are you sure you want to Delete ?'),
      actions: [
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.redAccent),
            )),
        TextButton(
          onPressed: () async {
            Get.back();
            myShowDialog();
            if (isUndo) {
              final isRemoved =
                  await homeController.returnProductSell(item.id!);
              if (isRemoved) controller.fetchActivitySellProduct();
              if (Get.isDialogOpen!) Get.back();
            } else {
              final isRemoved =
                  await homeController.deleteProduct(id: item.id!);
              if (isRemoved) controller.fetchActivitySellProduct();
              if (Get.isDialogOpen!) Get.back();
            }
          },
          child: isUndo ? Text('Undo') : Text('Delete'),
        ),
      ],
    );
  }
}
