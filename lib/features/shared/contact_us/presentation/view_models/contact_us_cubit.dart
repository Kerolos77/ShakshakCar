import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import 'package:shakshak/features/shared/contact_us/domain/entities/contact_us_entity.dart';
import 'package:shakshak/features/shared/contact_us/domain/entities/write_us_entity.dart';
import 'package:shakshak/features/shared/contact_us/domain/usecases/get_contact_us_usecase.dart';
import 'package:shakshak/features/shared/contact_us/domain/usecases/write_us_usecase.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';

part 'contact_us_state.dart';

class ContactUsCubit extends Cubit<ContactUsState> {
  ContactUsCubit(this.getContactUsUseCase, this.writeUsUseCase) : super(ContactUsInitial());

  final GetContactUsUseCase getContactUsUseCase;
  final WriteUsUseCase writeUsUseCase;

  Future<void> getContactUs() async {
    emit(ContactUsLoading());
    var result = await getContactUsUseCase(const NoParameters());
    result.fold((error) {
      debugPrint("error while get contact us data ${error.message}");
      return emit(ContactUsFailure(errorMessage: error.message));
    }, (success) {
      return emit(ContactUsSuccess(contactUsEntity: success));
    });
  }

  Future<void> writeUs({
    required String email,
    required String description,
  }) async {
    emit(WriteUsLoading());
    var result =
        await writeUsUseCase(WriteUsParams(email: email, description: description));
    result.fold((error) {
      debugPrint("error while get write us data ${error.message}");
      return emit(WriteUsFailure(errorMessage: error.message));
    }, (success) {
      return emit(WriteUsSuccess(writeUsEntity: success));
    });
  }
}
