import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iremember/blocs/picture_bloc/bloc.dart';
import 'package:iremember/components/permission_service.dart';
import 'package:iremember/repo/pick_picture_repository.dart';

typedef OnSaveCallback = Function(String task, String note);

class AddEditScreen extends StatefulWidget {
  final Picture picture;

  const AddEditScreen({this.picture});

  @override
  _AddEditScreenState createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  File _image;
  String image;
  String _uploadedFileURL;

  static Firestore _firestore = Firestore.instance;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.picture != null ? "Update Picture" : "Add Picture"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: InkWell(
          onTap: () async {
            await PermissionsService().requestPhotosPermission();
            _getCameraImage(context);
          },
          child: Container(
            height: MediaQuery.of(context).size.height / 1.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: widget.picture != null
                    ? DecorationImage(
                        image: _image == null
                            ? NetworkImage(widget.picture.imageUrl ?? "")
                            : FileImage(this._image),
                        fit: BoxFit.cover)
                    : DecorationImage(
                        image: image != null || _image == null
                            ? NetworkImage(image ?? "")
                            : FileImage(this._image),
                        fit: BoxFit.cover),
                color: Colors.grey.withOpacity(0.5),
                shape: BoxShape.rectangle),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: isLoading
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              )
            : image == null && _image != null
                ? Text('Save changes')
                : Text('Add Picture'),
        tooltip:
            image == null && _image != null ? 'Save changes' : 'Add Picture',
        icon: isLoading
            ? SizedBox(height: 0, width: 0)
            : Icon(image == null && _image != null ? Icons.check : Icons.add),
        onPressed: () async {
          if (image == null && _image == null) {
            _getCameraImage(context);
          } else {
            await buttonAction(context);
          }
        },
      ),
    );
  }

  Future buttonAction(BuildContext context) async {
    if (image != null || _image != null) {
      await uploadFile();
      Navigator.pop(context);
    } else {
      print("something went wrong while uploading.");
    }
  }

  _getCameraImage(BuildContext context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  Future uploadFile() async {
    setState(() {
      isLoading = true;
    });
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(hashCode.toString());
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    await storageReference.getDownloadURL().then((fileURL) async {
      setState(() {
        _uploadedFileURL = fileURL;
      });
      await saveOrUpdateUserData();
    });
    print('File Uploaded');
    setState(() {
      isLoading = false;
    });
  }

  Future saveOrUpdateUserData() async {
    String path = "pictures";
    final ref = _firestore.collection(path).document();

    if (widget.picture != null) {
      BlocProvider.of<PictureBloc>(context).add(
        UpdatePicture(Picture(_uploadedFileURL, widget.picture.id)),
      );
    } else {
      BlocProvider.of<PictureBloc>(context).add(
        AddPicture(Picture(_uploadedFileURL, ref.documentID)),
      );
    }
  }
}
