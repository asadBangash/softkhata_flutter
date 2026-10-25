import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:soft_khata_flutter/bloc/entry/delete_entry/delete_entry_states.dart';
import 'package:soft_khata_flutter/data/remote/app_repository.dart';
import 'package:soft_khata_flutter/data/remote/responses/delete_entry_response.dart';

class DeleteEntryCubit extends Cubit<DeleteEntryStates> {
  DeleteEntryCubit(this.appRepository) : super(DeleteEntryInitial());
  AppRepository appRepository;

  void deleteEntry(String entryId) async {
    emit(DeleteEntryLoading());
    final Either<String, DeleteEntryResponse> eitherResponse = await appRepository.deleteEntry(entryId);
    emit(
      eitherResponse.fold((left) {
        return DeleteEntryError(left);
      }, (right) {
        return DeleteEntrySuccess(right);
      },),
    );
  }
}