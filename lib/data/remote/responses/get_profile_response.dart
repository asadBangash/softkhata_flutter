class ProfileResponse {
  bool status;
  ProfileResult result;

  ProfileResponse({this.status, this.result});

  ProfileResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    result =
    json['result'] != null ? new ProfileResult.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class ProfileResult {
  User user;

  ProfileResult({this.user});

  ProfileResult.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  String sId;
  String name;
  String email;
  int number;
  String businessName;
  String businessCategory;
  String password;
  int iV;

  User({
    this.sId,
    this.name,
    this.email,
    this.number,
    this.businessName,
    this.businessCategory,
    this.password,
    this.iV,
  });

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    number = json['number'];
    businessName = json['businessName'];
    businessCategory = json['businessCategory'];
    password = json['password'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['number'] = this.number;
    data['businessName'] = this.businessName;
    data['businessCategory'] = this.businessCategory;
    data['password'] = this.password;
    data['__v'] = this.iV;
    return data;
  }
}