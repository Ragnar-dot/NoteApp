import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:noteapp/note_edit_screen.dart';
import 'package:noteapp/note_model.dart';
import 'package:provider/provider.dart';
import 'note_provider.dart';
import 'theme_provider.dart';


class NoteListScreen extends StatelessWidget {
  const NoteListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: Consumer<NoteProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.notes.length,
            itemBuilder: (context, index) {
              final note = provider.notes[index];
              return ListTile(
                title: Text(note.title),
                subtitle: Text(note.description),
                trailing: Checkbox(
                  value: note.isCompleted,
                  onChanged: (bool? value) {
                    provider.toggleNoteCompletion(index as Note);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoteEditScreen(
                        note: note,
                        index: index, currentLanguage: '',
                      ),
                    ),
                  );
                },
                onLongPress: () {
                  provider.deleteNote(note);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NoteEditScreen(currentLanguage: '',),
            ),
          );
        },
        child: const Icon(Icons.add), // Add new note button
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('notes');
  await Hive.openBox('settings');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoteProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Notes App',
            theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
            home: const NoteListScreen(),
          );
        },
      ),
    );
  }
}