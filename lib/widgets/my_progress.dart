import 'package:flutter/material.dart';

class LinearProgressWithTextWidget extends StatelessWidget {
  final Color color;
  final double progress;
  LinearProgressWithTextWidget(
      {Key? key, required this.color, required this.progress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalWidth = ((MediaQuery.of(context).size.width / 2) - 40);
    return Container(
        child: Column(
      children: [
        Transform.translate(
          offset: Offset((totalWidth * 2 * progress) - totalWidth, -5),
          child: Container(
            padding: EdgeInsets.only(left: 4, right: 4, top: 4, bottom: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.0),
              color: color,
            ),
            child: Text(
              "${progress * 100}%",
              style: TextStyle(
                  fontSize: 12.0,
                  fontFamily: 'Kanit-Medium',
                  color: Colors.white,
                  height: 0.8),
            ),
          ),
        ),
        LinearProgressIndicator(
          value: 0.1,
          backgroundColor: Colors.blue,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
        ),
      ],
    ));
  }
}
