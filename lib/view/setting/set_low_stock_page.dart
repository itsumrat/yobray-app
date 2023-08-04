import 'package:flutter/material.dart';
import 'package:yo_bray/ulits/constant.dart';

class SetLowStockPage extends StatefulWidget {
  const SetLowStockPage({Key? key}) : super(key: key);

  @override
  _SetLowStockPageState createState() => _SetLowStockPageState();
}

class _SetLowStockPageState extends State<SetLowStockPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(title: Text('Set Low Stock'), leadingWidth: leadingWidth),
      body: ListView(
        padding: EdgeInsets.all(4),
        children: [
          singleItem(),
          singleItem(),
          singleItem(),
          singleItem(),
        ],
      ),
    );
  }

  Widget singleItem() {
    return Card(
      child: Container(
        padding: EdgeInsets.all(6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                'https://picsum.photos/id/1/400/150',
                fit: BoxFit.fill,
                height: 90,
                width: 90,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        child: Text("T-shirt",
                            style: TextStyle(color: Colors.blue, fontSize: 16)),
                      ),
                      InkWell(
                        onTap: () {
                          _showMyDialog();
                        },
                        child: Icon(Icons.arrow_forward_ios, size: 18),
                      ),
                    ],
                  ),
                  keyValueItem('Quality:', "10"),
                  keyValueItem('Date:', "20-12-2020"),
                  keyValueItem('Price:', "\$100"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget keyValueItem(String key, value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(flex: 2, fit: FlexFit.tight, child: Text(key)),
        Flexible(flex: 4, fit: FlexFit.tight, child: Text(value)),
      ],
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Set low stock')),
          content: StatefulBuilder(builder: (context, snapshot) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Text('-', style: TextStyle(fontSize: 40)),
                  ),
                  Text('10', style: TextStyle(fontSize: 18)),
                  InkWell(
                    onTap: () {},
                    child: Text('+', style: TextStyle(fontSize: 40)),
                  ),
                ],
              ),
            );
          }),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
