import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_test/modules/note.dart';

import 'package:hive_test/screens/add_note_screen.dart';
import 'package:hive_test/screens/view_note_screen.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 215, 228, 255),
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.07,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.elliptical(
              MediaQuery.of(context).size.width,
              100.0,
            ),
          ),
        ),
        title: const Text("N O T E M Y"),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingActionButton(
        mini: true,
        elevation: 10.0,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddNote(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          size: 20.0,
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ValueListenableBuilder(
            valueListenable: Hive.box<Note>("note").listenable(),
            builder: (context, Box<Note> box, child) {
              if (box.isNotEmpty) {
                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onLongPress: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ViewNote(
                                description:
                                    box.getAt(index)!.description.toString(),
                                image: box.getAt(index)!.imageUrl.toString(),
                                title: box.getAt(index)!.title.toString(),
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 5,
                          margin: const EdgeInsets.all(5),
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  height: 75,
                                  // width: 100,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: FileImage(
                                        File(
                                          box.getAt(index)!.imageUrl.toString(),
                                        ),
                                      ),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: ListTile(
                                  title: AutoSizeText(
                                    box.getAt(index)!.title.toString(),
                                    maxLines: 1,
                                  ),
                                  subtitle: AutoSizeText(
                                    box.getAt(index)!.description.toString(),
                                    maxLines: 1,
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      box.deleteAt(index);
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
              return const Center(
                child: FittedBox(
                  child: Text(
                    "No notes added yet",
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
