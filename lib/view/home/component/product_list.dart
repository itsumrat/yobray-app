import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yo_bray/config/app_routes.dart';
import 'package:yo_bray/controller/auth_controller.dart';
import 'package:yo_bray/controller/login_shared_preference.dart';
import 'package:yo_bray/data/model/expenses_response.dart';
import 'package:yo_bray/data/model/product_response.dart';
import 'package:yo_bray/notification/notification.dart';
import 'package:yo_bray/ulits/constant.dart';
import 'package:yo_bray/ulits/urls.dart';
import 'package:yo_bray/ulits/utils.dart';
import 'package:yo_bray/view/activity/activity_controller.dart';
import 'package:yo_bray/view/home/controller/home_controller.dart';
import 'package:yo_bray/widgets/input_decorator.dart';
import 'package:yo_bray/widgets/toast.dart';

class ProductTab extends StatefulWidget {
  ProductTab({Key? key}) : super(key: key);

  @override
  _ProductTabState createState() => _ProductTabState();
}

class _ProductTabState extends State<ProductTab> {
  final controller = Get.find<HomeController>();
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        controller.fetchProduct();
        controller.fetchExpense();
      },
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 16),
        child: Obx(() => controller.productLoading.value
            ? Center(child: CircularProgressIndicator())
            : loadedWidget()),
      ),
    );
  }

  Widget loadedWidget() {
    if (controller.productList.length == 0)
      return Center(
          child: RawMaterialButton(
        fillColor: kPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        onPressed: () {
          HomeController controller = Get.find<HomeController>();
          controller.persistentTabController.value.jumpToTab(2);
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Add new Product',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ));

    return ListView.builder(
      itemCount: controller.productList.length,
      shrinkWrap: true,
      itemBuilder: (_, int index) => productCard(controller.productList[index]),
    );
  }

  Widget productCard(ProductModel item) {
    return Card(
      color: kPrimary,
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            // SizedBox(height: 6),
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
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
                PopupMenuButton<int>(
                  onSelected: (int value) async {
                    if (0 == value) {
                      reStock(
                        item,
                      );
                    } else if (1 == value)
                      Get.toNamed(AppRoutes.edit_product_page, arguments: item);
                    else if (2 == value){
                      setLowStock(item);

                    }
                    else if (3 == value) {
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
                            onPressed: () {
                              Get.back();
                              controller.undoProduct(item);
                            },
                            child: Text('Delete'),
                          ),
                        ],
                      );
                    }
                  },
                  child: const Icon(Icons.more_vert, color: Colors.white),
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
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
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: InkWell(
                onTap: () {
                  Get.toNamed(AppRoutes.single_product_view_page,
                      arguments: item);
                },
                child: CachedNetworkImage(
                  imageUrl: '${Urls.productImage}${item.featureImage}',
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      Image.asset('assets/dumy.jpg', fit: BoxFit.cover),
                  fit: BoxFit.cover,
                  height: 200,
                ),
              ),
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
                  onPressed: () {
                    if (authController.isUserPaid())
                      setExpenses(item);
                    else {
                      Utils.showSubscriptionWorning(context);
                    }
                  },
                  icon: Icon(Icons.account_balance_wallet),
                  label: Text("Expense"),
                ),
              ],
            ),
          ],
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
    if (controller.expensesList.length == 0) {
      successToast('‘Create an expense item from Settings');
      return;
    }

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
                child: Text("Color: ${element.color ?? ''}"),
              ),
              Container(
                width: double.infinity,
                child: Text("Size: ${element.size ?? ''}"),
              ),
              Container(
                width: double.infinity,
                child: Text("Price: ${element.salePrice ?? ''}"),
              ),
              Container(
                width: double.infinity,
                child: Text(
                  "Stock: ${element.quantity ?? ''}",
                  style: TextStyle(
                    color:
                        isLowStock(element) ? Colors.redAccent : Colors.black,
                  ),
                ),
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
}

class PostSell extends StatefulWidget {
  const PostSell({Key? key, required this.item}) : super(key: key);
  final ProductModel item;
  @override
  _PostSellState createState() => _PostSellState();
}

class _PostSellState extends State<PostSell> {
  final controller = Get.find<HomeController>();
  final activitycontroller = Get.put(ActivityController());
  final authController = Get.find<AuthController>();
  ColorSizeModel? selectedItem;

  List<ColorSizeModel>? colorSizes;

  final _formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  int quantity = 0;
  int? singleLowStock;

  @override
  void initState() {
    super.initState();
    colorSizes = widget.item.colorSize;
    if (colorSizes!.length > 0) {
      selectedItem = colorSizes!.first;
      amountController.text = '0';
    }
  }

