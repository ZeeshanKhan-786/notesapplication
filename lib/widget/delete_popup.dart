import 'package:flutter/material.dart';
import 'package:notesapp/model/note_model.dart';
import 'package:notesapp/providers/note_provider.dart';
import 'package:provider/provider.dart';

class DeletePopup extends StatelessWidget {
  final NoteModel note;
  final BuildContext? parentContext;
  final bool closeDetailScreen;

  const DeletePopup({
    super.key,
    required this.note,
    this.parentContext,
    this.closeDetailScreen=false,
  });


  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text('Delete Note'),
      content: Text('Are you sure you want to delete this note?'),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text('Cancel')),
        TextButton(onPressed: (){
          context.read<NoteProvider>().deleteNote(note);
          Navigator.pop(context,true);

          if(closeDetailScreen && parentContext != null){
            Navigator.pop(parentContext!); // detail screen close
          }
        }, child: Text('Delete')),

      ],
    );
  }
}
