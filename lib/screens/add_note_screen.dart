import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_test/modules/note.dart';

import 'package:image_picker/image_picker.dart';

class AddNote extends StatefulWidget {
  AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final _formkey = GlobalKey<FormState>();
  var title;
  var description;
  File? _image;
  String imageCheck = "No Image";

  submitData() async {
    final isValid = _formkey.currentState!.validate();
    if (isValid) {
      if (_image != null) {
        Hive.box<Note>("note").add(
          Note(
            title: title,
            description: description,
            imageUrl: _image!.path,
          ),
        );
        Navigator.of(context).pop();
      } else {
        setState(() {
          imageCheck = "Please Add an Image";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: submitData,
        child: const Icon(
          Icons.add,
          size: 20.0,
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showBottomSheet(context);
            },
            icon: const Icon(
              Icons.add_a_photo_outlined,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formkey,
            child: ListView(
              children: [
                const SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  validator: (val) {
                    if (val!.length > 22) {
                      return "less then 22 pls";
                    }
                    if (val.length < 2) {
                      return "more then 2";
                    }
                    return null;
                  },
                  autocorrect: false,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(20),
                  ],
                  decoration: InputDecoration(
                    labelText: "Note",
                    prefixIcon: const Icon(
                      Icons.note,
                      color: Color(0xff073C47),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onChanged: (val) {
                    setState(
                      () {
                        title = val;
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                  validator: (val) {
                    if (val!.length > 250) {
                      return "less then 250 pls";
                    }
                    if (val.length < 2) {
                      return "more then 2";
                    }
                    return null;
                  },
                  maxLength: 250,
                  minLines: 1,
                  maxLines: 3,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: "Description",
                    prefixIcon: const Icon(
                      Icons.description,
                      color: Color(0xff073C47),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onChanged: (val) {
                    setState(
                      () {
                        description = val;
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                _image == null
                    ? Center(
                        child: SizedBox(
                          height: 200,
                          width: 100,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: Text(
                              imageCheck,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                    : Image.file(
                        File(_image!.path),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Camera Functions
  //Phot from Camera
  getImageCamera() async {
    final pickedimage =
        await ImagePicker.platform.getImage(source: ImageSource.camera);
    if (pickedimage != null) {
      setState(() {
        _image = File(pickedimage.path);
      });

      Navigator.of(context).pop();
    }
  }
  //Phot From gallery

  getImageGallery() async {
    final pickedimage =
        await ImagePicker.platform.getImage(source: ImageSource.gallery);
    if (pickedimage != null) {
      setState(() {
        _image = File(pickedimage.path);
      });

      Navigator.of(context).pop();
    }
  }

  //AlertDialog Appear when pressing add phot buttom
  showBottomSheet(context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Choose photo from",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await getImageCamera();
              },
              icon: const Icon(Icons.photo_camera),
            ),
            IconButton(
              onPressed: () async {
                await getImageGallery();
              },
              icon: const Icon(Icons.image),
            )
          ],
        );
      },
    );
  }
  //End Camera Function

}
