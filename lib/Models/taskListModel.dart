class TaskListModel {
  String? status;
  String? message;
  List<Data>? data;

  TaskListModel({this.status, this.message, this.data});

  TaskListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? leadId;
  int? userId;
  int? creatorUserId;
  int? taskTypeId;
  String? subject;
  String? startTime;
  String? endTime;
  int? reminderTime;
  String? description;
  String? status;
  String? isActive;
  String? createdAt;
  String? updatedAt;
  CreatorName? creatorName;
  CompanyName? companyName;
  CreatorName? assignName;
  TaskName? taskName;
  TaskName? taskStatus;
  List<Associates>? associates;

  Data(
      {this.id,
      this.leadId,
      this.userId,
      this.creatorUserId,
      this.taskTypeId,
      this.subject,
      this.startTime,
      this.endTime,
      this.reminderTime,
      this.description,
      this.status,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.creatorName,
      this.companyName,
      this.assignName,
      this.taskName,
      this.taskStatus,
      this.associates});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    leadId = json['lead_id'];
    userId = json['user_id'];
    creatorUserId = json['creator_user_id'];
    taskTypeId = json['task_type_id'];
    subject = json['subject'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    reminderTime = json['reminder_time'];
    description = json['description'];
    status = json['status'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    creatorName = json['creator_name'] != null
        ? new CreatorName.fromJson(json['creator_name'])
        : null;
    companyName = json['company_name'] != null
        ? new CompanyName.fromJson(json['company_name'])
        : null;
    assignName = json['assign_name'] != null
        ? new CreatorName.fromJson(json['assign_name'])
        : null;
    taskName = json['task_name'] != null
        ? new TaskName.fromJson(json['task_name'])
        : null;
    taskStatus = json['task_status'] != null
        ? new TaskName.fromJson(json['task_status'])
        : null;
    if (json['associates'] != null) {
      associates = <Associates>[];
      json['associates'].forEach((v) {
        associates!.add(new Associates.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lead_id'] = this.leadId;
    data['user_id'] = this.userId;
    data['creator_user_id'] = this.creatorUserId;
    data['task_type_id'] = this.taskTypeId;
    data['subject'] = this.subject;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['reminder_time'] = this.reminderTime;
    data['description'] = this.description;
    data['status'] = this.status;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.creatorName != null) {
      data['creator_name'] = this.creatorName!.toJson();
    }
    if (this.companyName != null) {
      data['company_name'] = this.companyName!.toJson();
    }
    if (this.assignName != null) {
      data['assign_name'] = this.assignName!.toJson();
    }
    if (this.taskName != null) {
      data['task_name'] = this.taskName!.toJson();
    }
    if (this.taskStatus != null) {
      data['task_status'] = this.taskStatus!.toJson();
    }
    if (this.associates != null) {
      data['associates'] = this.associates!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CreatorName {
  int? id;
  String? name;
  String? email;
  String? designation;
  String? isActive;
  Null? emailVerifiedAt;
  String? attachment;
  String? createdAt;
  String? updatedAt;

  CreatorName(
      {this.id,
      this.name,
      this.email,
      this.designation,
      this.isActive,
      this.emailVerifiedAt,
      this.attachment,
      this.createdAt,
      this.updatedAt});

  CreatorName.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    designation = json['designation'];
    isActive = json['is_active'];
    emailVerifiedAt = json['email_verified_at'];
    attachment = json['attachment'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['designation'] = this.designation;
    data['is_active'] = this.isActive;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['attachment'] = this.attachment;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class CompanyName {
  int? id;
  String? companyName;
  int? userId;
  int? creatorUserId;
  int? leadIndustryId;
  int? leadSourceId;
  int? leadPipelineId;
  String? leadPriority;
  int? leadRatingId;
  int? leadAreaId;
  Null? districtId;
  String? name;
  String? phoneNumber;
  Null? alternateNumber;
  String? email;
  Null? designation;
  Null? gender;
  Null? companyPhone;
  Null? companyEmail;
  Null? companyWebsite;
  Null? amount;
  Null? facebookPage;
  Null? facebookLike;
  Null? address;
  Null? remarks;
  String? isActive;
  String? isType;
  String? createdAt;
  String? updatedAt;

  CompanyName(
      {this.id,
      this.companyName,
      this.userId,
      this.creatorUserId,
      this.leadIndustryId,
      this.leadSourceId,
      this.leadPipelineId,
      this.leadPriority,
      this.leadRatingId,
      this.leadAreaId,
      this.districtId,
      this.name,
      this.phoneNumber,
      this.alternateNumber,
      this.email,
      this.designation,
      this.gender,
      this.companyPhone,
      this.companyEmail,
      this.companyWebsite,
      this.amount,
      this.facebookPage,
      this.facebookLike,
      this.address,
      this.remarks,
      this.isActive,
      this.isType,
      this.createdAt,
      this.updatedAt});

  CompanyName.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['company_name'];
    userId = json['user_id'];
    creatorUserId = json['creator_user_id'];
    leadIndustryId = json['lead_industry_id'];
    leadSourceId = json['lead_source_id'];
    leadPipelineId = json['lead_pipeline_id'];
    leadPriority = json['lead_priority'];
    leadRatingId = json['lead_rating_id'];
    leadAreaId = json['lead_area_id'];
    districtId = json['district_id'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    alternateNumber = json['alternate_number'];
    email = json['email'];
    designation = json['designation'];
    gender = json['gender'];
    companyPhone = json['company_phone'];
    companyEmail = json['company_email'];
    companyWebsite = json['company_website'];
    amount = json['amount'];
    facebookPage = json['facebook_page'];
    facebookLike = json['facebook_like'];
    address = json['address'];
    remarks = json['remarks'];
    isActive = json['is_active'];
    isType = json['is_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_name'] = this.companyName;
    data['user_id'] = this.userId;
    data['creator_user_id'] = this.creatorUserId;
    data['lead_industry_id'] = this.leadIndustryId;
    data['lead_source_id'] = this.leadSourceId;
    data['lead_pipeline_id'] = this.leadPipelineId;
    data['lead_priority'] = this.leadPriority;
    data['lead_rating_id'] = this.leadRatingId;
    data['lead_area_id'] = this.leadAreaId;
    data['district_id'] = this.districtId;
    data['name'] = this.name;
    data['phone_number'] = this.phoneNumber;
    data['alternate_number'] = this.alternateNumber;
    data['email'] = this.email;
    data['designation'] = this.designation;
    data['gender'] = this.gender;
    data['company_phone'] = this.companyPhone;
    data['company_email'] = this.companyEmail;
    data['company_website'] = this.companyWebsite;
    data['amount'] = this.amount;
    data['facebook_page'] = this.facebookPage;
    data['facebook_like'] = this.facebookLike;
    data['address'] = this.address;
    data['remarks'] = this.remarks;
    data['is_active'] = this.isActive;
    data['is_type'] = this.isType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class TaskName {
  int? id;
  String? name;
  String? isActive;
  String? isDelete;
  String? createdAt;
  String? updatedAt;

  TaskName(
      {this.id,
      this.name,
      this.isActive,
      this.isDelete,
      this.createdAt,
      this.updatedAt});

  TaskName.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['is_active'];
    isDelete = json['is_delete'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['is_active'] = this.isActive;
    data['is_delete'] = this.isDelete;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Associates {
  int? id;
  String? name;
  String? email;
  String? designation;
  String? isActive;
  Null? emailVerifiedAt;
  String? attachment;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  Associates(
      {this.id,
      this.name,
      this.email,
      this.designation,
      this.isActive,
      this.emailVerifiedAt,
      this.attachment,
      this.createdAt,
      this.updatedAt,
      this.pivot});

  Associates.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    designation = json['designation'];
    isActive = json['is_active'];
    emailVerifiedAt = json['email_verified_at'];
    attachment = json['attachment'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['designation'] = this.designation;
    data['is_active'] = this.isActive;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['attachment'] = this.attachment;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    return data;
  }
}

class Pivot {
  int? associatableId;
  int? userId;
  String? associatableType;

  Pivot({this.associatableId, this.userId, this.associatableType});

  Pivot.fromJson(Map<String, dynamic> json) {
    associatableId = json['associatable_id'];
    userId = json['user_id'];
    associatableType = json['associatable_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['associatable_id'] = this.associatableId;
    data['user_id'] = this.userId;
    data['associatable_type'] = this.associatableType;
    return data;
  }
}
