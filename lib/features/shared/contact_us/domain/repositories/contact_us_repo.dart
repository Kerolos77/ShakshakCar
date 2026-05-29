import 'package:dartz/dartz.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/features/shared/contact_us/domain/entities/contact_us_entity.dart';
import 'package:shakshak/features/shared/contact_us/domain/entities/write_us_entity.dart';

abstract class ContactUsRepo {
  Future<Either<Failure, ContactUsEntity>> getContactUs();

  Future<Either<Failure, WriteUsEntity>> writeUs({
    required String email,
    required String description,
  });
}
