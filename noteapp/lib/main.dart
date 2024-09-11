import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'note_model.dart';
import 'note_provider.dart';
import 'theme_provider.dart';
import 'note_list_screen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Note>('notes');
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
            debugShowCheckedModeBanner: false,
            
            
            title: 'Notes App',
            
            theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
            // ignore: prefer_const_constructors
            home: NoteListScreen(),
          );
        },
      ),
    );
  }
}