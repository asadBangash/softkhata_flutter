class EditProfileResponse {
  bool success;
  String message;
  User user;

  EditProfileResponse({this.success, this.message, this.user});

  EditProfileResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
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

  User(
      {this.sId,
        this.name,
        this.email,
        this.number,
        this.businessName,
        this.businessCategory,
        this.password,
        this.iV});

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