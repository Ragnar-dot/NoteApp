import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'note_model.dart';

class NoteProvider extends ChangeNotifier {
  final Box<Note> _box = Hive.box<Note>('notes');

  // Gib die Notizen sortiert zurück, aber ohne die Hive-Box zu ändern
  List<Note> get notes {
    List<Note> allNotes = _box.values.toList();
    allNotes.sort((a, b) {
      // Erst nach Status sortieren, dann nach Erstellungsdatum
      if (a.isCompleted == b.isCompleted) {
        return a.createdDate.compareTo(b.createdDate); // Ältere zuerst
      }
      return a.isCompleted ? 1 : -1; // Erledigte nach unten, nicht erledigte nach oben
    });
    return allNotes;
  }

  // Notiz hinzufügen
  void addNote(Note note) {
    _box.add(note);
    notifyListeners();
  }

  // Notiz aktualisieren (basierend auf Index der Hive-Box, nicht der sortierten Liste)
  void updateNoteAt(int index, Note note) {
    _box.putAt(index, note);
    notifyListeners();
  }

  // Notiz löschen
  void deleteNoteAt(int index) {
    if (index >= 0 && index < _box.length) {
      _box.deleteAt(index);
      notifyListeners();
    }
  }

  // Status einer Notiz umschalten (Erledigt/Unvollständig)
  void toggleNoteCompletion(Note note) {
    int index = _box.values.toList().indexOf(note); // Den Index der Notiz in der Box finden
    if (index >= 0) {
      note.isCompleted = !note.isCompleted; // Status ändern
      _box.putAt(index, note); // Notiz in der Hive-Box aktualisieren
      notifyListeners();
    }
  }
}