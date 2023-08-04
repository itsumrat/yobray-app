import 'package:flutter/material.dart';
import 'package:yo_bray/data/model/product_response.dart';
import 'package:yo_bray/ulits/utils.dart';

import 'input_decorator.dart';

typedef OnDelete();

class ProductCardForm extends StatefulWidget {
  ProductCardForm({
    Key? key,
    required this.infoModel,
    required this.onAction,
    this.isFirst = false,
    this.hideHeader = false,
  }) : super(key: key);

  ColorSizeModel infoModel;

  final OnDelete onAction;
  final bool isFirst, hideHeader;

  final state = _ProductCardFormState();

  @override
  _ProductCardFormState createState() => state;
}

class _ProductCardFormState extends State<ProductCardForm> {
  final formKey = GlobalKey<FormState>();

  var _currencies = ["S", "M", "L", "XL", "XXL"];
  String? _currentSelectedValue, pickedColor;

  final _sellingPriceController = TextEditingController();
  final _buingPriceController = TextEditingController();
  final _totalController = TextEditingController();

  bool saveForm() {
    var valid = formKey.currentState!.validate();
    if (!valid) return false;
    formKey.currentState!.save();

    widget.infoModel.size = _currentSelectedValue;
    widget.infoModel.salePrice = _sellingPriceController.text;
    widget.infoModel.purcasePrice = _buingPriceController.text;
    widget.infoModel.quantity = _totalController.text;
    widget.infoModel.color = pickedColor;

    return true;
  }

  @override
  void initState() {
    pickedColor = widget.infoModel.color;
    if (widget.infoModel.size != null)
      _currentSelectedValue = widget.infoModel.size!.toUpperCase();
    _sellingPriceController.text = widget.infoModel.salePrice ?? '';
    _buingPriceController.text = widget.infoModel.purcasePrice ?? '';
    _totalController.text = widget.infoModel.quantity ?? '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: Colors.grey.shade300,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              if (!widget.hideHeader) _cardHeader(),
              priceFields(),
              SizedBox(height: 12),
              Row(
                children: [
                  _buildQunatitiField(),
                  SizedBox(width: 8),
                  dropDown(),
                  SizedBox(width: 8),
                  buildColorField()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildColorField() {
    return Flexible(
      fit: FlexFit.tight,
      child: InkWell(
        onTap: () async {
          final color = await Utils.pickColor(context);
          if (color != null) {
            pickedColor = color;
            setState(() {});
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          height: 50,
          child: Center(
            child: Text("${pickedColor ?? 'Color'}",
                style: TextStyle(color: Colors.black)),
          ),
        ),
      ),
    );
  }

  Widget _cardHeader() {
    return Container(
      color: Colors.grey[300],
      height: 40,
      // padding: EdgeInsets.only(right: 10),
      alignment: Alignment.centerRight,
      width: double.infinity,
      child: ElevatedButton(
        style:
            ElevatedButton.styleFrom(backgroundColor: Colors.grey[300], elevation: 0),
        onPressed: widget.onAction,
        child: Icon(widget.isFirst ? Icons.add : Icons.delete,
            color: widget.isFirst ? Colors.blue : Colors.red),
      ),
    );
  }

  Widget _buildQunatitiField() {
    return Flexible(
      child: Container(
        child: TextFormField(
          validator: (s) {
            if (s == null || s.isEmpty) return 'Quantity';
            return null;
          },
          onChanged: (s) {
            widget.infoModel.quantity = s;
          },
          controller: _totalController,
          keyboardType: TextInputType.number,
          style: TextStyle(fontSize: 14),
          decoration: CommonDecorator.inputDecorator('Quantity'),
        ),
      ),
    );
  }

  Widget priceFields() {
    return Row(
      children: [
        Flexible(
          child: TextFormField(
            validator: (s) {
              if (s == null || s.isEmpty) return 'Enter Price';
              return null;
            },
            onChanged: (s) {
              widget.infoModel.salePrice = s;
            },
            controller: _sellingPriceController,
            keyboardType: TextInputType.number,
            decoration: CommonDecorator.inputDecorator('Selling Price'),
          ),
        ),
        SizedBox(width: 8),
        Flexible(
          child: TextFormField(
            validator: (s) {
              if (s == null || s.isEmpty) return 'Buy Price';
              return null;
            },
            onChanged: (s) {
              widget.infoModel.purcasePrice = s;
            },
            controller: _buingPriceController,
            keyboardType: TextInputType.number,
            decoration: CommonDecorator.inputDecorator('Buy Price'),
          ),
        ),
      ],
    );
  }

  Widget dropDown() {
    return Flexible(
      child: FormField<String>(
        builder: (FormFieldState<String> state) {
          return InputDecorator(
            decoration: InputDecoration(
                fillColor: Color(0xffF2F2F2),
                filled: true,
                labelText: 'Size',
                contentPadding: EdgeInsets.symmetric(horizontal: 4),
                errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                hintText: 'Size',
                border: OutlineInputBorder()),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _currentSelectedValue,
                isDense: true,
                onChanged: (newValue) {
                  if (newValue == null) return;
                  _currentSelectedValue = newValue;
                  state.didChange(newValue);
                },
                items: _currencies.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
