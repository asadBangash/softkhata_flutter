import 'package:soft_khata_flutter/data/remote/responses/edit_entry_response.dart';

abstract class EditEntryStates {}

class EditEntryInitial extends EditEntryStates {}

class EditEntryLoading extends EditEntryStates {}

class EditEntrySuccess extends EditEntryStates {
  final EditEntryResponse response;

  EditEntrySuccess(this.response);
}

class EditEntryError extends EditEntryStates {
  final String message;

  EditEntryError(this.message);
}