  double getPrice() {
    try {
      if (selectedItem == null) return 0;
      double price = double.parse(selectedItem!.salePrice ?? '0');
      amountController.text = (price * quantity).toStringAsFixed(2);
    } catch (e) {}
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    int lowStock = LoginSharedPreference.getLowStock();
    final singleLowStockData =
        LoginSharedPreference.getProductReminder(selectedItem!.id!);
    if (singleLowStockData['isFind'])
      singleLowStock = singleLowStockData['value'];
    else
      singleLowStock = null;

    return Container(
      height: 350,
      padding: EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Stock: ${getItemQuantiti()}"),
                InkWell(
                  onTap: () => minuse(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xffe0777b),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(width: 4, color: Color(0xffeaa9ad)),
                    ),
                    child: Icon(Icons.remove, size: 18, color: Colors.white),
                  ),
                ),
                Container(
                  // padding: EdgeInsets.only(bottom: 0),
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.black, width: 1.0)),
                  ),
                  child: Text(
                    "$quantity",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                InkWell(
                  onTap: () => add(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xffe0777b),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(width: 4, color: Color(0xffeaa9ad)),
                    ),
                    child: Icon(Icons.add, size: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            DropdownButtonFormField(
              items: colorSizes?.map((ColorSizeModel colorSize) {
                return new DropdownMenuItem(
                    value: colorSize,
                    child: Text(
                        "\$${colorSize.salePrice} ${colorSize.color ?? ''}-${colorSize.size ?? ''}"));
              }).toList(),
              validator: (ColorSizeModel? id) {
                if (id == null) return 'Select item';
                return null;
              },
              onChanged: (newValue) {
                selectedItem = newValue as ColorSizeModel;
                setState(() {});
              },
              value: selectedItem,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                filled: true,
                border: InputBorder.none,
                fillColor: Colors.grey[200],
                hintText: 'Select Expense',
              ),
            ),
            SizedBox(height: 12),
            TextFormField(
              enabled: authController.isUserPaid(),
              validator: (String? s) {
                if (s == null || s.isEmpty) return 'Can Not Empty';
                return null;
              },
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: CommonDecorator.inputDecorator('Amount'),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: ()=>_submit(quantity),
              style: ButtonStyle(
                minimumSize:
                    MaterialStateProperty.all(Size(double.infinity, 35)),
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).primaryColor),
              ),
              child: Text("Done", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 30),
            if (lowStock >= getItemQuantiti() - quantity ||
                (singleLowStock != null &&
                    singleLowStock! >= getItemQuantiti() - quantity))
              Text(
                "Your \$${selectedItem?.salePrice} ${selectedItem?.color ?? ''}-${selectedItem?.size ?? ''} is Low Stock",
                style: TextStyle(color: Colors.redAccent),
              ),
          ]),
        ),
      ),
    );
  }

  void minuse() {
    if (quantity > 1) {
      quantity--;
      getPrice();
      changeState();
    }
  }

  void add() {
    if (quantity < getItemQuantiti()) {
      quantity++;
      getPrice();
      changeState();
    }
  }

  int getItemQuantiti() {
    try {
      if (selectedItem == null) return 0;
      return int.parse(selectedItem!.quantity ?? '0');
    } catch (e) {
      return 0;
    }
  }

  void changeState() => setState(() {});

  bool checkIsregularPrice() {
    try {
      var regularPrice = double.parse(selectedItem!.salePrice!) * quantity;
      var inputPrice = double.parse(amountController.text);
      if (regularPrice == inputPrice) return true;
    } catch (e) {}
    return false;
  }

  //send notificaipn
  Future<void> _submit(quantity) async {
    var stack = int.parse(selectedItem!.quantity!) - quantity;
    SharedPreferences _prsf = await SharedPreferences.getInstance();
    var lowStack = _prsf.getInt("setLowStack");
    var showLowStack = _prsf.getInt("setLowStockForAll");
    int allLowStack = showLowStack != null ? showLowStack : 0;
    print(lowStack);

    if(stack <= allLowStack){
      LocalNotificationService.showNotification(title: "${widget.item.title}", body: "low in stock");
    }else {
      if (stack <= num.parse("$lowStack")) {
        print("you have low stack");
        LocalNotificationService.showNotification(
            title: "${widget.item.title} ", body: "low in stock");
      } else {
        print("you don't have low stack");
      }
    }

    if (getItemQuantiti() < 0) {
      errorToast("Out of stock Cant\'t sell");
      Get.back();
      return;
    } else if (selectedItem == null || quantity <= 0) {
      // errorToast("You did't select any item");
      Get.back();
      return;
    }

    final formState = _formKey.currentState;
    formState!.save();
    if (formState.validate()) {
      var colorSize = '';
      colorSizes?.forEach((element) {
        if (element == selectedItem)
          colorSize = "${element.color ?? ''}-${element.size ?? ''}";
      });

      String sellPrice = checkIsregularPrice() ? 'Regular' : 'Custom';

      final Map<String, dynamic> body = {
        'product_id': widget.item.id,
        'quantity': quantity,
        'price': amountController.text,
        'color_size': "$colorSize",
        'color_size_id': "${selectedItem!.id}",
        'sell_price ': sellPrice
      };
      controller.submitProductSell(body);
      activitycontroller.fetchActivitySellProduct();
      Get.back();
    }
  }
}

