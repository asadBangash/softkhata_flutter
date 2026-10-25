import 'package:soft_khata_flutter/data/remote/responses/delete_entry_response.dart';

abstract class DeleteEntryStates {}

class DeleteEntryInitial extends DeleteEntryStates {}

class DeleteEntryLoading extends DeleteEntryStates {}

class DeleteEntrySuccess extends DeleteEntryStates {
  final DeleteEntryResponse response;

  DeleteEntrySuccess(this.response);
}

class DeleteEntryError extends DeleteEntryStates {
  final String message;

  DeleteEntryError(this.message);
}