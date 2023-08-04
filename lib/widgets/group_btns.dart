import 'package:flutter/material.dart';
import 'package:yo_bray/ulits/constant.dart';

class GroupBtns extends StatefulWidget {
  const GroupBtns({Key? key, required this.onTap}) : super(key: key);
  final void Function(int) onTap;

  @override
  _GroupBtnsState createState() => _GroupBtnsState();
}

class _GroupBtnsState extends State<GroupBtns> {
  List<bool> isSelected = [true, false];
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 3,
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  isSelected = isSelected.map((e) => false).toList();
                  isSelected[0] = true;
                  setState(() {});
                  widget.onTap(0);
                },
                child: Container(
                  color: isSelected[0] ? kPrimary : Colors.white,
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'Schedule',
                      style: TextStyle(
                          fontSize: 16,
                          color: isSelected[0] ? Colors.white : Colors.black),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  isSelected = isSelected.map((e) => false).toList();
                  isSelected[1] = true;
                  setState(() {});
                  widget.onTap(1);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected[1] ? kPrimary : Colors.grey.shade300,
                    border: Border(left: BorderSide(color: Colors.grey)),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'Saved',
                      style: TextStyle(
                          fontSize: 16,
                          color: isSelected[1] ? Colors.white : Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
