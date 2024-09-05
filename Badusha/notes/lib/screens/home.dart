import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/note.dart';
import 'package:notes/screens/notepage.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

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
              onPressed: () {},
              icon: const Icon(Icons.settings),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: FloatingActionButton(
          onPressed: () => Get.to(const Notepage()),
          backgroundColor: Colors.amber[600],
          child: const Icon(
            Icons.add,
            size: 42,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: ValueListenableBuilder(
          valueListenable: Hive.box<Note>('notes').listenable(),
          builder: (context, Box<Note> box, _) {
            if (box.isEmpty) {
              return const Center(
                child: Text('No notes available'),
              );
            }

            return Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 1.0,
                ),
                itemCount: box.length,
                itemBuilder: (context, index) {
                  final note = box.getAt(index);

                  String truncatedContent = (note?.content ?? '').length > 30
                      ? '${note?.content.substring(0, 30)}....'
                      : note?.content ?? '';

                  return Card(
                    color: Colors.grey[100],
                    elevation: 3,
                    margin: EdgeInsets.zero,
                    child: InkWell(
                      onTap: () {
                        Get.to(Notepage(note: note, index: index));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              note?.title ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              truncatedContent,
                              style: const TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
