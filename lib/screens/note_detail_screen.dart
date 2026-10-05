import 'package:flutter/material.dart';

class NoteDetailScreen extends StatelessWidget {
  final String title;
  final String content;
  final String date;
  final String time;
  final bool hasAttachment;
  final String? attachmentName;

  NoteDetailScreen({
    required this.title,
    required this.content,
    required this.date,
    required this.time,
    required this.hasAttachment,
    this.attachmentName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note Detail'),
        actions: [
          IconButton(onPressed: (){},
              icon: Icon(Icons.edit_outlined),
          ),
          IconButton(onPressed: (){}, 
              icon: Icon(Icons.delete_outline),
          )
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
              Text('Attachment',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
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
              )
            ]
          ],
        ),
      ),
    );
  }
}
