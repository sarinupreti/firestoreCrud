import 'dart:async';

import '../pick_picture_repository.dart';

abstract class PickPictureRespository {
  Future<void> addNewPicture(Picture picture);

  Future<void> deletePicture(String id);

  Stream<List<Picture>> getPictures();

  Future<void> updatePicture(Picture picture);
}
