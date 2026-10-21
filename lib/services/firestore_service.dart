import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notesapp/model/note_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId{
    final user = _auth.currentUser;

    if(user == null){
      throw Exception('please login first');
    }
    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> get _notesCollection{
    return _firestore
        .collection('user')
        .doc(_userId)
        .collection('notes');
  }

  Future<String> addNote(NoteModel note) async{
    final doc = await _notesCollection.add({
      'title': note.title,
      'content': note.content,
      'date': note.date,
      'time': note.time,
      'attachmentPath': note.attachmentPath,
      'attachmentBase64': note.attachmentBase64,
      'createdAt': FieldValue.serverTimestamp()
    });

    return doc.id;
  }

  Future<List<Map<String,dynamic>>> getNotes()async{
    final snapshot = await _notesCollection
        .orderBy('createdAt', descending: true).get();

    return snapshot.docs.map((doc){
      return{
        ...doc.data(),
        'id':doc.id,
      };
    }).toList();
  }

  Future<void> updateNote(String documentId, NoteModel note)async{
    await _notesCollection.doc(documentId).update({
      'title': note.title,
      'content': note.content,
      'date': note.date,
      'time': note.time,
      'attachmentPath': note.attachmentPath,
      'attachmentName': note.attachmentName,
      'attachmentBase64': note.attachmentBase64,
    });
  }
  Future<void> deleteNote(String documentId) async {
    await _notesCollection.doc(documentId).delete();
  }
}
