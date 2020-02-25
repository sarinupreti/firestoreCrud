import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iremember/repo/pick_picture_repository.dart';
import 'package:iremember/repo/src/entities/picture_entity.dart';

class FirebaseRepository implements PickPictureRespository {
  final pictureCollection = Firestore.instance.collection('pictures');

  @override
  Future<void> addNewPicture(Picture picture) {
    return pictureCollection
        .document(picture.id)
        .setData((picture.toEntity().toDocument()));
  }

  @override
  Stream<List<Picture>> getPictures() {
    return pictureCollection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => Picture.fromEntity(PictureEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<void> updatePicture(Picture update) {
    return pictureCollection
        .document(update.id)
        .updateData((update.toEntity().toDocument()));
  }

  @override
  Future<void> deletePicture(String id) async {
    return pictureCollection.document(id).delete();
  }
}
