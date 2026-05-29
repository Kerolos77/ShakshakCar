import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/shared/static_pages/domain/entities/static_pages_entity.dart';
import 'package:shakshak/features/shared/static_pages/domain/repositories/static_pages_repo.dart';

class GetStaticPagesUseCase extends BaseUseCase<StaticPagesEntity, int> {
  final StaticPagesRepo staticPagesRepo;

  GetStaticPagesUseCase(this.staticPagesRepo);

  @override
  Future<Either<Failure, StaticPagesEntity>> call(int parameters) async {
    return await staticPagesRepo.getStaticPages(id: parameters);
  }
}
