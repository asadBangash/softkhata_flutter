import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:soft_khata_flutter/bloc/profile/get_profile/get_profile_states.dart';
import 'package:soft_khata_flutter/data/remote/app_repository.dart';
import 'package:soft_khata_flutter/data/remote/responses/get_profile_response.dart';

class GetProfileCubit extends Cubit<GetProfileStates> {
  GetProfileCubit(this.appRepository) : super(GetProfileInitial());
  AppRepository appRepository;

  void getProfile(String userId) async {
    emit(GetProfileLoading());
    final Either<String, ProfileResponse> eitherResponse = await appRepository.getProfile(userId);
    emit(
      eitherResponse.fold((left) {
        return GetProfileError(left);
      }, (right) {
        return GetProfileSuccess(right);
      },),
    );
  }
}