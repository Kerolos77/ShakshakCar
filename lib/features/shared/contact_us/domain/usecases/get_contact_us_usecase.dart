import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/shared/contact_us/domain/entities/contact_us_entity.dart';
import 'package:shakshak/features/shared/contact_us/domain/repositories/contact_us_repo.dart';

class GetContactUsUseCase extends BaseUseCase<ContactUsEntity, NoParameters> {
  final ContactUsRepo contactUsRepo;

  GetContactUsUseCase(this.contactUsRepo);

  @override
  Future<Either<Failure, ContactUsEntity>> call(NoParameters parameters) async {
    return await contactUsRepo.getContactUs();
  }
}
