import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:yo_bray/data/model/line_data_model.dart';
import 'package:yo_bray/ulits/constant.dart';

class MyLineChart extends StatelessWidget {
  const MyLineChart(
      {Key? key,
      this.profitData = const [],
      this.sellData = const [],
      this.expenseData = const [],
      required this.isPaid})
      : super(key: key);
  final List<LineDataModel> profitData, sellData, expenseData;
  final bool isPaid;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: SfCartesianChart(
          enableAxisAnimation: true,
          // Initialize category axis
          enableSideBySideSeriesPlacement: true,
          tooltipBehavior: TooltipBehavior(enable: true),
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(minimum: 0),

          enableMultiSelection: true,

          legend: Legend(
            isVisible: true,
            orientation: LegendItemOrientation.horizontal,
            position: LegendPosition.bottom,
            iconBorderWidth: 3,
          ),

          series: <SplineSeries<LineDataModel, String>>[
            SplineSeries<LineDataModel, String>(
                dataSource: profitData,
                color: Colors.green,
                name: 'Profit',
                markerSettings: MarkerSettings(isVisible: true),
                xValueMapper: (LineDataModel sales, _) => sales.date,
                yValueMapper: (LineDataModel sales, _) => sales.value),
            SplineSeries<LineDataModel, String>(
                // Bind data source
                dataSource: sellData,
                color: kPrimary,
                name: 'Sales',
                markerSettings: MarkerSettings(isVisible: true),
                xValueMapper: (LineDataModel sales, _) => sales.date,
                yValueMapper: (LineDataModel sales, _) => sales.value),
            if (isPaid)
              SplineSeries<LineDataModel, String>(
                  // Bind data source
                  dataSource: expenseData,
                  color: Colors.red,
                  name: 'Expense',
                  markerSettings: MarkerSettings(isVisible: true),
                  xValueMapper: (LineDataModel sales, _) => sales.date,
                  yValueMapper: (LineDataModel sales, _) => sales.value),
          ],
        ),
      ),
    );
  }
}
