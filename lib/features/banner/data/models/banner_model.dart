import '../../domain/entities/banner_entity.dart';

class BannerModel extends BannerEntity {
  const BannerModel({
    required int id,
    required String title,
    required String imageUrl,
    String? linkUrl,
    required bool isActive,
  }) : super(
          id: id,
          title: title,
          imageUrl: imageUrl,
          linkUrl: linkUrl,
          isActive: isActive,
        );

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? json['judul'] ?? 'No Title',
      imageUrl:
          json['foto'] ?? json['gambar'] ?? json['image'] ?? json['url'] ?? '',
      linkUrl: json['link'],
      isActive: json['is_active'] == true || json['is_active'] == 1,
    );
  }
}
