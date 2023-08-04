import 'package:flutter/material.dart';

class CarousolSlider extends StatefulWidget {
  const CarousolSlider({Key? key}) : super(key: key);

  @override
  _CarousolSliderState createState() => _CarousolSliderState();
}

class _CarousolSliderState extends State<CarousolSlider> {
  int slideIndex = 0;
  PageController? controller;

  Widget _buildPageIndicator(bool isCurrentPage) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 10.0 : 6.0,
      width: isCurrentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? Colors.grey : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  List captionList = [
    'Flexible pricing in sales',
    'Low stock notification',
    'Add photo and video in job',
    'Saved Jobs',
    'Manage expenses',
    'Product & job stats'
  ];
  Widget? captionText() {
    return Container(
        child: Text(
      captionList[slideIndex],
      style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              gradient: LinearGradient(
                  colors: [const Color(0xFFE0E0E0), const Color(0xFFE0E0E0)])),
          child: PageView(
            controller: controller,
            onPageChanged: (index) {
              setState(() {
                slideIndex = index;
              });
            },
            children: [
              Image.asset('assets/pic1.png'),
              Image.asset('assets/pic2.png'),
              Image.asset('assets/pic3new.png'),
              Image.asset('assets/pic4new.png'),
              Image.asset('assets/pic6new.png'),
              Image.asset('assets/pic5new.jpeg'),
            ],
          ),
        ),
        SizedBox(height: 10),
        captionText()!,
        SizedBox(height: 10),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < 4; i++)
                i == slideIndex
                    ? _buildPageIndicator(true)
                    : _buildPageIndicator(false),
            ],
          ),
        ),
      ],
    );
  }
}

class SlideTile extends StatelessWidget {
  final String? imagePath, title, desc;

  SlideTile({this.imagePath, this.title, this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(imagePath!),
          SizedBox(
            height: 40,
          ),
          Text(
            title!,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
          ),
          SizedBox(
            height: 20,
          ),
          Text(desc!,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14))
        ],
      ),
    );
  }
}
