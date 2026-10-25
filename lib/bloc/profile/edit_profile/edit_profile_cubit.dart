import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_khata_flutter/bloc/profile/edit_profile/edit_profile_states.dart';
import 'package:soft_khata_flutter/data/remote/app_repository.dart';
import 'package:soft_khata_flutter/data/remote/responses/edit_profile_response.dart';

class EditProfileCubit extends Cubit<EditProfileStates> {
  EditProfileCubit(this.appRepository) : super(EditProfileInitial());
  AppRepository appRepository;

  void getProfile(String body) async {
    emit(EditProfileLoading());
    final Either<String, EditProfileResponse> eitherResponse = await appRepository.updateProfile(body);
    emit(
      eitherResponse.fold((left) {
        return EditProfileError(left);
      }, (right) {
        return EditProfileSuccess(right);
      },),
    );
  }
}