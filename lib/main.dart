import 'package:flutter/material.dart';
import 'package:notesapp/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'providers/note_provider.dart';
import 'services/database.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDatabase.init();
  runApp(
    ChangeNotifierProvider(
      create: (_) => NoteProvider()..loadNotes(),
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
        create: (_) => NoteProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notes App',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.indigo,
        ),
        home: HomeScreen(),
      ),
    );

  }
}
