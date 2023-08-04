class LineDataModel {
  LineDataModel(this.date, this.value);
  final String date;
  final num value;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = date;
    data['value'] = value;

    return data;
  }
}
