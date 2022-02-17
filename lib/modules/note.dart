import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'note.g.dart';

@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  var title;
  @HiveField(1)
  var description;
  @HiveField(2)
  var imageUrl;
  Note({
    required this.title,
    required this.description,
    required this.imageUrl,
  });
}
