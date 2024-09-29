class FollowUpModel {
  FollowUpModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final String? status;
  final String? message;
  final List<Datum> data;

  factory FollowUpModel.fromJson(Map<String, dynamic> json) {
    return FollowUpModel(
      status: json["status"],
      message: json["message"],
      data: json["data"] == null
          ? []
          : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }
}

class Datum {
  Datum({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.companyName,
    required this.companyEmail,
    required this.leadPipelineId,
    required this.leadAreaId,
    required this.userId,
    required this.createdAt,
    required this.amount,
    required this.leadSourceId,
    required this.leadPipelineName,
    required this.leadAreasName,
    required this.leadSourceName,
    required this.assignName,
    required this.associates,
  });

  final int? id;
  final String? name;
  final String? phoneNumber;
  final String? email;
  final String? companyName;
  final dynamic companyEmail;
  final int? leadPipelineId;
  final int? leadAreaId;
  final int? userId;
  final DateTime? createdAt;
  final dynamic amount;
  final int? leadSourceId;
  final LeadName? leadPipelineName;
  final LeadName? leadAreasName;
  final LeadName? leadSourceName;
  final AssignName? assignName;
  final List<dynamic> associates;

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      id: json["id"],
      name: json["name"],
      phoneNumber: json["phone_number"],
      email: json["email"],
      companyName: json["company_name"],
      companyEmail: json["company_email"],
      leadPipelineId: json["lead_pipeline_id"],
      leadAreaId: json["lead_area_id"],
      userId: json["user_id"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      amount: json["amount"],
      leadSourceId: json["lead_source_id"],
      leadPipelineName: json["lead_pipeline_name"] == null
          ? null
          : LeadName.fromJson(json["lead_pipeline_name"]),
      leadAreasName: json["lead_areas_name"] == null
          ? null
          : LeadName.fromJson(json["lead_areas_name"]),
      leadSourceName: json["lead_source_name"] == null
          ? null
          : LeadName.fromJson(json["lead_source_name"]),
      assignName: json["assign_name"] == null
          ? null
          : AssignName.fromJson(json["assign_name"]),
      associates: json["associates"] == null
          ? []
          : List<dynamic>.from(json["associates"]!.map((x) => x)),
    );
  }
}

class AssignName {
  AssignName({
    required this.id,
    required this.name,
    required this.email,
    required this.designation,
    required this.isActive,
    required this.emailVerifiedAt,
    required this.attachment,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String? name;
  final String? email;
  final String? designation;
  final String? isActive;
  final dynamic emailVerifiedAt;
  final String? attachment;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory AssignName.fromJson(Map<String, dynamic> json) {
    return AssignName(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      designation: json["designation"],
      isActive: json["is_active"],
      emailVerifiedAt: json["email_verified_at"],
      attachment: json["attachment"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }
}

class LeadName {
  LeadName({
    required this.id,
    required this.name,
    required this.isActive,
    required this.isDelete,
    required this.createdAt,
    required this.updatedAt,
    required this.sla,
    required this.orderNo,
  });

  final int? id;
  final String? name;
  final String? isActive;
  final String? isDelete;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? sla;
  final int? orderNo;

  factory LeadName.fromJson(Map<String, dynamic> json) {
    return LeadName(
      id: json["id"],
      name: json["name"],
      isActive: json["is_active"],
      isDelete: json["is_delete"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      sla: json["sla"],
      orderNo: json["order_no"],
    );
  }
}
