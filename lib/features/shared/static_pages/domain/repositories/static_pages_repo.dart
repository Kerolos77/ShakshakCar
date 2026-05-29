import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/features/shared/static_pages/domain/entities/static_pages_entity.dart';

abstract class StaticPagesRepo {
  Future<Either<Failure, StaticPagesEntity>> getStaticPages({required int id});
}
