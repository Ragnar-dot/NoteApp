# noteapp

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



Wo genau werden die Daten gespeichert? ( Hive)  

	•	Dateispeicherort: Hive speichert die Daten in Dateien auf dem Gerät. Der genaue Speicherort hängt vom Betriebssystem des Geräts ab:
	•	Android: Die Daten werden im App-spezifischen Speicher unter data/data/<dein_package_name>/files abgelegt.
	•	iOS: Auf iOS-Geräten werden die Daten im Dokumentenverzeichnis der App gespeichert, das sich unter Documents befindet.
Du brauchst dich jedoch nicht um den genauen Speicherort zu kümmern, da Hive diese Details für dich verwaltet. Die Daten bleiben lokal auf dem Gerät gespeichert.

Wie funktioniert die Speicherung?

	1.	Hive-Boxen: Hive verwendet sogenannte Boxen, um Daten zu speichern. Eine Box ist wie eine Tabelle oder Sammlung in einer Datenbank. In deinem Fall hast du eine Box für die Notizen (notes), die die einzelnen Notizobjekte speichert.
	2.	Binäre Speicherung: Hive speichert die Daten als binäre Dateien, die effizient und schnell gelesen und geschrieben werden können. Jede Box wird in einer separaten Datei gespeichert.