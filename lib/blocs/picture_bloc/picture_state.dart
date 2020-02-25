import 'package:equatable/equatable.dart';
import 'package:iremember/repo/pick_picture_repository.dart';

abstract class PictureState extends Equatable {
  const PictureState();

  @override
  List<Object> get props => [];
}

class PictureLoading extends PictureState {}

class PictureLoaded extends PictureState {
  final List<Picture> pictures;

  const PictureLoaded([this.pictures = const []]);

  @override
  List<Object> get props => [pictures];

  @override
  String toString() => 'PictureLoaded { pictures: $pictures }';
}

class PicturesNotLoaded extends PictureState {}
