import 'package:soft_khata_flutter/data/remote/responses/add_entry_response.dart';

abstract class AddEntryStates {}

class AddEntryInitial extends AddEntryStates {}

class AddEntryLoading extends AddEntryStates {}

class AddEntrySuccess extends AddEntryStates {
  final AddEntryResponse response;

  AddEntrySuccess(this.response);
}

class AddEntryError extends AddEntryStates {
  final String message;

  AddEntryError(this.message);
}