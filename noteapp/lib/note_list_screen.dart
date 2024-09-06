import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'note_provider.dart';
import 'theme_provider.dart';
import 'note_edit_screen.dart';

class NoteListScreen extends StatelessWidget {
  const NoteListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Abfrage des aktuellen Themas (Dark Mode oder Light Mode)
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notes',
          style: GoogleFonts.playfairDisplay(
            fontSize: 40, // Große Schriftgröße
            fontWeight: FontWeight.w400, // Normales Gewicht
            fontStyle: FontStyle.italic, // Italic Stil
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true, // Überschrift zentrieren
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme(); // Dark Mode umschalten
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<NoteProvider>(
          builder: (context, provider, child) {
            if (provider.notes.isEmpty) {
              return const Center(
                child: Text(
                  'No notes yet!',
                  style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 107, 107, 107)),
                ),
              );
            }
            return ListView.builder(
              itemCount: provider.notes.length,
              itemBuilder: (context, index) {
                final note = provider.notes[index]; // Die tatsächliche Notiz
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(
                      note.title,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black, // Schriftfarbe basierend auf dem Theme
                        decoration: note.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.description,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white70 : Colors.black87, // Beschreibung passend zum Theme
                          ),
                        ),
                        Text(
                          'Erstellt am: ${note.createdDate.toLocal().toString().split(' ')[0]}', // Datum anzeigen
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey, // Datum bleibt grau
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: note.isCompleted,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20), // Rundung der Checkbox
                          ),
                          activeColor: Colors.teal, // Optional: Farbe der Checkbox
                          onChanged: (bool? value) {
                            provider.toggleNoteCompletion(note); // Notiz übergeben
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showDeleteDialog(context, provider, index); // Dialog zum Löschen
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoteEditScreen(note: note, index: index),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NoteEditScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Bestätigungsdialog zum Löschen einer Notiz
  void _showDeleteDialog(BuildContext context, NoteProvider provider, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Note'),
          content: const Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialog schließen
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                provider.deleteNoteAt(index); // Notiz löschen
                Navigator.of(context).pop(); // Dialog schließen
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}