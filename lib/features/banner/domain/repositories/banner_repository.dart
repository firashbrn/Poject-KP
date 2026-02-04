import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/banner_entity.dart';

abstract class BannerRepository {
  Future<Either<Failure, List<BannerEntity>>> getBanners();
}
