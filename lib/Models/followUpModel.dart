class FollowUpModel {
  String? status;
  String? message;
  List<Data>? data;

  FollowUpModel({this.status, this.message, this.data});

  FollowUpModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
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
  int? followupTypeId;
  String? subject;
  String? phoneNumber;
  String? status;
  String? nextFollowupDate;
  String? description;
  String? isActive;
  String? createdAt;
  String? updatedAt;
  CreatorName? creatorName;
  CreatorName? assignName;
  CompanyName? companyName;
  FollowUpName? followUpName;
  FollowUpName? followUpStatus;
  List<Associate>? associates;

  Data({
    this.id,
    this.leadId,
    this.userId,
    this.creatorUserId,
    this.followupTypeId,
    this.subject,
    this.phoneNumber,
    this.status,
    this.nextFollowupDate,
    this.description,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.creatorName,
    this.assignName,
    this.companyName,
    this.followUpName,
    this.followUpStatus,
    this.associates,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    leadId = json['lead_id'];
    userId = json['user_id'];
    creatorUserId = json['creator_user_id'];
    followupTypeId = json['followup_type_id'];
    subject = json['subject'];
    phoneNumber = json['phone_number'];
    status = json['status'];
    nextFollowupDate = json['next_followup_date'];
    description = json['description'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    creatorName = json['creator_name'] != null
        ? CreatorName.fromJson(json['creator_name'])
        : null;
    assignName = json['assign_name'] != null
        ? CreatorName.fromJson(json['assign_name'])
        : null;
    companyName = json['company_name'] != null
        ? CompanyName.fromJson(json['company_name'])
        : null;
    followUpName = json['follow_up_name'] != null
        ? FollowUpName.fromJson(json['follow_up_name'])
        : null;
    followUpStatus = json['follow_up_status'] != null
        ? FollowUpName.fromJson(json['follow_up_status'])
        : null;
    if (json['associates'] != null) {
      associates = <Associate>[];
      json['associates'].forEach((v) {
        associates!.add(Associate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['lead_id'] = leadId;
    data['user_id'] = userId;
    data['creator_user_id'] = creatorUserId;
    data['followup_type_id'] = followupTypeId;
    data['subject'] = subject;
    data['phone_number'] = phoneNumber;
    data['status'] = status;
    data['next_followup_date'] = nextFollowupDate;
    data['description'] = description;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (creatorName != null) {
      data['creator_name'] = creatorName!.toJson();
    }
    if (assignName != null) {
      data['assign_name'] = assignName!.toJson();
    }
    if (companyName != null) {
      data['company_name'] = companyName!.toJson();
    }
    if (followUpName != null) {
      data['follow_up_name'] = followUpName!.toJson();
    }
    if (followUpStatus != null) {
      data['follow_up_status'] = followUpStatus!.toJson();
    }
    if (associates != null) {
      data['associates'] = associates!.map((v) => v.toJson()).toList();
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
  String? emailVerifiedAt;
  String? attachment;
  String? createdAt;
  String? updatedAt;

  CreatorName({
    this.id,
    this.name,
    this.email,
    this.designation,
    this.isActive,
    this.emailVerifiedAt,
    this.attachment,
    this.createdAt,
    this.updatedAt,
  });

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['designation'] = designation;
    data['is_active'] = isActive;
    data['email_verified_at'] = emailVerifiedAt;
    data['attachment'] = attachment;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
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
  int? districtId;
  String? name;
  String? phoneNumber;
  String? alternateNumber;
  String? email;
  String? designation;
  String? gender;
  String? companyPhone;
  String? companyEmail;
  String? companyWebsite;
  String? amount;
  String? facebookPage;
  String? facebookLike;
  String? address;
  String? remarks;
  String? isActive;
  String? isType;
  String? createdAt;
  String? updatedAt;

  CompanyName({
    this.id,
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
    this.updatedAt,
  });

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_name'] = companyName;
    data['user_id'] = userId;
    data['creator_user_id'] = creatorUserId;
    data['lead_industry_id'] = leadIndustryId;
    data['lead_source_id'] = leadSourceId;
    data['lead_pipeline_id'] = leadPipelineId;
    data['lead_priority'] = leadPriority;
    data['lead_rating_id'] = leadRatingId;
    data['lead_area_id'] = leadAreaId;
    data['district_id'] = districtId;
    data['name'] = name;
    data['phone_number'] = phoneNumber;
    data['alternate_number'] = alternateNumber;
    data['email'] = email;
    data['designation'] = designation;
    data['gender'] = gender;
    data['company_phone'] = companyPhone;
    data['company_email'] = companyEmail;
    data['company_website'] = companyWebsite;
    data['amount'] = amount;
    data['facebook_page'] = facebookPage;
    data['facebook_like'] = facebookLike;
    data['address'] = address;
    data['remarks'] = remarks;
    data['is_active'] = isActive;
    data['is_type'] = isType;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class FollowUpName {
  int? id;
  String? name;
  String? status;
  String? isActive;
  String? createdAt;
  String? updatedAt;

  FollowUpName({
    this.id,
    this.name,
    this.status,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  FollowUpName.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['status'] = status;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Associate {
  int? id;
  String? name;

  Associate({this.id, this.name});

  Associate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
