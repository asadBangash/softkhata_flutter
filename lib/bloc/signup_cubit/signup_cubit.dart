import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_khata_flutter/bloc/signup_cubit/signup_state.dart';
import 'package:soft_khata_flutter/data/remote/app_repository.dart';
import 'package:soft_khata_flutter/data/remote/responses/signup_response.dart';

class SignupCubit extends Cubit<SignupStates> {

  SignupCubit(this._repository) : super(SignupInitial());

  final AppRepository _repository;

  void signupUser(
      String name, String email,
      String password, String number,
      String businessName,
      String businessCategory,
  ) async {
    emit(SignupLoading());
    final Either<String, SignupResponse> response = await _repository.signUp(name, email, password, number, businessName, businessCategory);
    emit(response.fold((left) {
      return SignupError(left);
    }, (right) {
      return SignupSuccess(right);
    }));
  }
}