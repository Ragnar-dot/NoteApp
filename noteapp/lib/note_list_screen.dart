import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'note_provider.dart';
import 'theme_provider.dart';
import 'note_edit_screen.dart';
import 'dart:convert';
import 'package:flutter/services.dart';


class NoteListScreen extends StatefulWidget {
  const NoteListScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  Map<String, String> _localizedStrings = {};
  String currentLanguage = 'en'; // Standardmäßig Englisch

  @override
  void initState() {
    super.initState();
    loadJsonLanguage(currentLanguage); // Standardmäßig Englisch laden
  }

  Future<void> loadJsonLanguage(String languageCode) async {
    String jsonString = await rootBundle.loadString('assets/lang/$languageCode.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    setState(() {
      currentLanguage = languageCode;
      _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
    });
  }

  String getTranslatedValue(String key) {
    return _localizedStrings[key] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getTranslatedValue('titel'),
          style: GoogleFonts.playfairDisplay(
            fontSize: 40,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.italic,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal, // Hintergrundfarbe der App-Leiste
        actions: [
          PopupMenuButton<String>( // Sprachauswahl
            onSelected: (String languageCode) { // Sprache auswählen
              loadJsonLanguage(languageCode); // Sprache laden
            },
            icon: const Icon(Icons.settings), // Einstellungs-Icon
            
            itemBuilder: (BuildContext context) { // Sprachen zur Auswahl
              return [
                PopupMenuItem(
                  value: 'en',
                  child: Text(getTranslatedValue('EN')), // Englisch
                ),
                PopupMenuItem(
                  value: 'de',
                  child: Text(getTranslatedValue('DE')), // Deutsch
                ),
                PopupMenuItem(
                  value: 'pl',
                  child: Text(getTranslatedValue('PL')), // Polnisch
                ),
              ];
            },
          ),
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
              return Center(
                child: Text(
                  getTranslatedValue('no_notes_yet'),
                  style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 107, 107, 107)),
                ),
              );
            }
            return ListView.builder(
              itemCount: provider.notes.length,
              itemBuilder: (context, index) {
                final note = provider.notes[index]; // Die tatsächliche Notiz
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  color: isDarkMode ? const Color.fromARGB(74, 78, 78, 78) : const Color.fromARGB(255, 255, 255, 255), // Kartenfarbe basierend auf dem Theme
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Rundung der Karte
                    side: BorderSide(
                      color: isDarkMode ? const Color.fromARGB(199, 255, 255, 255) : const Color.fromARGB(136, 61, 61, 61), // Rahmenfarbe basierend auf dem Theme
                      width: 0.1,
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      note.title,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black, // Schriftfarbe basierend auf dem Theme
                        decoration: note.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: note.isCompleted ? Colors.red : Colors.transparent, // Durchgestrichen, wenn erledigt
                  
                        
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.description,
                          style: TextStyle(
                            color: isDarkMode ? const Color.fromARGB(255, 255, 255, 255) : Colors.black87, // Beschreibung passend zum Theme
                          ),
                        ),
                        Text(
                          '${getTranslatedValue('created_at')} ${note.createdDate.toLocal().toString().split(' ')[0]}', // Datum anzeigen
                          style: TextStyle(
                            fontSize: 12,
                            color: isDarkMode ? const Color.fromARGB(193, 255, 255, 255) : Colors.black,
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
                          builder: (context) => NoteEditScreen(note: note, index: index, currentLanguage: currentLanguage), // Sprache weitergeben
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
        // Neue Notiz hinzufügen  button
        backgroundColor: const Color.fromARGB(172, 51, 194, 180),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Rundung des Buttons
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteEditScreen(currentLanguage: currentLanguage), // Sprache weitergeben
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Bestätigungsdialog zum Löschen einer Notiz
  void _showDeleteDialog(BuildContext context, NoteProvider provider, int index) {
    final note = provider.notes[index]; // Define the 'note' variable
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(getTranslatedValue('delete_note')),
          content: Text(getTranslatedValue('confirm_delete')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialog schließen
              },
              child: Text(getTranslatedValue('back')),
            ),
            TextButton(
              onPressed: () {
                provider.deleteNote(note); // Notiz löschen
                Navigator.of(context).pop(); // Dialog schließen
              },
              child: Text(
                getTranslatedValue('delete'),
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
