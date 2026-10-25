import 'package:soft_khata_flutter/data/remote/responses/get_profile_response.dart';

abstract class GetProfileStates {}

class GetProfileInitial extends GetProfileStates {}

class GetProfileLoading extends GetProfileStates {}

class GetProfileSuccess extends GetProfileStates {
  final ProfileResponse response;

  GetProfileSuccess(this.response);
}

class GetProfileError extends GetProfileStates {
  final String message;

  GetProfileError(this.message);
}