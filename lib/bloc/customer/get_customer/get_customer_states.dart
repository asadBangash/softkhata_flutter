import 'package:soft_khata_flutter/data/remote/responses/get_customer_response.dart';

abstract class GetCustomerStates {}

class GetCustomerInitial extends GetCustomerStates {}

class GetCustomerLoading extends GetCustomerStates {}

class GetCustomerSuccess extends GetCustomerStates {
  final GetCustomersResponse response;

  GetCustomerSuccess(this.response);
}

class GetCustomerError extends GetCustomerStates {
  final String message;

  GetCustomerError(this.message);
}