import 'package:soft_khata_flutter/data/remote/responses/get_entry_response.dart';

abstract class GetEntriesStates {}

class GetEntriesInitial extends GetEntriesStates {}

class GetEntriesLoading extends GetEntriesStates {}

class GetEntriesSuccess extends GetEntriesStates {
  final GetEntriesResponse response;

  GetEntriesSuccess(this.response);
}

class GetEntriesError extends GetEntriesStates {
  final String message;

  GetEntriesError(this.message);
}