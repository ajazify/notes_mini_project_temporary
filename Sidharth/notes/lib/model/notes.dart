import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String content;

  @HiveField(2)
  final String date;

  @HiveField(3)
  final String time;

  @HiveField(4)
  final int color;

  Note({
    required this.title,
    required this.content,
    required this.date,
    required this.time,
    required this.color,
  });
}

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final int typeId = 0;

  @override
  Note read(BinaryReader reader) {
    return Note(
      title: reader.readString(),
      content: reader.readString(),
      date: reader.readString(),
      time: reader.readString(),
      color: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer.writeString(obj.title);
    writer.writeString(obj.content);
    writer.writeString(obj.date);
    writer.writeString(obj.time);
    writer.writeInt(obj.color);
  }
}
