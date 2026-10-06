import 'package:flutter/cupertino.dart';
import 'package:notesapp/model/note_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:notesapp/model/note_model.dart';
import 'package:notesapp/services/database.dart';
import 'package:intl/intl.dart';

class NoteProvider extends ChangeNotifier {

  final List<NoteModel> _notes = [];

  //getter
  List<NoteModel> get notes => _notes;

  final titleController = TextEditingController();
  final contentController = TextEditingController();
  String? attachmentPath;
  String? attachmentName;
  NoteModel? editingNote;

  void setAttachment({required String path, required String name}){
    attachmentPath = path;
    attachmentName = name;
    notifyListeners();
  }

  Future<void> pickAttachment() async{
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx',
        'jpg',
        'jpeg',
        'png',
        'text'
      ]
    );
    if(result==null){
      return;
    }
    final file = result.files.single;
    if(file.path == null){
      return;
    }
    attachmentPath=file.path;
    attachmentName=file.name;
    notifyListeners();

  }

  void removeAttachment(){
    attachmentPath = null;
    attachmentName = null;
    notifyListeners();
  }

  void clearForm(){
    titleController.clear();
    contentController.clear();
    attachmentPath=null;
    attachmentName=null;

    editingNote=null;
    notifyListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();

    super.dispose();
  }

  void loadNotes(){
    _notes.clear();
    _notes.addAll(NoteDatabase.getNotes().reversed);

    notifyListeners();
  }

  //Save method
  Future<void> saveNote() async {
    final title = titleController.text.trim();
    final content = contentController.text.trim();

    if(title.isEmpty || content.isEmpty){
      return;
    }

    final now = DateTime.now();


    final note = NoteModel(
        title: title,
        content: content,
        date: DateFormat('dd MMM yyyy').format(now),
        time: DateFormat('hh:mm a').format(now),
        attachmentPath: attachmentPath,
        attachmentName: attachmentName,
    );

    await NoteDatabase.addNote(note);

    _notes.insert(0,note);

    print('save success : ${note.title}');
    print('Total notes : ${notes.length}');
    notifyListeners();
    clearForm();
  }

  Future<void> deleteNote(NoteModel note) async{
    final key=note.key;

    if(key == null){
      return;
    }
    await NoteDatabase.deleteNoteByKey(key);
    _notes.remove(note);

    notifyListeners();
  }


  Future<void> updateNote(NoteModel note) async{
    final key = note.key;

    if(key == null){
      return;
    }
    final updateNote = NoteModel(
        title: titleController.text.trim(),
        content: contentController.text.trim(),
        date: note.date,
        time: note.time,
        attachmentPath: attachmentPath,
        attachmentName: attachmentName,
    );

    await NoteDatabase.updateNote(key,updateNote);

    final index = _notes.indexOf(note);
    if(index != -1){
      _notes[index] = updateNote;
    }
    notifyListeners();
    clearForm();
    
  }

  void startEditing(NoteModel note){
    editingNote = note;

    titleController.text= note.title;
    contentController.text=note.content;
    attachmentPath=note.attachmentPath;
    attachmentName=note.attachmentName;

    notifyListeners();
  }

}