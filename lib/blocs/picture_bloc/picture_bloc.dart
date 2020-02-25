import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:iremember/blocs/picture_bloc/bloc.dart';
import 'package:iremember/repo/pick_picture_repository.dart';

import 'package:meta/meta.dart';

class PictureBloc extends Bloc<PictureEvent, PictureState> {
  final PickPictureRespository _pickPictureRespository;

  StreamSubscription _pictureSubscription;

  PictureBloc({@required PickPictureRespository pickPictureRepository})
      : assert(pickPictureRepository != null),
        _pickPictureRespository = pickPictureRepository;

  @override
  PictureState get initialState => PictureLoading();

  @override
  Stream<PictureState> mapEventToState(PictureEvent event) async* {
    if (event is LoadPicture) {
      yield* _mapLoadPicturesToState();
    } else if (event is AddPicture) {
      yield* _mapAddPictureToState(event);
    } else if (event is UpdatePicture) {
      yield* _mapUpdatePictureToState(event);
    } else if (event is DeletePicture) {
      yield* _mapDeletePictureToState(event);
    }
    //  else if (event is ToggleAll) {
    //   yield* _mapToggleAllToState();
    // }
    // else if (event is ClearCompleted) {
    //   yield* _mapClearCompletedToState();
    // }
    else if (event is PictureUpdated) {
      yield* _mapPicturesUpdateToState(event);
    }
  }

  Stream<PictureState> _mapLoadPicturesToState() async* {
    _pictureSubscription?.cancel();
    _pictureSubscription = _pickPictureRespository.getPictures().listen(
          (p) => add(PictureUpdated(p)),
        );
  }

  Stream<PictureState> _mapAddPictureToState(AddPicture event) async* {
    _pickPictureRespository.addNewPicture(event.picture);
  }

  Stream<PictureState> _mapUpdatePictureToState(UpdatePicture event) async* {
    _pickPictureRespository.updatePicture(event.updatePicture);
  }

  Stream<PictureState> _mapDeletePictureToState(DeletePicture event) async* {
    _pickPictureRespository.deletePicture(event.id);
  }

  // Stream<PictureState> _mapToggleAllToState() async* {
  //   final currentState = state;
  //   if (currentState is PictureLoaded) {
  //     final allComplete = currentState.pictures.every((p) => p.imageUrl);
  //     final List<Picture> updatedPictures = currentState.pictures
  //         .map((p) => p.copyWith(complete: !allComplete))
  //         .toList();
  //     updatedPictures.forEach((updatedPicture) {
  //       _pickPictureRespository.updatePicture(updatedPicture);
  //     });
  //   }
  // }

  // Stream<PictureState> _mapClearCompletedToState() async* {
  //   final currentState = state;
  //   if (currentState is PictureLoaded) {
  //     final List<Picture> completedPictures =
  //         currentState.pictures.where((p) => p.complete).toList();
  //     completedPictures.forEach((completePicture) {
  //       _pickPictureRespository.deletePicture(completePicture);
  //     });
  //   }
  // }

  Stream<PictureState> _mapPicturesUpdateToState(PictureUpdated event) async* {
    yield PictureLoaded(event.pictures);
  }

  @override
  Future<void> close() {
    _pictureSubscription?.cancel();
    return super.close();
  }
}
