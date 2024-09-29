class LeadListModel {
  int id;
  String? phoneNumber;
  String? companyName;
  LeadPipeline? leadPipelineName;
  AssignName? assignName;
  String? email;

  LeadListModel({
    required this.id,
    this.phoneNumber,
    this.companyName,
    this.leadPipelineName,
    this.assignName,
    this.email,
  });

  factory LeadListModel.fromJson(Map<String, dynamic> json) {
    return LeadListModel(
      id: json['id'],
      phoneNumber: json['phone_number'],
      companyName: json['company_name'],
      email: json['email'],
      leadPipelineName: json['lead_pipeline_name'] != null
          ? LeadPipeline.fromJson(json['lead_pipeline_name'])
          : null,
      assignName: json['assign_name'] != null
          ? AssignName.fromJson(json['assign_name'])
          : null,
    );
  }
}

class LeadPipeline {
  int id;
  String name;

  LeadPipeline({required this.id, required this.name});

  factory LeadPipeline.fromJson(Map<String, dynamic> json) {
    return LeadPipeline(
      id: json['id'],
      name: json['name'],
    );
  }
}

class AssignName {
  int id;
  String name;

  AssignName({required this.id, required this.name});

  factory AssignName.fromJson(Map<String, dynamic> json) {
    return AssignName(
      id: json['id'],
      name: json['name'],
    );
  }
}