class SetLowStock extends StatefulWidget {
  const SetLowStock({Key? key, required this.item}) : super(key: key);
  final ProductModel item;
  @override
  _SetLowStockState createState() => _SetLowStockState();
}

class _SetLowStockState extends State<SetLowStock> {
  final controller = Get.find<HomeController>();
  final authController = Get.find<AuthController>();
  ColorSizeModel? selectedItem;

  List<ColorSizeModel>? colorSizes;

  final _formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  int quantity = 0;

  @override
  void initState() {
    super.initState();
    colorSizes = widget.item.colorSize;
    if (colorSizes!.length > 0) {
      selectedItem = colorSizes!.first;
      amountController.text = '0';
    }
  }

  @override
  Widget build(BuildContext context) {
    final lowStock =
        LoginSharedPreference.getProductReminder(selectedItem!.id!);
    if (lowStock['isFind'])
      amountController.text = '${lowStock['value']}';
    else
      amountController.text = '0';

    return Container(
      height: 300,
      padding: EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(children: [
            SizedBox(height: 20),
            DropdownButtonFormField<ColorSizeModel>(
              items: colorSizes?.map((ColorSizeModel colorSize) {
                return new DropdownMenuItem(
                    value: colorSize,
                    child: Text(
                        "\$${colorSize.salePrice}-stock:${colorSize.quantity} -color${colorSize.color ?? 'None'}-size:${colorSize.size ?? 'None'}"));
              }).toList(),
              validator: (ColorSizeModel? id) {
                if (id == null) return 'Select item';
                return null;
              },
              isDense: true,
              isExpanded: true,
              onChanged: (ColorSizeModel? newValue) {
                selectedItem = newValue as ColorSizeModel;
                setState(() {});
              },
              value: selectedItem,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                filled: true,
                border: InputBorder.none,
                fillColor: Colors.grey[200],
                hintText: 'Select item',
              ),
            ),
            SizedBox(height: 12),
            TextFormField(
              validator: (String? s) {
                if (s == null || s.isEmpty) return 'Can Not Empty';
                return null;
              },
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: CommonDecorator.inputDecorator('low stock number'),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submit,
              style: ButtonStyle(
                minimumSize:
                    MaterialStateProperty.all(Size(double.infinity, 35)),
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).primaryColor),
              ),
              child:
                  Text("Set low stock", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 30),
          ]),
        ),
      ),
    );
  }

  //set low stack
  Future<void> _submit() async {
    SharedPreferences _prfs = await SharedPreferences.getInstance();
    _prfs.setInt("setLowStack", int.parse(amountController.text));
    final formState = _formKey.currentState;
    formState!.save();
    if (!formState.validate()) return;

    LoginSharedPreference.setLowStockList(
        {'${selectedItem!.id}': int.parse(amountController.text)});

    Get.back();
  }
}

class Restock extends StatefulWidget {
  final ProductModel? item;
  const Restock({Key? key, this.item}) : super(key: key);

  @override
  State<Restock> createState() => _RestockState();
}

class _RestockState extends State<Restock> {
  final amountController = TextEditingController();
  final quantityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<ColorSizeModel>? colorSizes;
  ColorSizeModel? selectedItem;
  int index = 0;
  int quantity = 0;
  int? id;
  @override
  void initState() {
    colorSizes = widget.item!.colorSize;
    if (colorSizes!.length > 0) {
      selectedItem = colorSizes!.first;
      amountController.text = widget.item!.colorSize![0].quantity!;
      quantityController.text = quantity.toString();
      id = widget.item!.colorSize![0].id;
    }
    super.initState();
  }

  int changeControllerData() {
    log(quantity.toString());
    try {
      if (quantity > 1) {
        quantity--;
        quantityController.text = quantity.toString();
        setState(() {});
        return quantity;
      }
    } catch (e) {
      return 0;
    }
    return 0;
  }

