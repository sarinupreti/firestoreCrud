import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PictureEntity extends Equatable {
  final String imageUrl;
  final String id;

  PictureEntity(this.imageUrl, this.id);

  Map<String, Object> toJson() {
    return {'imageUrl': imageUrl, 'id': id};
  }

  @override
  String toString() {
    return 'PictureEntity {  imageUrl: $imageUrl, id : $id }';
  }

  static PictureEntity fromJson(Map<String, Object> json) {
    return PictureEntity(
      json['imageUrl'] as String,
      json['id'] as String,
    );
  }

  static PictureEntity fromSnapshot(DocumentSnapshot snap) {
    return PictureEntity(
      snap.data['imageUrl'],
      snap.data['id'],
    );
  }

  Map<String, Object> toDocument() {
    return {'imageUrl': imageUrl, 'id': id};
  }

  @override
  List<Object> get props => throw UnimplementedError();
}
