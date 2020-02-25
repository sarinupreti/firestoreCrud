import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iremember/blocs/picture_bloc/bloc.dart';
import 'package:iremember/repo/pick_picture_repository.dart';

import 'package:iremember/ui/pages/add_edit_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: BlocBuilder<PictureBloc, PictureState>(
        builder: (context, state) {
          if (state is PictureLoading) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is PictureLoaded) {
            print(state.pictures);
            if (state.pictures.length > 0)
              return ListView.builder(
                  itemCount: state.pictures.length,
                  itemBuilder: (BuildContext context, int index) {
                    final image = state.pictures[index].imageUrl;
                    final id = state.pictures[index].id;

                    return Container(
                        child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: InkWell(
                          onDoubleTap: () {
                            BlocProvider.of<PictureBloc>(context)
                                .add(DeletePicture(id));
                          },
                          onLongPress: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddEditScreen(
                                          picture: Picture(image, id),
                                        )));
                          },
                          child: Image.network(image ?? "")),
                    ));
                  });
            else
              return Container(
                child: Center(child: Text("upload a picture ")),
              );
          } else {
            return Center(child: Text("No pictures in state"));
          }
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddEditScreen()));
        },
        child: Icon(Icons.add),
        tooltip: 'Add Picture',
      ),
    );
  }
}
