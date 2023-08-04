import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yo_bray/data/model/product_response.dart';
import 'package:yo_bray/ulits/constant.dart';
import 'package:yo_bray/view/home/controller/home_controller.dart';

class SearchProductPage extends StatefulWidget {
  SearchProductPage({Key? key}) : super(key: key);

  @override
  _SearchProductPageState createState() => _SearchProductPageState();
}

class _SearchProductPageState extends State<SearchProductPage> {
  final controller = Get.find<HomeController>();

  final searchEditController = TextEditingController();

  List<ProductModel> productList = <ProductModel>[];

  @override
  void initState() {
    super.initState();

    searchEditController.addListener(() {
      if (searchEditController.text.isNotEmpty) {
        productList = controller.productList
            .where((element) => element
                .toString()
                .contains(searchEditController.text.toLowerCase()))
            .toList();
      } else
        productList = controller.productList;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: leadingWidth,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.centerLeft,
          child: TextFormField(
            autofocus: true,
            controller: searchEditController,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: false,
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              hintText: 'Search query',
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.grey),
              ),
              suffixIcon: InkWell(
                  onTap: () {
                    if (searchEditController.text.isEmpty) return;

                    FocusScope.of(context).requestFocus(FocusNode());
                    // controller.search();
                  },
                  child: Icon(Icons.search_sharp, color: Colors.black)),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: productList.length,
        itemBuilder: (BuildContext ctx, int index) {
          final product = productList[index];
          return Container(
            height: 40,
            child: ListTile(
              onTap: () => Get.back(result: '${product.title ?? ''}'),
              minLeadingWidth: 20,
              leading: Icon(Icons.image),
              title: Text('${product.title}'),
            ),
          );
        },
      ),
    );
  }
}
