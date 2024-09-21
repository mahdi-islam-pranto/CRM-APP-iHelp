class CallLogsModel{

  String? phoneNumber;
  String? name;
  String? type;
  String? date;
  String? time;


  CallLogsModel(this.phoneNumber, this.name, this.type, this.date, this.time);


  CallLogsModel.fromMap(Map<String, dynamic> map){
    phoneNumber = map['phone_number'];
    name = map['name'];
    type = map['type'];
    date = map['date'];
    time = map['time'];
  }

  Map<String, dynamic> toMap(){
    return {
      "phone_number": phoneNumber,
      "name": name,
      "type": type,
      "date": date,
      "time": time,
    };
  }
}