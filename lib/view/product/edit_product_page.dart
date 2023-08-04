import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yo_bray/controller/with_file_upload.dart';
import 'package:yo_bray/data/model/product_response.dart';
import 'package:yo_bray/ulits/constant.dart';
import 'package:yo_bray/ulits/urls.dart';
import 'package:yo_bray/ulits/utils.dart';
import 'package:yo_bray/view/home/controller/home_controller.dart';
import 'package:yo_bray/widgets/input_decorator.dart';
import 'package:yo_bray/widgets/product_info_form.dart';
import 'package:yo_bray/widgets/toast.dart';

class EditProductPage extends StatefulWidget {
  const EditProductPage({Key? key}) : super(key: key);

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final controller = Get.find<HomeController>();
  File? file;

  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();

  final _descriptionController = TextEditingController();
  String pickedColor = 'white';

  List<ProductCardForm> formList = <ProductCardForm>[];
  ProductModel item = Get.arguments as ProductModel;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() {
    _titleController.text = item.title ?? '';
    _descriptionController.text = item.description ?? '';
    var _isFast = true;

    if (item.colorSize != null && item.colorSize!.length > 0) {
      item.colorSize!.forEach((element) {
        final model = element;

        final key = UniqueKey();
        if (_isFast) {
          formList.add(
            ProductCardForm(
              key: key,
              isFirst: true,
              infoModel: model,
              onAction: () => _addForm(),
            ),
          );
          _isFast = false;
        } else {
          formList.add(
            ProductCardForm(
              key: key,
              infoModel: model,
              onAction: () => onDelete(key),
            ),
          );
        }
      });
    } else {
      final model = ColorSizeModel();
      final key = UniqueKey();
      formList.add(ProductCardForm(
        key: key,
        isFirst: true,
        infoModel: model,
        onAction: () => _addForm(),
      ));
    }
  }

  void onDelete(UniqueKey key) {
    var find = formList.firstWhere((it) => it.key == key);
    formList.removeAt(formList.indexOf(find));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(formList);
    return Scaffold(
      appBar: AppBar(title: Text('Edit Product'), leadingWidth: leadingWidth),
      body: SingleChildScrollView(
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
              TextButton(
                onPressed: _submitForm,
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).primaryColor),
                ),
                child: Text("Update", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
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

    // //if info card form not valid
    if (!isCardValid) return;

    Map<String, dynamic> body = {
      'title': _titleController.text,
      'description': _descriptionController.text,
    };

    final sale = <String>[];
    final purchase = <String>[];
    final color = <String>[];
    final size = <String>[];
    final stock = <String>[];
    final id = <String>[];
    print(formList);

    formList.asMap().forEach((int i, ProductCardForm element) {
      id.add('${element.infoModel.id ?? ''}');
      sale.add(element.infoModel.salePrice ?? '0');
      purchase.add(element.infoModel.purcasePrice ?? '0');
      color.add(element.infoModel.color ?? '');
      size.add(element.infoModel.size ?? '');
      stock.add(element.infoModel.quantity ?? '');
    });

    body["sale[]"] = sale;
    body["purchase[]"] = purchase;
    body["color[]"] = color;
    body["size[]"] = size;
    body["stock[]"] = stock;
    body["color_size_id[]"] = id;
    print(body);

    myShowDialog();
    WithFileUpload withFileUpload = WithFileUpload();
    final result = await withFileUpload.updateProduct(body, file, item.id!);

    if (Get.isDialogOpen!) Get.back();
    if (result) {
      controller.fetchProduct();
      Get.back();
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
      hideHeader: true,
      infoModel: model,
      onAction: () => onDelete(key),
    ));
    setState(() {});
  }

  Widget _imageView() {
    return SizedBox(
      height: 200,
      // width: 200,
      child: Center(
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
                ? Image.file(file!, fit: BoxFit.cover)
                : CachedNetworkImage(
                    imageUrl: '${Urls.productImage}${item.featureImage}',
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        Image.asset('assets/dumy.jpg', fit: BoxFit.cover),
                    fit: BoxFit.cover,
                  )

            //  Image.network(
            //     '${Urls.productImage}${item.featureImage}',
            //     fit: BoxFit.cover,
            //     errorBuilder: (_, __, ___) {
            //       return Image.asset('assets/dumy.jpg',
            //           height: 130, fit: BoxFit.cover);
            //     },
            //   ),
            ),
      ),
    );
  }
}
