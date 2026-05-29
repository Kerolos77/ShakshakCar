import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/features/shared/faq/domain/entities/faqs_entity.dart';

abstract class FaqsRepo {
  Future<Either<Failure, FaqsEntity>> getFaqs();
}
