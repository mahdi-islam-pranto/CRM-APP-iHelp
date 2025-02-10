
class ContactsModel {

  String? id;
  String? clientName;
  String? phoneNumber;
  String? companyName;

  ContactsModel(this.id, this.clientName, this.phoneNumber,this.companyName);


  ContactsModel.fromMap(Map<String, dynamic> map){
    id = map['id'];
    clientName = map['customer_name'];
    phoneNumber = map['phone_number'];
    companyName = map['company'];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "customer_name": clientName,
      "phone_number": phoneNumber,
      "company": companyName,
    };
  }
}