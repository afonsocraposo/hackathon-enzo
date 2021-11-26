import 'package:charts_common/common.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<DateTime> x;
  final List<num?> y;
  final bool zeroBound;

  const Chart(this.x, this.y, {this.zeroBound = true, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _series = [
      charts.Series<int, DateTime>(
        id: 'Values',
        colorFn: (_, __) => charts.Color.fromHex(code: "#EF4B59"),
        domainFn: (int index, _) => x[index],
        measureFn: (int index, _) => (index < y.length) ? y[index] : null,
        data: List.generate(x.length, (index) => index),
      ),
    ];
    return charts.TimeSeriesChart(
      _series,
      defaultRenderer: LineRendererConfig(includeArea: false, strokeWidthPx: 2),
      animate: false,
      primaryMeasureAxis: const charts.NumericAxisSpec(
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
          zeroBound: false,
        ),
        //renderSpec: NoneRenderSpec(),
        showAxisLine: false,
      ),
      domainAxis: DateTimeAxisSpec(
        showAxisLine: false,
        tickProviderSpec: const DateTimeEndPointsTickProviderSpec(),
        tickFormatterSpec:
            BasicDateTimeTickFormatterSpec.fromDateFormat(DateFormat.Hms()),
        renderSpec: NoneRenderSpec(),
      ),
      layoutConfig: charts.LayoutConfig(
          leftMarginSpec: MarginSpec.fixedPixel(0),
          rightMarginSpec: MarginSpec.fixedPixel(0),
          topMarginSpec: MarginSpec.fixedPixel(0),
          bottomMarginSpec: MarginSpec.fixedPixel(0)),
    );
  }
}

class SensorValue {
  final DateTime time;
  final double value;

  SensorValue(this.time, this.value);
}
