import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yo_bray/data/model/product_response.dart';
import 'package:yo_bray/ulits/constant.dart';
import 'package:yo_bray/view/home/controller/home_controller.dart';

class SearchProductColorSizePage extends StatefulWidget {
  SearchProductColorSizePage({Key? key}) : super(key: key);

  @override
  _SearchProductColorSizePageState createState() =>
      _SearchProductColorSizePageState();
}

class _SearchProductColorSizePageState
    extends State<SearchProductColorSizePage> {
  final controller = Get.find<HomeController>();

  final searchEditController = TextEditingController();

  List<ProductModel> productList = <ProductModel>[];

  @override
  void initState() {
    super.initState();
    searchEditController.addListener(listener);
  }

  void listener() {
    if (searchEditController.text.isNotEmpty) {
      productList = controller.productList
          .where((element) => element
              .toString()
              .contains(searchEditController.text.toLowerCase()))
          .toList();
    } else
      productList = controller.productList;
    setState(() {});
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
        padding: const EdgeInsets.all(8),
        itemCount: productList.length,
        itemBuilder: (BuildContext ctx, int index) {
          final _productItem = productList[index];
          final children = <Widget>[];

          _productItem.colorSize?.forEach((element) {
            String title = _productItem.title ?? '';
            title += " (${element.color ?? ''}, ${element.size ?? ''})";
            final child = Card(
              child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(title),
                ),
                onTap: () {
                  Get.back(result: {
                    'color_size': element,
                    'title': title,
                  });
                },
              ),
            );
            children.add(child);
          });

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          );
        },
      ),
    );
  }
}
