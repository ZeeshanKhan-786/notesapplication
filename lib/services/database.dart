import 'package:hive_flutter/hive_flutter.dart';
import 'package:notesapp/model/note_model.dart';

class NoteDatabase{

  static const String boxName = 'noteBox';

    // Initialize
  static Future<void> init() async{
    await Hive.initFlutter();
    Hive.registerAdapter(NoteModelAdapter());
    await Hive.openBox<NoteModel>(boxName);
  }
    //Add note method
  static Future<void> addNote(NoteModel note) async {
    final box = Hive.box<NoteModel>(boxName);

    await box.add(note);
  }

  //get note method
  static List<NoteModel> getNotes(){
    final box = Hive.box<NoteModel>(boxName);
    return box.values.toList();
  }

  //delete method
  static Future<void> deleteNote(int index) async{
    final box = Hive.box<NoteModel>(boxName);
    await box.deleteAt(index);
  }

  static Future<void> deleteNoteByKey(dynamic key) async{
    final box = Hive.box<NoteModel>(boxName);
    await box.delete(key);
  }

  static Future<void> updateNote(dynamic key, NoteModel note,) async{
    final box = Hive.box<NoteModel>(boxName);
    await box.put(key,note);
  }

}
