import 'package:soft_khata_flutter/data/remote/responses/generic_response.dart';

abstract class DeleteCustomerStates {}

class DeleteCustomerInitial extends DeleteCustomerStates {}

class DeleteCustomerLoading extends DeleteCustomerStates {}

class DeleteCustomerSuccess extends DeleteCustomerStates {
  final GenericResponse response;

  DeleteCustomerSuccess(this.response);
}

class DeleteCustomerError extends DeleteCustomerStates {
  final String message;

  DeleteCustomerError(this.message);
}