import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import '../entities/banner_entity.dart';
import '../repositories/banner_repository.dart';

class GetBannersUseCase extends UseCase<List<BannerEntity>, void> {
  final BannerRepository repository;

  GetBannersUseCase(this.repository);

  @override
  Future<Stream<List<BannerEntity>?>> buildUseCaseStream(void params) async {
    final controller = StreamController<List<BannerEntity>?>();
    try {
      final result = await repository.getBanners();
      result.fold(
        (failure) => controller.addError(failure),
        (banners) {
          controller.add(banners);
          controller.close();
        },
      );
    } catch (e) {
      controller.addError(e);
    }
    return controller.stream;
  }
}
