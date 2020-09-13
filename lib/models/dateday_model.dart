class DateDayModel {
  String dateDay;
  String hour;
  String booked;

  DateDayModel({this.dateDay, this.hour, this.booked});

  DateDayModel.fromJson(Map<String, dynamic> json) {
    dateDay = json['DateDay'];
    hour = json['Hour'];
    booked = json['Booked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DateDay'] = this.dateDay;
    data['Hour'] = this.hour;
    data['Booked'] = this.booked;
    return data;
  }
}

