import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_khata_flutter/bloc/entry/edit_entry/edit_entry_states.dart';
import 'package:soft_khata_flutter/bloc/entry/entry_details/entry_details_states.dart';
import 'package:soft_khata_flutter/data/remote/app_repository.dart';
import 'package:soft_khata_flutter/data/remote/responses/entry_details_response.dart';

class EntryDetailsCubit extends Cubit<EntryDetailsStates> {
  EntryDetailsCubit(this.appRepository) : super(EntryDetailsInitial());
  AppRepository appRepository;

  void entryDetails(String entryId) async {
    emit(EntryDetailsLoading());
    final Either<String, EntryDetailsResponse> eitherResponse = await appRepository.entryDetails(entryId);
    emit(
      eitherResponse.fold((left) {
        return EntryDetailsError(left);
      }, (right) {
        return EntryDetailsSuccess(right);
      },),
    );
  }
}