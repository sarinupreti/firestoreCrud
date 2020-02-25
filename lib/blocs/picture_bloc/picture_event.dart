import 'package:equatable/equatable.dart';
import 'package:iremember/repo/pick_picture_repository.dart';

abstract class PictureEvent extends Equatable {
  const PictureEvent();

  @override
  List<Object> get props => [];
}

class LoadPicture extends PictureEvent {}

class AddPicture extends PictureEvent {
  final Picture picture;

  const AddPicture(this.picture);

  @override
  List<Object> get props => [picture];

  @override
  String toString() => 'AddPicture { picture: $picture }';
}

class UpdatePicture extends PictureEvent {
  final Picture updatePicture;

  const UpdatePicture(this.updatePicture);

  @override
  List<Object> get props => [updatePicture];

  @override
  String toString() => 'UpdatePicture { UpdatePicture: $updatePicture }';
}

class DeletePicture extends PictureEvent {
  final String id;

  const DeletePicture(this.id);

  @override
  List<Object> get props => [id];

  @override
  String toString() => 'DeletePicture { pictureId: $id }';
}

class ClearCompleted extends PictureEvent {}

class ToggleAll extends PictureEvent {}

class PictureUpdated extends PictureEvent {
  final List<Picture> pictures;

  const PictureUpdated(this.pictures);

  @override
  List<Object> get props => [pictures];
}
