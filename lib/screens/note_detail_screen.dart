import 'package:flutter/material.dart';
import 'package:notesapp/providers/note_provider.dart';
import 'package:notesapp/screens/add_note_screen.dart';
import 'package:notesapp/widget/delete_popup.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class NoteDetailScreen extends StatelessWidget {
  final String title;
  final String content;
  final String date;
  final String time;
  final bool hasAttachment;
  final String? attachmentName;
  final int index;
  final String? attachmentPath;
  final String? attachmentBase64;

  NoteDetailScreen({
    required this.title,
    required this.content,
    required this.date,
    required this.time,
    required this.hasAttachment,
    this.attachmentName,
    required this.index,
    this.attachmentPath,
    this.attachmentBase64,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NoteProvider>();
    final note = provider.notes[index];
    return Scaffold(
      appBar: AppBar(
        title: Text('Note Detail'),
        actions: [
          IconButton(onPressed: (){
            final provider = context.read<NoteProvider>();
            provider.startEditing(note);
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddNoteScreen()));
          },
              icon: Icon(Icons.edit_outlined),
          ),
          IconButton(onPressed: (){
            showDialog(context: context, builder: (dialogContext){
              return DeletePopup(note: note,closeDetailScreen:true,parentContext:context);
            },);
          },
              icon: Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Title Section
            Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
            SizedBox(height: 8,),
            Text('$date . $time',style: TextStyle(color: Colors.grey.shade600,fontSize: 14),),
            SizedBox(height: 8,),
            Divider(),
            SizedBox(height: 24,),

            //Content Section
            Text(content,style: TextStyle(fontSize: 16, height: 1.5),),

            //Attachment section
            if(hasAttachment && attachmentName != null)...[
              SizedBox(height: 30,),
              Text('Attachment',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  onTap: (){
                    _showPreview(context, attachmentBase64);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.insert_drive_file_outlined),
                      SizedBox(width: 10,),
                      Expanded(
                          child: Text(attachmentName!,overflow: TextOverflow.ellipsis,),
                      ),
                      IconButton(onPressed: (){},
                          icon: Icon(Icons.open_in_new)),
                    ],
                  ),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}

void _showPreview(BuildContext context, String? attachmentBase64){
  showDialog(context: context, builder: (dialogContext){
    return Dialog(
      backgroundColor: Colors.blueAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.blue, width: 0.7),
      ),
      child: ConstrainedBox(
          constraints:BoxConstraints(maxWidth: 560),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.memory(
                    base64Decode(attachmentBase64!),
                    fit: BoxFit.contain,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                      onPressed: (){
                        Navigator.pop(dialogContext);
                      },
                      child: Text('Close',style: TextStyle(color: Colors.white,fontSize: 18),)
                  ),
                )
              ],
            ),

          ),
      ),
    );
  });
}
