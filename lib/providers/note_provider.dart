import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:notesapp/model/note_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:notesapp/services/database.dart';
import 'package:intl/intl.dart';
import 'package:notesapp/services/firestore_service.dart';

class NoteProvider extends ChangeNotifier {

  final List<NoteModel> _notes = [];
  final FirestoreService _firestoreService = FirestoreService();

  //getter
  List<NoteModel> get notes => _notes;

  final titleController = TextEditingController();
  final contentController = TextEditingController();
  String? attachmentPath;
  String? attachmentName;
  NoteModel? editingNote;
  String? attachmentBase64;


  Future<void> pickAttachment() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx',
        'xls',
        'xlsx',
        'ppt',
        'pptx',
        'jpg',
        'jpeg',
        'png',
        'txt',
      ],
      withData: true,
    );

    if (result == null) return;

    final file = result.files.single;

    attachmentName = file.name;
    attachmentPath = file.path;

    final extension = file.extension?.toLowerCase();

    if (['jpg', 'jpeg', 'png'].contains(extension)) {
      final bytes = file.bytes;

      if (bytes != null) {
        attachmentBase64 = base64Encode(bytes);
      } else {
        attachmentBase64 = null;
      }
    } else {
      attachmentBase64 = null;
    }

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
    attachmentBase64=null;
    editingNote=null;
    notifyListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();

    super.dispose();
  }

  Future<void> loadNotes() async {
    _notes.clear();
    _notes.addAll(NoteDatabase.getNotes().reversed);

    notifyListeners();

    try{
      final cloudNotes = await _firestoreService.getNotes();
      final notesFromCloud = cloudNotes.map((data){
        return NoteModel(
            title: data['title'] ?? '',
            content: data['content'] ?? '',
            date: data['date'] ?? '',
            time: data['time'] ?? '',
            attachmentPath: data['attachmentPath'],
            attachmentName: data['attachmentName'],
            attachmentBase64: data['attachmentBase64'],
            firestoreId: data['id'],
        );
      }).toList();
      _notes.clear();
      _notes.addAll(notesFromCloud);
      _notes.addAll(NoteDatabase.getNotes().reversed);
    }catch(e){
      print('Firestore Load error: $e');
    }
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
        date: DateFormat('dd MM yyyy').format(now),
        time: DateFormat('hh:mm a').format(now),
        attachmentPath: attachmentPath,
        attachmentName: attachmentName,
        attachmentBase64: attachmentBase64,
    );

    await NoteDatabase.addNote(note);

    _notes.insert(0,note);
    notifyListeners();
    try{
      final id = await _firestoreService.addNote(note);
      note.firestoreId = id;
      notifyListeners();

      print('Firebase Save Success: ${note.title}');
    }catch(e){
      print('Firebase save error : $e');
    }
    clearForm();
  }

  Future<void> deleteNote(NoteModel note) async{


    if(note.firestoreId != null){
      await _firestoreService.deleteNote(note.firestoreId!);
    }
    final key=note.key;

    if(key == null){
      return;
    }
    await NoteDatabase.deleteNoteByKey(key);
    _notes.remove(note);

    notifyListeners();
  }


  Future<void> updateNote(NoteModel note) async{
    final title = titleController.text.trim();
    final content = contentController.text.trim();

    if(title.isEmpty || content.isEmpty){
      return;
    }
    final updateNote = NoteModel(
        title: title,
        content: content,
        date: note.date,
        time: note.time,
        attachmentPath: attachmentPath,
        attachmentName: attachmentName,
        attachmentBase64: attachmentBase64,
    );
    if(note.firestoreId != null){
      await _firestoreService.updateNote(note.firestoreId!, updateNote);
    }
    final key = note.key;
    if(key != null){
      await NoteDatabase.updateNote(key, updateNote);
    }

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