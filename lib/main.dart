import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iremember/blocs/picture_bloc/bloc.dart';
import 'package:iremember/blocs/picture_bloc/picture_bloc.dart';
import 'package:iremember/blocs/simple_bloc_delegate.dart';
import 'package:iremember/repo/pick_picture_repository.dart';
import 'package:iremember/ui/pages/add_edit_screen.dart';
import 'package:iremember/ui/pages/home.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(FirestoreCrudApp());
}

class FirestoreCrudApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PictureBloc>(
          create: (context) {
            return PictureBloc(
              pickPictureRepository: FirebaseRepository(),
            )..add(LoadPicture());
          },
        )
      ],
      child: MaterialApp(
        title: 'Firestore CRUD',
        routes: {
          '/': (context) {
            return HomeScreen();
          },
          '/addPicture': (context) {
            return AddEditScreen();
          },
        },
      ),
    );
  }
}
