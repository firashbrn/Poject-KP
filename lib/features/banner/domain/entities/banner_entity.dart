import 'package:equatable/equatable.dart';

class BannerEntity extends Equatable {
  final int id;
  final String title;
  final String imageUrl;
  final String? linkUrl;
  final bool isActive;

  const BannerEntity({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.linkUrl,
    required this.isActive,
  });

  @override
  List<Object?> get props => [id, title, imageUrl, linkUrl, isActive];
}
