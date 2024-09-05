import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes/note.dart';
import 'package:notes/notepage.dart';

class HomeSreen extends StatelessWidget {
  const HomeSreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            'Notes App',
            style: TextStyle(
              color: Color.fromARGB(255, 110, 110, 110),
              fontSize: 23,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () => {},
              icon: const Icon(Icons.settings),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(const Notepage()),
        backgroundColor: Colors.amber[600],
        shape: CircleBorder(),
        child: const Icon(
          Icons.add,
          size: 36,
          color: Colors.white,
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Note>('notes').listenable(),
        builder: (context, Box<Note> box, _) {
          if (box.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sticky_note_2_sharp,
                    color: Colors.yellow[700],
                    size: 100,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'No Notes available!',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final note = box.getAt(index);
              return ListTile(
                title: Text(note?.title ?? ''),
                subtitle: Text(note?.content ?? ''),
                onTap: () {
                  Get.to(Notepage(note: note, index: index));
                },
              );
            },
          );
        },
      ),
    );
  }
}
