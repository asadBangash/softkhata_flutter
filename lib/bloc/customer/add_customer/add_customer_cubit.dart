import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_khata_flutter/bloc/customer/add_customer/add_customer_states.dart';
import 'package:soft_khata_flutter/data/remote/app_repository.dart';
import 'package:soft_khata_flutter/data/remote/responses/add_customer_response.dart';

class AddCustomerCubit extends Cubit<AddCustomerStates> {

  AddCustomerCubit(this._repository) : super(AddCustomerInitial());

  final AppRepository _repository;

  void addCustomer(String userId, String name, String number) async {
    emit(AddCustomerLoading());
    final Either<String, AddCustomerResponse> response = await _repository.addCustomer(userId, name, number);
    emit(response.fold((left) {
      return AddCustomerError(left);
    }, (right) {
      return AddCustomerSuccess(right);
    }));
  }
}