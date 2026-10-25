import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:soft_khata_flutter/bloc/entry/add_entry/add_entry_state.dart';
import 'package:soft_khata_flutter/data/remote/app_repository.dart';
import 'package:soft_khata_flutter/data/remote/responses/add_entry_response.dart';

class AddEntryCubit extends Cubit<AddEntryStates> {
  AddEntryCubit(this.appRepository) : super(AddEntryInitial());
  AppRepository appRepository;

  void addEntry(String body) async {
    emit(AddEntryLoading());
    final Either<String, AddEntryResponse> eitherResponse = await appRepository.addEntry(body);
    emit(
      eitherResponse.fold((left) {
        return AddEntryError(left);
      }, (right) {
        return AddEntrySuccess(right);
      },),
    );
  }
}