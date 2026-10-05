import 'package:hive/hive.dart';

class NoteModel extends HiveObject{

  String title;
  String content;
  String date;
  String time;
  String? attachmentPath;
  String? attachmentName;

  NoteModel({

    required this.title,
    required this.content,
    required this.date,
    required this.time,
    this.attachmentPath,
    this.attachmentName,

});
}
class NoteModelAdapter extends TypeAdapter<NoteModel>{
  @override
  final int typeId = 0;

  @override
  NoteModel read(BinaryReader reader){
    final fields = reader.readMap();

    return NoteModel(
        title: fields['title']as String,
        content: fields['content']as String,
        date: fields['date']as String,
        time: fields['time']as String,
        attachmentPath: fields['attachmentPath']as String,
        attachmentName: fields['attachmentName']as String,
    );
  }

  @override
  void write(BinaryWriter writer, NoteModel obj) {
    writer.writeMap({
      'title':obj.title,
      'content': obj.content,
      'date': obj.date,
      'time': obj.time,
      'attachmentPath': obj.attachmentPath,
      'attachmentName': obj.attachmentName,
    });
  }
}
