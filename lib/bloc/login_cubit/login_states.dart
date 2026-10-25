import 'package:soft_khata_flutter/data/remote/responses/login_response.dart';

abstract class LoginStates  {}

class LoginInitial extends LoginStates {}

class LoginLoading extends LoginStates {}

class LoginSuccess extends LoginStates {
  final LoginResponse response;
  LoginSuccess(this.response);
}

class LoginError extends LoginStates {
  final String message;
  LoginError(this.message);
}