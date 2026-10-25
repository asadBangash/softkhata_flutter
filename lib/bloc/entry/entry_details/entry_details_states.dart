import 'package:soft_khata_flutter/data/remote/responses/entry_details_response.dart';

abstract class EntryDetailsStates {}

class EntryDetailsInitial extends EntryDetailsStates {}

class EntryDetailsLoading extends EntryDetailsStates {}

class EntryDetailsSuccess extends EntryDetailsStates {
  final EntryDetailsResponse response;

  EntryDetailsSuccess(this.response);
}

class EntryDetailsError extends EntryDetailsStates {
  final String message;

  EntryDetailsError(this.message);
}