import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:soft_khata_flutter/bloc/entry/get_entries/get_entries_states.dart';
import 'package:soft_khata_flutter/data/remote/app_repository.dart';
import 'package:soft_khata_flutter/data/remote/responses/get_entry_response.dart';

class GetEntriesCubit extends Cubit<GetEntriesStates> {
  GetEntriesCubit(this.appRepository) : super(GetEntriesInitial());
  AppRepository appRepository;

  void getEntries(String customerId) async {
    emit(GetEntriesLoading());
    final Either<String, GetEntriesResponse> eitherResponse = await appRepository.getEntries(customerId);
    emit(
      eitherResponse.fold((left) {
        return GetEntriesError(left);
      }, (right) {
        return GetEntriesSuccess(right);
      },),
    );
  }
}