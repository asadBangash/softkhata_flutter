import 'package:soft_khata_flutter/data/remote/responses/edit_profile_response.dart';

abstract class EditProfileStates {}

class EditProfileInitial extends EditProfileStates {}

class EditProfileLoading extends EditProfileStates {}

class EditProfileSuccess extends EditProfileStates {
  final EditProfileResponse response;

  EditProfileSuccess(this.response);
}

class EditProfileError extends EditProfileStates {
  final String message;

  EditProfileError(this.message);
}