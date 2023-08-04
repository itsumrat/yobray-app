import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yo_bray/data/model/activity_job_response.dart';
import 'package:yo_bray/data/model/product_response.dart';
import 'package:yo_bray/ulits/urls.dart';
import 'package:yo_bray/ulits/utils.dart';
import 'package:yo_bray/view/activity/activity_controller.dart';

class ActivityProductList extends StatelessWidget {
  ActivityProductList({Key? key}) : super(key: key);
  final controller = Get.find<ActivityController>();

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
    if (controller.productList.length == 0)
      return ListView(
        children: [
          SizedBox(height: 20),
          Center(child: Text('No Item')),
        ],
      );

    return ListView.builder(
      padding: EdgeInsets.all(8),
      itemCount: controller.productList.length,
      itemBuilder: (BuildContext ctx, int index) =>
          _productCard(controller.productList[index]),
    );
  }

  Widget _productCard(ActivityJobModel item) {
    final jsonData = json.decode(item.description!);
    late ProductModel productModel;
    try {
      // print(jsonData.runtimeType);
      print(jsonData);
      productModel = ProductModel.fromJsonActivity(jsonData);
    } catch (e) {
      print('/n/n/n');
      print(jsonData);
      print(e.toString());
      return SizedBox();
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      '${Urls.productImage}${productModel.feature}',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return Center(child: Text("Image not found"));
                      },
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${productModel.title ?? ''} ',
                        maxLines: 3,
                        style: TextStyle(color: Colors.blue),
                      ),
                      Text('${productModel.totalQuantity ?? 0} item sold at'),
                      Text('${productModel.updatedAt ?? ''}'),
                      Text(
                          Utils.formatPrice(_getPrice(productModel.salePrice))),
                    ],
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () {},
                  child: Icon(Icons.import_contacts_sharp),
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                actionIcon(
                    child: Icon(Icons.undo_outlined),
                    text: 'Undo',
                    onTap: () {}),
                actionIcon(
                    child: Icon(Icons.share), text: 'Share', onTap: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  InkWell actionIcon(
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
}
