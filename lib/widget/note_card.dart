import 'package:flutter/material.dart';
import 'package:notesapp/screens/note_detail_screen.dart';
import 'package:notesapp/providers/note_provider.dart';
import 'package:provider/provider.dart';

class NoteCard extends StatelessWidget {

  final String title;
  final String content;
  final String date;
  final String time;
  final bool hasAttachment;
  final String? attachmentName;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  NoteCard({super.key, required this.title, required this.content, required this.date, required this.time, required this.hasAttachment, this.attachmentName, this.onTap, this.onDelete, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)
      ),
        child: Padding(padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(title,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)
                  ),
                  PopupMenuButton<String>(
                      onSelected: (value){
                        if(value =='delete'){
                          onDelete?.call();
                        }
                        if(value == 'edit'){
                          onEdit?.call();
                        }
                      },
                      itemBuilder: (context) =>
                    [
                      const PopupMenuItem(
                          value: 'Edit',
                          child: Text('Edit')),
                      const PopupMenuItem(
                          value: 'Delete',
                          child: Text('Delete'))
                    ]
                  )
                ],
              ),
              Text(
                content,
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined,size: 15,),
                  SizedBox(width: 5),
                  Text('$date , $time',),
                  Spacer(),
                  if(hasAttachment)...[
                    Icon(
                      Icons.attach_file,
                      size: 17,
                    ),
                    Text(
                      attachmentName ?? 'File',
                    ),
                  ]
                ],
              )
            ],
        ),),

      ),
    );
  }
}
