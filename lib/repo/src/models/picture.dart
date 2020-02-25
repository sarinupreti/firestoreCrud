import 'package:iremember/repo/src/entities/entities.dart';
import 'package:meta/meta.dart';

@immutable
class Picture {
  final String imageUrl;
  final String id;

  Picture(this.imageUrl, this.id);

  Picture copyWith({String imageUrl, String id}) {
    return Picture(imageUrl ?? this.imageUrl, id ?? this.id);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Picture &&
          runtimeType == other.runtimeType &&
          imageUrl == other.imageUrl &&
          id == other.id;

  @override
  String toString() {
    return 'Picture {  imageurl: $imageUrl}, id : $id';
  }

  PictureEntity toEntity() {
    return PictureEntity(imageUrl, id);
  }

  static Picture fromEntity(PictureEntity entity) {
    return Picture(entity.imageUrl, entity.id);
  }

  @override
  int get hashCode => super.hashCode;
}
