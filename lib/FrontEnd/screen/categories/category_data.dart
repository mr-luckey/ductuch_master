import 'package:ductuch_master/FrontEnd/screen/categories/category_screen.dart';
import 'package:flutter/material.dart';

/// Category data model
class CategoryInfo {
  final String name;
  final IconData icon;
  final List<CategoryWord> words;

  CategoryInfo({
    required this.name,
    required this.icon,
    required this.words,
  });
}

/// Category Data - contains all category words
class CategoryData {
  static final List<CategoryInfo> categories = [
    CategoryInfo(
      name: 'Fruit Names',
      icon: Icons.apple,
      words: [
        CategoryWord(german: 'Der Apfel', english: 'the apple'),
        CategoryWord(german: 'Die Banane', english: 'the banana'),
        CategoryWord(german: 'Die Orange', english: 'the orange'),
        CategoryWord(german: 'Die Erdbeere', english: 'the strawberry'),
        CategoryWord(german: 'Die Traube', english: 'the grape'),
        CategoryWord(german: 'Die Kirsche', english: 'the cherry'),
        CategoryWord(german: 'Die Birne', english: 'the pear'),
        CategoryWord(german: 'Die Ananas', english: 'the pineapple'),
        CategoryWord(german: 'Die Mango', english: 'the mango'),
        CategoryWord(german: 'Die Kiwi', english: 'the kiwi'),
      ],
    ),
    CategoryInfo(
      name: 'Vegetable Names',
      icon: Icons.eco,
      words: [
        CategoryWord(german: 'Die Karotte', english: 'the carrot'),
        CategoryWord(german: 'Die Tomate', english: 'the tomato'),
        CategoryWord(german: 'Die Kartoffel', english: 'the potato'),
        CategoryWord(german: 'Die Zwiebel', english: 'the onion'),
        CategoryWord(german: 'Der Brokkoli', english: 'the broccoli'),
        CategoryWord(german: 'Die Gurke', english: 'the cucumber'),
        CategoryWord(german: 'Der Salat', english: 'the lettuce'),
        CategoryWord(german: 'Die Paprika', english: 'the bell pepper'),
        CategoryWord(german: 'Der Spinat', english: 'the spinach'),
        CategoryWord(german: 'Die Aubergine', english: 'the eggplant'),
      ],
    ),
    CategoryInfo(
      name: 'Material Names',
      icon: Icons.construction,
      words: [
        CategoryWord(german: 'Das Holz', english: 'the wood'),
        CategoryWord(german: 'Das Metall', english: 'the metal'),
        CategoryWord(german: 'Das Glas', english: 'the glass'),
        CategoryWord(german: 'Das Plastik', english: 'the plastic'),
        CategoryWord(german: 'Das Papier', english: 'the paper'),
        CategoryWord(german: 'Der Stein', english: 'the stone'),
        CategoryWord(german: 'Das Leder', english: 'the leather'),
        CategoryWord(german: 'Die Wolle', english: 'the wool'),
        CategoryWord(german: 'Die Baumwolle', english: 'the cotton'),
        CategoryWord(german: 'Das Eisen', english: 'the iron'),
      ],
    ),
    CategoryInfo(
      name: 'Days of the Week',
      icon: Icons.calendar_today,
      words: [
        CategoryWord(german: 'Montag', english: 'Monday'),
        CategoryWord(german: 'Dienstag', english: 'Tuesday'),
        CategoryWord(german: 'Mittwoch', english: 'Wednesday'),
        CategoryWord(german: 'Donnerstag', english: 'Thursday'),
        CategoryWord(german: 'Freitag', english: 'Friday'),
        CategoryWord(german: 'Samstag', english: 'Saturday'),
        CategoryWord(german: 'Sonntag', english: 'Sunday'),
      ],
    ),
    CategoryInfo(
      name: 'Season Names',
      icon: Icons.wb_sunny,
      words: [
        CategoryWord(german: 'Der Frühling', english: 'spring'),
        CategoryWord(german: 'Der Sommer', english: 'summer'),
        CategoryWord(german: 'Der Herbst', english: 'autumn'),
        CategoryWord(german: 'Der Winter', english: 'winter'),
      ],
    ),
    CategoryInfo(
      name: 'Month Names',
      icon: Icons.calendar_month,
      words: [
        CategoryWord(german: 'Januar', english: 'January'),
        CategoryWord(german: 'Februar', english: 'February'),
        CategoryWord(german: 'März', english: 'March'),
        CategoryWord(german: 'April', english: 'April'),
        CategoryWord(german: 'Mai', english: 'May'),
        CategoryWord(german: 'Juni', english: 'June'),
        CategoryWord(german: 'Juli', english: 'July'),
        CategoryWord(german: 'August', english: 'August'),
        CategoryWord(german: 'September', english: 'September'),
        CategoryWord(german: 'Oktober', english: 'October'),
        CategoryWord(german: 'November', english: 'November'),
        CategoryWord(german: 'Dezember', english: 'December'),
      ],
    ),
    CategoryInfo(
      name: 'Daily Use Things',
      icon: Icons.home,
      words: [
        CategoryWord(german: 'Der Stuhl', english: 'the chair'),
        CategoryWord(german: 'Der Tisch', english: 'the table'),
        CategoryWord(german: 'Das Bett', english: 'the bed'),
        CategoryWord(german: 'Die Lampe', english: 'the lamp'),
        CategoryWord(german: 'Der Kühlschrank', english: 'the refrigerator'),
        CategoryWord(german: 'Die Mikrowelle', english: 'the microwave'),
        CategoryWord(german: 'Der Fernseher', english: 'the television'),
        CategoryWord(german: 'Das Telefon', english: 'the phone'),
        CategoryWord(german: 'Die Uhr', english: 'the clock'),
        CategoryWord(german: 'Der Spiegel', english: 'the mirror'),
      ],
    ),
    CategoryInfo(
      name: 'Random Things',
      icon: Icons.category,
      words: [
        CategoryWord(german: 'Der Schlüssel', english: 'the key'),
        CategoryWord(german: 'Die Brille', english: 'the glasses'),
        CategoryWord(german: 'Die Tasche', english: 'the bag'),
        CategoryWord(german: 'Der Regenschirm', english: 'the umbrella'),
        CategoryWord(german: 'Die Sonnenbrille', english: 'the sunglasses'),
        CategoryWord(german: 'Die Kamera', english: 'the camera'),
        CategoryWord(german: 'Der Kugelschreiber', english: 'the pen'),
        CategoryWord(german: 'Das Notizbuch', english: 'the notebook'),
        CategoryWord(german: 'Die Flasche', english: 'the bottle'),
        CategoryWord(german: 'Die Tasse', english: 'the cup'),
      ],
    ),
  ];
}

