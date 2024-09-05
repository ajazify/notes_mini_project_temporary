import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  String title;

  @HiveField(1)
  String subtitle;

  @HiveField(2) 
  int color;

  Task({
    required this.title,
    required this.subtitle,
    this.color = 0xFFFFFFFF, 
  });
}