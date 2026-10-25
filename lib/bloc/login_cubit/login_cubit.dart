import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_khata_flutter/bloc/login_cubit/login_states.dart';
import 'package:soft_khata_flutter/data/remote/app_repository.dart';
import 'package:soft_khata_flutter/data/remote/responses/login_response.dart';

class LoginCubit extends Cubit<LoginStates> {

  LoginCubit(this._repository) : super(LoginInitial());

  final AppRepository _repository;

  void loginUser(String email, String password) async {
    emit(LoginLoading());
    final Either<String, LoginResponse> response = await _repository.login(email, password);
    emit(response.fold((left) {
      return LoginError(left);
    }, (right) {
      return LoginSuccess(right);
    }));
  }
}