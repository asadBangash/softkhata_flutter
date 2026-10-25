import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:soft_khata_flutter/bloc/customer/get_customer/get_customer_states.dart';
import 'package:soft_khata_flutter/data/remote/app_repository.dart';
import 'package:soft_khata_flutter/data/remote/responses/get_customer_response.dart';

class GetCustomerCubit extends Cubit<GetCustomerStates> {
  GetCustomerCubit(this.appRepository) : super(GetCustomerInitial());
  AppRepository appRepository;

  void getCustomer(String userId) async {
    emit(GetCustomerLoading());
    final Either<String, GetCustomersResponse> eitherResponse = await appRepository.getCustomers(userId);
    emit(
      eitherResponse.fold((left) {
        return GetCustomerError(left);
      }, (right) {
        return GetCustomerSuccess(right);
      },),
    );
  }
}