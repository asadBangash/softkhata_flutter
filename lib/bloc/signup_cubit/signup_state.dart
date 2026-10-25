import 'package:soft_khata_flutter/data/remote/responses/signup_response.dart';

abstract class SignupStates  {}

class SignupInitial extends SignupStates {}

class SignupLoading extends SignupStates {}

class SignupSuccess extends SignupStates {
  final SignupResponse response;
  SignupSuccess(this.response);
}

class SignupError extends SignupStates {
  final String message;
  SignupError(this.message);
}