import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:soft_khata_flutter/bloc/entry/edit_entry/edit_entry_states.dart';
import 'package:soft_khata_flutter/data/remote/app_repository.dart';
import 'package:soft_khata_flutter/data/remote/responses/edit_entry_response.dart';

class EditEntryCubit extends Cubit<EditEntryStates> {
  EditEntryCubit(this.appRepository) : super(EditEntryInitial());
  AppRepository appRepository;

  void editEntry(String body) async {
    emit(EditEntryLoading());
    final Either<String, EditEntryResponse> eitherResponse = await appRepository.editEntry(body);
    emit(
      eitherResponse.fold((left) {
        return EditEntryError(left);
      }, (right) {
        return EditEntrySuccess(right);
      },),
    );
  }
}