import 'package:flutter/material.dart';
import 'package:notesapp/providers/note_provider.dart';
import 'package:notesapp/screens/add_note_screen.dart';
import 'package:notesapp/widget/note_card.dart';
import 'package:provider/provider.dart';
import 'package:notesapp/screens/note_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NoteProvider>();
   // if (provider.notes.isEmpty) {}
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text('Notes', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_vert,size: 28,))],
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search notes...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),

                ),
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: provider.notes.isEmpty
                  ? Center(
                      child: Text(
                        'No notes yet',
                        style: TextStyle(fontSize: 28, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: provider.notes.length,
                      itemBuilder: (context, index) {
                        final note = provider.notes[index];
                        return NoteCard(
                          title: note.title,
                          content: note.content,
                          date: note.date,
                          time: note.time,
                          hasAttachment: note.attachmentName != null,
                          attachmentName: note.attachmentName,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NoteDetailScreen(
                                  title: note.title,
                                  content: note.content,
                                  date: note.date,
                                  time: note.time,
                                  hasAttachment: note.attachmentName != null,
                                  attachmentName: note.attachmentName,
                                ),
                              ),
                            );

                          },
                          onDelete: () {
                            print('delete button pressed');
                            showDialog(context: context, builder: (dialogContent){
                              return AlertDialog(
                                title: Text('Delete Note'),
                                content: Text('Are you sure you want to delete this note?'),
                                actions: [
                                  TextButton(onPressed: (){
                                    Navigator.pop(dialogContent);
                                  }, child: Text('Cancel')),
                                  TextButton(onPressed: (){
                                    print('delete presses...');
                                    context.read<NoteProvider>().deleteNote(note);
                                    Navigator.pop(dialogContent);
                                  }, child: Text('Delete')),
                                ],
                              );
                            });
                          },
                          onEdit:(){
                            final provider = context.read<NoteProvider>();
                            provider.startEditing(note);
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddNoteScreen()));
                          }
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<NoteProvider>().clearForm();

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNoteScreen()),
          );
        },
        backgroundColor: Colors.blue,
        shape: CircleBorder(),
        child: Icon(Icons.add, color: Colors.white, size: 35),
      ),
    );
  }
}
