// import 'dart:convert';

// UserInfoModel userInfoModelFromJson(String str) =>
//     UserInfoModel.fromJson(json.decode(str));

// String userInfoModelToJson(UserInfoModel data) => json.encode(data.toJson());

// class UserInfoModel {
//   UserInfoModel({
//     required this.token,
//     required this.userinfo,
//   });

//   String token;
//   Userinfo userinfo;

//   factory UserInfoModel.fromJson(Map<String, dynamic> json) => UserInfoModel(
//         token: json["token"],
//         userinfo: Userinfo.fromJson(json["userinfo"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "token": token,
//         "userinfo": userinfo.toJson(),
//       };
// }

// class Userinfo {
//   Userinfo({
//     this.id,
//     this.name,
//     this.email,
//     this.uniqueId,
//     this.userType,
//     this.referredBy,
//     this.referralCode,
//     // this.username,
//     this.profilePic,
//     this.address,
//     this.exprieredDate,
//     this.renewDate,
//     this.createdAt,
//     this.updatedAt,
//   });

//   int? id;
//   String? name;
//   String? email;
//   String? uniqueId;
//   int? userType;
//   String? referralCode;
//   String? referredBy;
//   String? profilePic;
//   String? address;
//   String? exprieredDate;
//   String? renewDate;
//   String? createdAt;
//   String? updatedAt;

//   factory Userinfo.fromJson(Map<String, dynamic> json) => Userinfo(
//         id: json["id"],
//         name: json["name"],
//         email: json["email"],
//         uniqueId: json["unique_id"],
//         userType: json["user_type"] ?? '',
//         referredBy: json["referred_by"] ?? '',
//         referralCode: json["referral_code"] ?? '',
//         profilePic: json["profile_pic"] ?? '',
//         address: json["address"] ?? '',
//         exprieredDate: json["expriered_date"],
//         renewDate: json["renew_date"],
//         createdAt: json["created_at"],
//         updatedAt: json["updated_at"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "email": email,
//         "unique_id": uniqueId,
//         "user_type": userType,
//         "referred_by": referredBy,
//         "referral_code": referralCode,
//         "profile_pic": profilePic,
//         "address": address,
//         "expriered_date": exprieredDate,
//         "renew_date": renewDate,
//         "created_at": createdAt,
//         "updated_at": updatedAt,
//       };
// }

import 'dart:convert';

UserInfoModel userInfoModelFromJson(String str) =>
    UserInfoModel.fromJson(json.decode(str));

String userInfoModelToJson(UserInfoModel data) => json.encode(data.toJson());

class UserInfoModel {
  UserInfoModel({
    required this.token,
    required this.userinfo,
  });

  String token;
  Userinfo userinfo;

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => UserInfoModel(
        token: json["token"],
        userinfo: Userinfo.fromJson(json["userinfo"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "userinfo": userinfo.toJson(),
      };
}

class Userinfo {
  Userinfo({
    this.id,
    this.name,
    this.email,
    this.uniqueId,
    this.userType,
    this.referredBy,
    this.referralCode,
    this.username,
    this.profilePic,
    this.address,
    this.exprieredDate,
    this.renewDate,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  String? email;
  String? uniqueId;
  String? userType;
  String? referralCode;
  String? referredBy;
  String? username;
  String? profilePic;
  String? address;
  String? exprieredDate;
  String? renewDate;
  String? createdAt;
  String? updatedAt;

  factory Userinfo.fromJson(Map<String, dynamic> json) => Userinfo(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        uniqueId: json["unique_id"],
        userType: json["user_type"] ?? '',
        referredBy: json["referred_by"] ?? '',
        referralCode: json["referral_code"] ?? '',
        username: json["username"] ?? '',
        profilePic: json["profile_pic"] ?? '',
        address: json["address"] ?? '',
        exprieredDate: json["expriered_date"],
        renewDate: json["renew_date"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "unique_id": uniqueId,
        "user_type": userType,
        "referred_by": referredBy,
        "referral_code": referralCode,
        "username": username,
        "profile_pic": profilePic,
        "address": address,
        "expriered_date": exprieredDate,
        "renew_date": renewDate,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
