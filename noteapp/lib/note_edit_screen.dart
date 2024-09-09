import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'note_provider.dart';
import 'note_model.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class NoteEditScreen extends StatefulWidget {
  final Note? note;
  final int? index;
  final String currentLanguage; // Füge den Parameter für die aktuelle Sprache hinzu

  const NoteEditScreen({Key? key, this.note, this.index, required this.currentLanguage}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NoteEditScreenState createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  Map<String, String> _localizedStrings = {};

  @override
  void initState() {
    super.initState();
    _title = widget.note?.title ?? '';
    _description = widget.note?.description ?? '';
    loadJsonLanguage(widget.currentLanguage); // Die Sprache wird übergeben und verwendet
  }

  Future<void> loadJsonLanguage(String languageCode) async {
    String jsonString = await rootBundle.loadString('assets/lang/$languageCode.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    setState(() {
      _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
    });
  }

  String getTranslatedValue(String key) {
    return _localizedStrings[key] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null
            ? getTranslatedValue('add_note')
            : getTranslatedValue('edit_note')),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: getTranslatedValue('title_label')),
                onSaved: (value) {
                  _title = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return getTranslatedValue('empty_title_error');
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: getTranslatedValue('description_label')),
                onSaved: (value) {
                  _description = value ?? '';
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Note newNote = Note(
                      title: _title,
                      description: _description,
                      isCompleted: widget.note?.isCompleted ?? false,
                      createdDate: widget.note?.createdDate ?? DateTime.now(),
                    );
                    if (widget.note == null) {
                      Provider.of<NoteProvider>(context, listen: false).addNote(newNote);
                    } else {
                      Provider.of<NoteProvider>(context, listen: false)
                          .updateNoteAt(widget.index!, newNote);
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(getTranslatedValue('save_button')),
                  

              ),
            ],
          ),
        ),
      ),
    );
  }
}

