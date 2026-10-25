import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_khata_flutter/bloc/customer/edit_customer/edit_customer_states.dart';
import 'package:soft_khata_flutter/data/remote/app_repository.dart';
import 'package:soft_khata_flutter/data/remote/responses/edit_customer_response.dart';

class EditCustomerCubit extends Cubit<EditCustomerStates> {
  EditCustomerCubit(this.appRepository) : super(EditCustomerInitial());
  AppRepository appRepository;

  void editCustomer(String body) async {
    emit(EditCustomerLoading());
    final Either<String, EditCustomerResponse> eitherResponse = await appRepository.editCustomers(body);
    emit(
      eitherResponse.fold((left) {
        return EditCustomerError(left);
      }, (right) {
        return EditCustomerSuccess(right);
      },),
    );
  }
}