import 'package:flutter/material.dart';
import 'package:notesapp/providers/note_provider.dart';
import 'package:provider/provider.dart';
import 'package:notesapp/providers/note_provider.dart';

class AddNoteScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            context.watch<NoteProvider>().editingNote == null
            ?'New Note'
            : 'edit Note'
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              //title Section
              Text('title',style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
              SizedBox(height: 8),
              TextField(
                controller: context.read<NoteProvider>().titleController,
                decoration: InputDecoration(
                  hintText: 'Enter Note Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              //content Section
              Text('Note',style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
              SizedBox(height: 8,),
              TextField(
                controller: context.read<NoteProvider>().contentController,
                maxLines: 8,
                decoration: const InputDecoration(
                  hintText: 'Write your note here...',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              SizedBox(height: 8,),

              //Attachment Section
              Text('Attachment',style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
              SizedBox(height: 8,),
              OutlinedButton.icon(
                onPressed: (){
                  context.read<NoteProvider>().pickAttachment();
                },
                icon: Icon(Icons.attach_file),
                label: Text('Attach Document'),
              ),
              Consumer<NoteProvider>(
                  builder: (context,provider,child) {
                    if(provider.attachmentName == null){
                      return SizedBox.shrink();
                    }
                    return Container(
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
                              child: Text(provider.attachmentName!,overflow: TextOverflow.ellipsis,)
                          ),
                          IconButton(
                              onPressed: (){
                                provider.removeAttachment();
                              },
                              icon: Icon(Icons.close))
                        ],
                      ),
                    );
                  }
              ),
              SizedBox(height: 24),

              //Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    print('save button pressed');
                    final provider = context.read<NoteProvider>();

                    final title = provider.titleController.text.trim();
                    final content = provider.contentController.text.trim();

                    print(provider.editingNote?.title);
                    if(title.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter a title'),),
                      );
                      return;
                    }
                    if(content.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please write some note content'),),
                      );
                      return;
                    }
                    print('going to save new note');
                    if(provider.editingNote != null){
                      await provider.updateNote(provider.editingNote!);
                    }else{
                      await provider.saveNote();
                    }


                    if(context.mounted){
                      Navigator.pop(context);
                    }

                  }, child: Text('Save Note'),
                ),
              )

            ],
          ),
        )
          ,
      ),
    );
  }
}
