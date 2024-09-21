class CallLogDetailsModel{

  int? id;
  String? type;
  String? date;
  String? time;
  String? duration;
  String? phoneNumber;


  CallLogDetailsModel(this.id, this.type, this.date, this.time, this.duration,
      this.phoneNumber);

  CallLogDetailsModel.fromMap(Map<String, dynamic> map){
    id = map['id'];
    type = map['type'];
    date = map['date'];
    time = map['time'];
    duration = map['duration'];
    phoneNumber = map['phone_number'];
  }

  Map<String, dynamic> toMap(){
    return {
      "id": id,
      "type": type,
      "date": date,
      "time": time,
      "duration": duration,
      "phone_number": phoneNumber,
    };
  }
}