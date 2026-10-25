import 'package:soft_khata_flutter/data/remote/responses/user_model.dart';

class LoginResponse {
  bool _status;
  LoginResult _result;

  LoginResponse.fromJson(Map<String, dynamic> data) {
    _status = data['success'];
    _result = LoginResult.fromJson(data['result']);
  }

  bool get status => _status;
  LoginResult get result => _result;
}

class LoginResult {
  String _token;
  UserModel _user;

  LoginResult.fromJson(Map<String, dynamic> data) {
    _token = data['user_token'];
    _user = UserModel.fromJson(data['user']);
  }

  String get token => _token;
  UserModel get user => _user;
}
