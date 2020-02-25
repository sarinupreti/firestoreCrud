import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iremember/blocs/picture_bloc/bloc.dart';
import 'package:iremember/components/shimmer.dart';
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
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddEditScreen(
                                          picture: Picture(image, id),
                                        )));
                          },
                          onLongPress: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddEditScreen(
                                          picture: Picture(image, id),
                                        )));
                          },
                          child: CachedNetworkImage(
                            imageUrl: image ?? "",
                            imageBuilder: (context, imageProvider) => Container(
                              height: MediaQuery.of(context).size.height / 2,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => CustomShimmer(
                              height: MediaQuery.of(context).size.height / 2,
                              width: MediaQuery.of(context).size.width,
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          )),
                    ));
                  });
            else
              return Container(
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Click add icon to upload image.".toUpperCase()),
                    SizedBox(height: 30),
                    Text("Double tap to delete image after upload."
                        .toUpperCase()),
                    SizedBox(height: 30),
                    Text("Long Press or tap to update image. ".toUpperCase())
                  ],
                )),
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
