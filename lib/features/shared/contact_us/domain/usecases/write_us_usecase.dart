import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/shared/contact_us/domain/entities/write_us_entity.dart';
import 'package:shakshak/features/shared/contact_us/domain/repositories/contact_us_repo.dart';

class WriteUsUseCase extends BaseUseCase<WriteUsEntity, WriteUsParams> {
  final ContactUsRepo contactUsRepo;

  WriteUsUseCase(this.contactUsRepo);

  @override
  Future<Either<Failure, WriteUsEntity>> call(WriteUsParams parameters) async {
    return await contactUsRepo.writeUs(
      email: parameters.email,
      description: parameters.description,
    );
  }
}

class WriteUsParams {
  final String email;
  final String description;

  const WriteUsParams({required this.email, required this.description});
}
