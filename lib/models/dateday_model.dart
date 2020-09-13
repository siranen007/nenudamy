class DateDayModel {
  String dateDay;
  String hour;
  String booked;
  bool confirmed;

  DateDayModel({this.dateDay, this.hour, this.booked, this.confirmed});

  DateDayModel.fromJson(Map<String, dynamic> json) {
    dateDay = json['DateDay'];
    hour = json['Hour'];
    booked = json['Booked'];
    confirmed = json['Confirmed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DateDay'] = this.dateDay;
    data['Hour'] = this.hour;
    data['Booked'] = this.booked;
    data['Confirmed'] = this.confirmed;
    return data;
  }
}