  int changeControllerDataPlus() {
    log(quantity.toString());
    try {
      quantity++;
      quantityController.text = quantity.toString();
      setState(() {});
      return quantity;
    } catch (e) {
      return 0;
    }
  }

  int getItemQuantiti() {
    try {
      return int.parse(selectedItem!.quantity ?? '0');
    } catch (e) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 12),
                DropdownButtonFormField<ColorSizeModel>(
                  items: colorSizes?.map((ColorSizeModel colorSize) {
                    return new DropdownMenuItem(
                        value: colorSize,
                        child: Text(
                            "\$${colorSize.salePrice}-stock:${colorSize.quantity} -color${colorSize.color ?? 'None'}-size:${colorSize.size ?? 'None'}"));
                  }).toList(),
                  validator: (ColorSizeModel? id) {
                    if (id == null) return 'Select item';
                    return null;
                  },
                  isDense: true,
                  isExpanded: true,
                  onChanged: (ColorSizeModel? newValue) {
                    selectedItem = newValue as ColorSizeModel;
                    quantity = 0;
                    id = newValue.id;
                    amountController.text = newValue.quantity!;
                    quantityController.text = "0";
                    setState(() {});
                  },
                  value: selectedItem,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                    filled: true,
                    isDense: true,
                    border: InputBorder.none,
                    fillColor: Colors.grey[200],
                    hintText: 'Select item',
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        validator: (String? s) {
                          if (s == null || s.isEmpty) return 'Can Not Empty';
                          return null;
                        },
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration:
                            CommonDecorator.inputDecorator('Restock number'),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            changeControllerData();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xffe0777b),
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                  width: 4, color: Color(0xffeaa9ad)),
                            ),
                            child: Icon(Icons.remove,
                                size: 18, color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.black, width: 1.0)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                  height: 30,
                                  width: 50,
                                  child: TextFormField(
                                    showCursor: false,
                                    onChanged: (val) {
                                      try {
                                        quantity = int.parse(val);
                                      } catch (e) {
                                        quantity = 0;
                                      }
                                    },
                                    controller: quantityController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        InkWell(
                          onTap: () => changeControllerDataPlus(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xffe0777b),
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                  width: 4, color: Color(0xffeaa9ad)),
                            ),
                            child:
                                Icon(Icons.add, size: 18, color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    if (id != null) {
                      await _restock(id: id, quantiy: quantity);
                    }
                  },
                  style: ButtonStyle(
                    minimumSize:
                        MaterialStateProperty.all(Size(double.infinity, 35)),
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor),
                  ),
                  child: Text("Restock", style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future _restock({int? id, int? quantiy}) async {
  final controller = Get.find<HomeController>();
  controller.restock(id: id, quantity: quantiy);
  Get.back();
}

class PostExpeses extends StatefulWidget {
  final ProductModel item;
  const PostExpeses({Key? key, required this.item}) : super(key: key);

  @override
  _PostExpesesState createState() => _PostExpesesState();
}

class _PostExpesesState extends State<PostExpeses> {
  final controller = Get.find<HomeController>();
  ExpensType? expenseId;
  List<ExpensType> list = [];

  final _formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    list = controller.expensesList;
    if (list.length > 1) expenseId = list[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20),
              DropdownButtonFormField<ExpensType>(
                items: list.map((ExpensType expensType) {
                  return new DropdownMenuItem(
                      value: expensType, child: Text('${expensType.name}'));
                }).toList(),
                validator: (ExpensType? id) {
                  if (id == null) return 'Select item';
                  return null;
                },
                onChanged: (newValue) {
                  expenseId = newValue as ExpensType;
                },
                value: expenseId,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                  filled: true,
                  border: InputBorder.none,
                  fillColor: Colors.grey[200],
                  hintText: 'Select Expense',
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                validator: (String? s) {
                  if (s == null || s.isEmpty) return 'Cant Not Empty';
                  return null;
                },
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: CommonDecorator.inputDecorator('Amount'),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submit,
                style: ButtonStyle(
                  minimumSize:
                      MaterialStateProperty.all(Size(double.infinity, 35)),
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).primaryColor),
                ),
                child: Text("Done", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final formState = _formKey.currentState;
    formState!.save();
    if (formState.validate()) {
      final Map<String, dynamic> body = {
        'product_id': widget.item.id!,
        'product_title': widget.item.title,
        'product_feature': widget.item.featureImage,
        'quantity': 0,
        'amount': amountController.text,
        'expense_type_id': "${expenseId!.id}",
        'expense_name': "${expenseId!.name}"
      };
      controller.submitProductExpense(body);
      Get.back();
    }
  }
}
