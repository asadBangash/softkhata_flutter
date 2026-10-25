import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:soft_khata_flutter/bloc/customer/delete_customer/delete_customer_states.dart';
import 'package:soft_khata_flutter/data/remote/app_repository.dart';
import 'package:soft_khata_flutter/data/remote/responses/generic_response.dart';

class DeleteCustomerCubit extends Cubit<DeleteCustomerStates> {
  DeleteCustomerCubit(this.appRepository) : super(DeleteCustomerInitial());
  AppRepository appRepository;

  void deleteCustomer(String customerId) async {
    emit(DeleteCustomerLoading());
    final Either<String, GenericResponse> eitherResponse = await appRepository.deleteCustomer(customerId);
    emit(
      eitherResponse.fold((left) {
        return DeleteCustomerError(left);
      }, (right) {
        return DeleteCustomerSuccess(right);
      },),
    );
  }
}