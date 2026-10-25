import 'package:soft_khata_flutter/data/remote/responses/edit_customer_response.dart';

abstract class EditCustomerStates {}

class EditCustomerInitial extends EditCustomerStates {}

class EditCustomerLoading extends EditCustomerStates {}

class EditCustomerSuccess extends EditCustomerStates {
  final EditCustomerResponse response;

  EditCustomerSuccess(this.response);
}

class EditCustomerError extends EditCustomerStates {
  final String message;

  EditCustomerError(this.message);
}