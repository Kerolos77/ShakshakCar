import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/shared/faq/domain/entities/faqs_entity.dart';
import 'package:shakshak/features/shared/faq/domain/repositories/faqs_repo.dart';

class GetFaqsUseCase extends BaseUseCase<FaqsEntity, NoParameters> {
  final FaqsRepo faqsRepo;

  GetFaqsUseCase(this.faqsRepo);

  @override
  Future<Either<Failure, FaqsEntity>> call(NoParameters parameters) async {
    return await faqsRepo.getFaqs();
  }
}
