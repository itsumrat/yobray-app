import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yo_bray/controller/with_file_upload.dart';
import 'package:yo_bray/data/model/product_response.dart';
import 'package:yo_bray/ulits/utils.dart';
import 'package:yo_bray/view/home/controller/home_controller.dart';
import 'package:yo_bray/widgets/input_decorator.dart';
import 'package:yo_bray/widgets/product_info_form.dart';
import 'package:yo_bray/widgets/toast.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({Key? key}) : super(key: key);

  @override
  _CreateProductPageState createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final controller = Get.find<HomeController>();
  File? file;

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String pickedColor = '';

  List<ProductCardForm> formList = <ProductCardForm>[];

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    formList.clear();
    final model = ColorSizeModel();
    final key = UniqueKey();
    formList.add(
      ProductCardForm(
        key: key,
        isFirst: true,
        infoModel: model,
        onAction: () => _addForm(),
      ),
    );
    _titleController.text = '';
    _descriptionController.text = '';
    file = null;
  }

  void onDelete(UniqueKey key) {
    var find = formList.firstWhere((it) => it.key == key);
    formList.removeAt(formList.indexOf(find));
    setState(() {});
    print(key);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(8),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _imageView(),
            SizedBox(height: 12),
            _buildTitleField(),
            SizedBox(height: 12),
            _buildDescriptionField(),
            SizedBox(height: 12),
            ...formList,
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: _submitForm,
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor),
                    ),
                    child:
                        Text("Create", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    final formState = _formKey.currentState;
    final isValid = formState!.validate();

    //if form not valid
    if (!isValid) return;
    formState.save();

    final isCardValid = formList.every((element) => element.state.saveForm());
    //if info card form not valid
    if (!isCardValid) return;
    FocusScope.of(context).requestFocus(FocusNode());

    Map<String, dynamic> body = {
      'title': _titleController.text,
      'description': _descriptionController.text,
    };

    final sale = <String>[];
    final purchase = <String>[];
    final color = <String>[];
    final size = <String>[];
    final stock = <String>[];

    formList.asMap().forEach((int i, ProductCardForm element) {
      sale.add(element.infoModel.salePrice ?? '0');
      purchase.add(element.infoModel.purcasePrice ?? '0');
      color.add(element.infoModel.color ?? '');
      size.add(element.infoModel.size ?? '');
      stock.add(element.infoModel.quantity ?? '0');
    });

    body["sale[]"] = sale;
    body["purchase[]"] = purchase;
    body["color[]"] = color;
    body["size[]"] = size;
    body["stock[]"] = stock;

    print(body);
    print('my response');
    myShowDialog();
    WithFileUpload withFileUpload = WithFileUpload();
    final result = await withFileUpload.createProduct(body, file);

    if (Get.isDialogOpen ?? false) Get.back();
    if (result) {
      successToast('Product create successful');
      controller.fetchProduct();
      _init();
      HomeController homeController = Get.find<HomeController>();
      homeController.persistentTabController.value.jumpToTab(0);
    } else {
      errorToast('Some Error');
    }
  }

  TextFormField _buildTitleField() {
    return TextFormField(
      validator: (s) {
        if (s == null || s.isEmpty) return 'Enter Title';
        return null;
      },
      controller: _titleController,
      keyboardType: TextInputType.name,
      decoration: CommonDecorator.inputDecorator('Product title'),
    );
  }

  TextFormField _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      minLines: 5,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide.none),
        fillColor: Color(0xffF2F2F2),
        filled: true,
        hintText: 'Description',
        hintStyle: TextStyle(color: Colors.grey),
      ),
    );
  }

  void _addForm() {
    final model = ColorSizeModel();
    final key = UniqueKey();
    formList.add(ProductCardForm(
      key: key,
      infoModel: model,
      onAction: () => onDelete(key),
    ));
    setState(() {});
  }

  Widget _imageView() {
    return Center(
      child: InkWell(
        onTap: () async {
          final imageSource = await Utils.showImageSource(context);
          if (imageSource != null) {
            final result = await Utils.pickFile(imageSource);
            if (result != null) {
              file = result;
              setState(() {});
            }
          }
        },
        child: file != null
            ? Image.file(file!, height: 150, fit: BoxFit.cover)
            : Image.asset('assets/dumy.jpg', height: 150, fit: BoxFit.cover),
      ),
    );
  }
}
