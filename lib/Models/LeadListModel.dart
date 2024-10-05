class LeadListModel {
  int id;
  String? name;
  String? phoneNumber;
  String? email;
  String? companyName;
  String? companyEmail;
  int? leadPipelineId;
  int? leadAreaId;
  int? userId;
  String? createdAt;
  String? amount;
  int? leadSourceId;
  LeadPipeline? leadPipelineName;
  dynamic leadAreasName;
  dynamic leadSourceName;
  AssignName? assignName;
  List<dynamic> associates;

  LeadListModel({
    required this.id,
    this.name,
    this.phoneNumber,
    this.email,
    this.companyName,
    this.companyEmail,
    this.leadPipelineId,
    this.leadAreaId,
    this.userId,
    this.createdAt,
    this.amount,
    this.leadSourceId,
    this.leadPipelineName,
    this.leadAreasName,
    this.leadSourceName,
    this.assignName,
    required this.associates,
  });

  factory LeadListModel.fromJson(Map<String, dynamic> json) {
    return LeadListModel(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      companyName: json['company_name'],
      companyEmail: json['company_email'],
      leadPipelineId: json['lead_pipeline_id'],
      leadAreaId: json['lead_area_id'],
      userId: json['user_id'],
      createdAt: json['created_at'],
      amount: json['amount'],
      leadSourceId: json['lead_source_id'],
      leadPipelineName: json['lead_pipeline_name'] != null
          ? LeadPipeline.fromJson(json['lead_pipeline_name'])
          : null,
      leadAreasName: json['lead_areas_name'],
      leadSourceName: json['lead_source_name'],
      assignName: json['assign_name'] != null
          ? AssignName.fromJson(json['assign_name'])
          : null,
      associates: json['associates'] ?? [],
    );
  }
}

class LeadPipeline {
  int id;
  String name;
  String sla;
  int orderNo;
  String isActive;
  String isDelete;
  String createdAt;
  String updatedAt;

  LeadPipeline({
    required this.id,
    required this.name,
    required this.sla,
    required this.orderNo,
    required this.isActive,
    required this.isDelete,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LeadPipeline.fromJson(Map<String, dynamic> json) {
    return LeadPipeline(
      id: json['id'],
      name: json['name'],
      sla: json['sla'],
      orderNo: json['order_no'],
      isActive: json['is_active'],
      isDelete: json['is_delete'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class AssignName {
  int id;
  String name;
  String email;
  String designation;
  String isActive;
  dynamic emailVerifiedAt;
  String attachment;
  String createdAt;
  String updatedAt;

  AssignName({
    required this.id,
    required this.name,
    required this.email,
    required this.designation,
    required this.isActive,
    this.emailVerifiedAt,
    required this.attachment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AssignName.fromJson(Map<String, dynamic> json) {
    return AssignName(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      designation: json['designation'],
      isActive: json['is_active'],
      emailVerifiedAt: json['email_verified_at'],
      attachment: json['attachment'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
