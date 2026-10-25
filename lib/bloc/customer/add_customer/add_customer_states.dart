import 'package:soft_khata_flutter/data/remote/responses/add_customer_response.dart';

abstract class AddCustomerStates  {}

class AddCustomerInitial extends AddCustomerStates {}

class AddCustomerLoading extends AddCustomerStates {}

class AddCustomerSuccess extends AddCustomerStates {
  final AddCustomerResponse response;
  AddCustomerSuccess(this.response);
}

class AddCustomerError extends AddCustomerStates {
  final String message;
  AddCustomerError(this.message);
}