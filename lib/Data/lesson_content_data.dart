import '../FrontEnd/screen/A1/Learn.dart';
import 'package:ductuch_master/backend/repository/learn_repository.dart';

class LessonContentData {
  static List<PhraseData>? getByTopicId(String topicId) {
    final raw = LearnRepository.getPhrasesRaw(topicId);
    if (raw != null) {
      return raw
          .map(
            (e) => PhraseData(
              phrase: (e['phrase'] ?? '').toString(),
              translation: (e['translation'] ?? '').toString(),
              meaning: (e['meaning'] ?? '').toString(),
              languageCode: (e['languageCode'] ?? 'de-DE').toString(),
              level: (e['level'] ?? '').toString(),
            ),
          )
          .toList();
    }
    return null;
  }

  // Map of topic ID to list of phrases
  static Map<String, List<PhraseData>> get topicContent => {
    // A1 Module 1: Hello!
    'A1-M1-T1': [
      // Greetings & Farewells
      PhraseData(
        phrase: "Guten Morgen!",
        translation: "Good morning!",
        meaning: "A common morning greeting (used until around noon).",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "Guten Tag!",
        translation: "Good day!",
        meaning: "A formal greeting used during the day.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "Guten Abend!",
        translation: "Good evening!",
        meaning: "A greeting used in the evening.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "Hallo!",
        translation: "Hello!",
        meaning: "A casual, friendly greeting.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "Auf Wiedersehen!",
        translation: "Goodbye!",
        meaning: "A formal way to say goodbye.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "Tschüss!",
        translation: "Bye!",
        meaning: "A casual way to say goodbye.",
        languageCode: "de-DE",
        level: "A1",
      ),
    ],
    'A1-M1-T2': [
      // The Alphabet & Pronunciation
      PhraseData(
        phrase: "A",
        translation: "A",
        meaning: "The first letter of the German alphabet.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "B",
        translation: "B",
        meaning: "The second letter of the German alphabet.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "C",
        translation: "C",
        meaning: "The third letter of the German alphabet.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "Ä",
        translation: "A-umlaut",
        meaning: "A special German letter with an umlaut.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "Ö",
        translation: "O-umlaut",
        meaning: "A special German letter with an umlaut.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "Ü",
        translation: "U-umlaut",
        meaning: "A special German letter with an umlaut.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "ß",
        translation: "Eszett",
        meaning: "A special German letter (sharp S).",
        languageCode: "de-DE",
        level: "A1",
      ),
    ],
    'A1-M1-T3': [
      // Numbers 0-20
      PhraseData(
        phrase: "null",
        translation: "zero",
        meaning: "The number 0.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "eins",
        translation: "one",
        meaning: "The number 1.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "zwei",
        translation: "two",
        meaning: "The number 2.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "drei",
        translation: "three",
        meaning: "The number 3.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "zehn",
        translation: "ten",
        meaning: "The number 10.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "zwanzig",
        translation: "twenty",
        meaning: "The number 20.",
        languageCode: "de-DE",
        level: "A1",
      ),
    ],
    // A1 Module 2: Me and You
    'A1-M2-T1': [
      // Personal Pronouns
      PhraseData(
        phrase: "ich",
        translation: "I",
        meaning: "First person singular pronoun.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "du",
        translation: "you (informal)",
        meaning: "Second person singular, informal.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "er",
        translation: "he",
        meaning: "Third person singular, masculine.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "sie",
        translation: "she",
        meaning: "Third person singular, feminine.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "es",
        translation: "it",
        meaning: "Third person singular, neuter.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "wir",
        translation: "we",
        meaning: "First person plural.",
        languageCode: "de-DE",
        level: "A1",
      ),
    ],
    'A1-M2-T2': [
      // Verbs: to be & to have
      PhraseData(
        phrase: "Ich bin",
        translation: "I am",
        meaning: "Conjugation of 'sein' (to be) for 'ich'.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "Du bist",
        translation: "You are",
        meaning: "Conjugation of 'sein' (to be) for 'du'.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "Er ist",
        translation: "He is",
        meaning: "Conjugation of 'sein' (to be) for 'er'.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "Ich habe",
        translation: "I have",
        meaning: "Conjugation of 'haben' (to have) for 'ich'.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "Du hast",
        translation: "You have",
        meaning: "Conjugation of 'haben' (to have) for 'du'.",
        languageCode: "de-DE",
        level: "A1",
      ),
    ],
    'A1-M2-T3': [
      // Introducing Yourself
      PhraseData(
        phrase: "Ich heiße Maria.",
        translation: "My name is Maria.",
        meaning: "A way to introduce yourself.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "Ich komme aus Deutschland.",
        translation: "I come from Germany.",
        meaning: "Stating your country of origin.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "Ich bin Studentin.",
        translation: "I am a student.",
        meaning: "Stating your occupation or status.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "Freut mich!",
        translation: "Nice to meet you!",
        meaning: "A polite response when meeting someone.",
        languageCode: "de-DE",
        level: "A1",
      ),
    ],
    'A1-M2-T4': [
      // Jobs & Nationalities
      PhraseData(
        phrase: "Ich bin Lehrer.",
        translation: "I am a teacher.",
        meaning: "Stating your profession.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "Ich bin Deutscher.",
        translation: "I am German.",
        meaning: "Stating your nationality (masculine).",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "Ich bin Deutsche.",
        translation: "I am German.",
        meaning: "Stating your nationality (feminine).",
        languageCode: "de-DE",
        level: "A1",
      ),
    ],
    // A1 Module 3: At Home and Out
    'A1-M3-T1': [
      // Articles (der, die, das)
      PhraseData(
        phrase: "der Tisch",
        translation: "the table",
        meaning: "Masculine article 'der' with noun 'Tisch'.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "die Tür",
        translation: "the door",
        meaning: "Feminine article 'die' with noun 'Tür'.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "das Buch",
        translation: "the book",
        meaning: "Neuter article 'das' with noun 'Buch'.",
        languageCode: "de-DE",
        level: "A1",
      ),
    ],
    'A1-M3-T2': [
      // Family & Hobbies
      PhraseData(
        phrase: "Meine Familie",
        translation: "My family",
        meaning: "Talking about family members.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "Ich lese gerne.",
        translation: "I like to read.",
        meaning: "Expressing a hobby or interest.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "Mein Hobby ist Musik.",
        translation: "My hobby is music.",
        meaning: "Stating your hobby.",
        languageCode: "de-DE",
        level: "A1",
      ),
    ],
    'A1-M3-T3': [
      // Food & Drinks
      PhraseData(
        phrase: "Ich möchte einen Kaffee.",
        translation: "I would like a coffee.",
        meaning: "Ordering in a café.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "Das Brot, bitte.",
        translation: "The bread, please.",
        meaning: "Ordering food politely.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "Guten Appetit!",
        translation: "Enjoy your meal!",
        meaning: "A common phrase before eating.",
        languageCode: "de-DE",
        level: "A1",
      ),
    ],
    'A1-M3-T4': [
      // Telling Time & Days
      PhraseData(
        phrase: "Wie spät ist es?",
        translation: "What time is it?",
        meaning: "Asking for the time.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "Es ist drei Uhr.",
        translation: "It is three o'clock.",
        meaning: "Telling the time.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "Montag",
        translation: "Monday",
        meaning: "The first day of the week.",
        languageCode: "de-DE",
        level: "A1",
      ),
    ],
    // A1 Module 4: Daily Life
    'A1-M4-T1': [
      // Regular Verbs
      PhraseData(
        phrase: "Ich lerne Deutsch.",
        translation: "I learn German.",
        meaning: "Present tense of regular verb 'lernen'.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "Du spielst Fußball.",
        translation: "You play soccer.",
        meaning: "Present tense of regular verb 'spielen'.",
        languageCode: "de-DE",
        level: "A1",
      ),
    ],
    'A1-M4-T2': [
      // Numbers 20-100
      PhraseData(
        phrase: "dreißig",
        translation: "thirty",
        meaning: "The number 30.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "fünfzig",
        translation: "fifty",
        meaning: "The number 50.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "hundert",
        translation: "one hundred",
        meaning: "The number 100.",
        languageCode: "de-DE",
        level: "A1",
      ),
    ],
    'A1-M4-T3': [
      // My City & Directions
      PhraseData(
        phrase: "Wo ist die Bank?",
        translation: "Where is the bank?",
        meaning: "Asking for directions.",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "Geradeaus",
        translation: "Straight ahead",
        meaning: "Giving directions.",
        languageCode: "de-DE",
        level: "A1",
      ),
    ],
    'A1-M4-T4': [
      // Modal Verbs
      PhraseData(
        phrase: "Ich kann schwimmen.",
        translation: "I can swim.",
        meaning: "Using modal verb 'können' (can).",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "Du musst lernen.",
        translation: "You must study.",
        meaning: "Using modal verb 'müssen' (must).",
        languageCode: "de-DE",
        level: "A1",
      ),
      PhraseData(
        phrase: "Ich möchte Kaffee.",
        translation: "I would like coffee.",
        meaning: "Using modal verb 'möchten' (would like).",
        languageCode: "de-DE",
        level: "A1",
      ),
    ],
    // A2 Module 5: My Routine
    'A2-M5-T1': [
      // Daily Schedule
      PhraseData(
        phrase: "Ich stehe um sieben Uhr auf.",
        translation: "I get up at seven o'clock.",
        meaning: "Describing daily routine.",
        languageCode: "de-DE",
        level: "A2",
      ),
      PhraseData(
        phrase: "Ich frühstücke um acht Uhr.",
        translation: "I have breakfast at eight o'clock.",
        meaning: "Describing morning routine.",
        languageCode: "de-DE",
        level: "A2",
      ),
    ],
    'A2-M5-T2': [
      // Separable Verbs
      PhraseData(
        phrase: "Ich stehe auf.",
        translation: "I get up.",
        meaning: "Separable verb 'aufstehen' (to get up).",
        languageCode: "de-DE",
        level: "A2",
      ),
      PhraseData(
        phrase: "Ich räume auf.",
        translation: "I clean up.",
        meaning: "Separable verb 'aufräumen' (to clean up).",
        languageCode: "de-DE",
        level: "A2",
      ),
    ],
    'A2-M5-T3': [
      // Accusative & Dative
      PhraseData(
        phrase: "Ich sehe den Mann.",
        translation: "I see the man.",
        meaning: "Accusative case with masculine article.",
        languageCode: "de-DE",
        level: "A2",
      ),
      PhraseData(
        phrase: "Ich gebe dem Kind ein Buch.",
        translation: "I give the child a book.",
        meaning: "Dative case with neuter article.",
        languageCode: "de-DE",
        level: "A2",
      ),
    ],
    'A2-M5-T4': [
      // Prepositions
      PhraseData(
        phrase: "Ich gehe in die Schule.",
        translation: "I go to school.",
        meaning: "Preposition 'in' with accusative.",
        languageCode: "de-DE",
        level: "A2",
      ),
      PhraseData(
        phrase: "Ich bin zu Hause.",
        translation: "I am at home.",
        meaning: "Preposition 'zu' with dative.",
        languageCode: "de-DE",
        level: "A2",
      ),
    ],
    // A2 Module 6: Shopping and More
    'A2-M6-T1': [
      // Clothing & Shopping
      PhraseData(
        phrase: "Ich kaufe ein Hemd.",
        translation: "I buy a shirt.",
        meaning: "Shopping for clothing.",
        languageCode: "de-DE",
        level: "A2",
      ),
      PhraseData(
        phrase: "Wie viel kostet das?",
        translation: "How much does that cost?",
        meaning: "Asking about price.",
        languageCode: "de-DE",
        level: "A2",
      ),
    ],
    'A2-M6-T2': [
      // Comparative & Superlative
      PhraseData(
        phrase: "Dieses Auto ist schneller.",
        translation: "This car is faster.",
        meaning: "Comparative form of 'schnell'.",
        languageCode: "de-DE",
        level: "A2",
      ),
      PhraseData(
        phrase: "Das ist das schnellste Auto.",
        translation: "This is the fastest car.",
        meaning: "Superlative form of 'schnell'.",
        languageCode: "de-DE",
        level: "A2",
      ),
    ],
    'A2-M6-T3': [
      // Money & Prices
      PhraseData(
        phrase: "Das kostet zwanzig Euro.",
        translation: "That costs twenty euros.",
        meaning: "Stating a price.",
        languageCode: "de-DE",
        level: "A2",
      ),
      PhraseData(
        phrase: "Ich zahle mit Karte.",
        translation: "I pay with card.",
        meaning: "Payment method.",
        languageCode: "de-DE",
        level: "A2",
      ),
    ],
    'A2-M6-T4': [
      // Past Tense (Perfekt)
      PhraseData(
        phrase: "Ich habe gelernt.",
        translation: "I have learned.",
        meaning: "Perfect tense with 'haben'.",
        languageCode: "de-DE",
        level: "A2",
      ),
      PhraseData(
        phrase: "Ich bin gegangen.",
        translation: "I have gone.",
        meaning: "Perfect tense with 'sein'.",
        languageCode: "de-DE",
        level: "A2",
      ),
    ],
    // A2 Module 7: Health and Feelings
    'A2-M7-T1': [
      // Body Parts & Health
      PhraseData(
        phrase: "Mein Kopf tut weh.",
        translation: "My head hurts.",
        meaning: "Describing pain.",
        languageCode: "de-DE",
        level: "A2",
      ),
      PhraseData(
        phrase: "Ich bin krank.",
        translation: "I am sick.",
        meaning: "Stating health condition.",
        languageCode: "de-DE",
        level: "A2",
      ),
    ],
    'A2-M7-T2': [
      // Emotions & Adjectives
      PhraseData(
        phrase: "Ich bin glücklich.",
        translation: "I am happy.",
        meaning: "Expressing emotion.",
        languageCode: "de-DE",
        level: "A2",
      ),
      PhraseData(
        phrase: "Ich fühle mich traurig.",
        translation: "I feel sad.",
        meaning: "Describing feelings.",
        languageCode: "de-DE",
        level: "A2",
      ),
    ],
    'A2-M7-T3': [
      // At the Doctor's
      PhraseData(
        phrase: "Ich habe Fieber.",
        translation: "I have a fever.",
        meaning: "Describing symptoms.",
        languageCode: "de-DE",
        level: "A2",
      ),
      PhraseData(
        phrase: "Was fehlt Ihnen?",
        translation: "What's wrong with you?",
        meaning: "Doctor asking about symptoms.",
        languageCode: "de-DE",
        level: "A2",
      ),
    ],
    'A2-M7-T4': [
      // Two-Way Prepositions
      PhraseData(
        phrase: "Das Buch liegt auf dem Tisch.",
        translation: "The book is on the table.",
        meaning: "Two-way preposition 'auf' with dative.",
        languageCode: "de-DE",
        level: "A2",
      ),
      PhraseData(
        phrase: "Ich lege das Buch auf den Tisch.",
        translation: "I put the book on the table.",
        meaning: "Two-way preposition 'auf' with accusative.",
        languageCode: "de-DE",
        level: "A2",
      ),
    ],
    // A2 Module 8: Travel and Stories
    'A2-M8-T1': [
      // Travel & Holidays
      PhraseData(
        phrase: "Ich fahre in den Urlaub.",
        translation: "I am going on vacation.",
        meaning: "Talking about travel plans.",
        languageCode: "de-DE",
        level: "A2",
      ),
      PhraseData(
        phrase: "Wo warst du?",
        translation: "Where were you?",
        meaning: "Asking about past travel.",
        languageCode: "de-DE",
        level: "A2",
      ),
    ],
    'A2-M8-T2': [
      // Narrating the Past
      PhraseData(
        phrase: "Gestern bin ich ins Kino gegangen.",
        translation: "Yesterday I went to the cinema.",
        meaning: "Narrating past events.",
        languageCode: "de-DE",
        level: "A2",
      ),
      PhraseData(
        phrase: "Dann habe ich gegessen.",
        translation: "Then I ate.",
        meaning: "Continuing a story in the past.",
        languageCode: "de-DE",
        level: "A2",
      ),
    ],
    'A2-M8-T3': [
      // Simple Past
      PhraseData(
        phrase: "Ich war zu Hause.",
        translation: "I was at home.",
        meaning: "Simple past of 'sein' (to be).",
        languageCode: "de-DE",
        level: "A2",
      ),
      PhraseData(
        phrase: "Ich hatte Zeit.",
        translation: "I had time.",
        meaning: "Simple past of 'haben' (to have).",
        languageCode: "de-DE",
        level: "A2",
      ),
    ],
    'A2-M8-T4': [
      // Weather & Seasons
      PhraseData(
        phrase: "Es regnet.",
        translation: "It is raining.",
        meaning: "Describing weather.",
        languageCode: "de-DE",
        level: "A2",
      ),
      PhraseData(
        phrase: "Der Frühling ist schön.",
        translation: "Spring is beautiful.",
        meaning: "Talking about seasons.",
        languageCode: "de-DE",
        level: "A2",
      ),
    ],
    // B1 Module 9: Working Life
    'B1-M9-T1': [
      // Writing Formal Emails
      PhraseData(
        phrase: "Sehr geehrte Damen und Herren,",
        translation: "Dear Sir or Madam,",
        meaning: "Formal email greeting.",
        languageCode: "de-DE",
        level: "B1",
      ),
      PhraseData(
        phrase: "Mit freundlichen Grüßen",
        translation: "Best regards",
        meaning: "Formal email closing.",
        languageCode: "de-DE",
        level: "B1",
      ),
    ],
    'B1-M9-T2': [
      // Job Applications
      PhraseData(
        phrase: "Ich bewerbe mich um die Stelle.",
        translation: "I am applying for the position.",
        meaning: "Job application phrase.",
        languageCode: "de-DE",
        level: "B1",
      ),
      PhraseData(
        phrase: "Ich habe Erfahrung in diesem Bereich.",
        translation: "I have experience in this field.",
        meaning: "Stating qualifications.",
        languageCode: "de-DE",
        level: "B1",
      ),
    ],
    'B1-M9-T3': [
      // Subordinate Clauses
      PhraseData(
        phrase: "Ich komme, weil ich Zeit habe.",
        translation: "I am coming because I have time.",
        meaning: "Subordinate clause with 'weil' (because).",
        languageCode: "de-DE",
        level: "B1",
      ),
      PhraseData(
        phrase: "Ich weiß, dass du recht hast.",
        translation: "I know that you are right.",
        meaning: "Subordinate clause with 'dass' (that).",
        languageCode: "de-DE",
        level: "B1",
      ),
    ],
    'B1-M9-T4': [
      // Reflexive Verbs
      PhraseData(
        phrase: "Ich wasche mich.",
        translation: "I wash myself.",
        meaning: "Reflexive verb 'sich waschen'.",
        languageCode: "de-DE",
        level: "B1",
      ),
      PhraseData(
        phrase: "Du interessierst dich für Musik.",
        translation: "You are interested in music.",
        meaning: "Reflexive verb 'sich interessieren'.",
        languageCode: "de-DE",
        level: "B1",
      ),
    ],
    // B1 Module 10: Media and Opinions
    'B1-M10-T1': [
      // Understanding News Headlines
      PhraseData(
        phrase: "Die Regierung beschließt neue Maßnahmen.",
        translation: "The government decides on new measures.",
        meaning: "News headline vocabulary.",
        languageCode: "de-DE",
        level: "B1",
      ),
      PhraseData(
        phrase: "Wahlen finden nächste Woche statt.",
        translation: "Elections take place next week.",
        meaning: "News headline structure.",
        languageCode: "de-DE",
        level: "B1",
      ),
    ],
    'B1-M10-T2': [
      // Expressing Opinions
      PhraseData(
        phrase: "Meiner Meinung nach ist das richtig.",
        translation: "In my opinion, that is correct.",
        meaning: "Expressing personal opinion.",
        languageCode: "de-DE",
        level: "B1",
      ),
      PhraseData(
        phrase: "Ich bin der Ansicht, dass...",
        translation: "I am of the opinion that...",
        meaning: "Formal way to express opinion.",
        languageCode: "de-DE",
        level: "B1",
      ),
    ],
    'B1-M10-T3': [
      // Passive Voice
      PhraseData(
        phrase: "Das Buch wird gelesen.",
        translation: "The book is being read.",
        meaning: "Passive voice in present tense.",
        languageCode: "de-DE",
        level: "B1",
      ),
      PhraseData(
        phrase: "Das Haus wurde gebaut.",
        translation: "The house was built.",
        meaning: "Passive voice in past tense.",
        languageCode: "de-DE",
        level: "B1",
      ),
    ],
    'B1-M10-T4': [
      // Prepositions with Genitive
      PhraseData(
        phrase: "Wegen des Wetters bleibe ich zu Hause.",
        translation: "Because of the weather, I stay at home.",
        meaning: "Preposition 'wegen' with genitive.",
        languageCode: "de-DE",
        level: "B1",
      ),
      PhraseData(
        phrase: "Trotz des Regens gehe ich raus.",
        translation: "Despite the rain, I go outside.",
        meaning: "Preposition 'trotz' with genitive.",
        languageCode: "de-DE",
        level: "B1",
      ),
    ],
    // B1 Module 11: Culture and Society
    'B1-M11-T1': [
      // German Customs & Culture
      PhraseData(
        phrase: "Das Oktoberfest ist ein wichtiges Fest.",
        translation: "Oktoberfest is an important festival.",
        meaning: "Talking about German culture.",
        languageCode: "de-DE",
        level: "B1",
      ),
      PhraseData(
        phrase: "In Deutschland isst man viel Brot.",
        translation: "In Germany, people eat a lot of bread.",
        meaning: "Describing cultural habits.",
        languageCode: "de-DE",
        level: "B1",
      ),
    ],
    'B1-M11-T2': [
      // Film & Book Reviews
      PhraseData(
        phrase: "Der Film war spannend.",
        translation: "The film was exciting.",
        meaning: "Giving a film review.",
        languageCode: "de-DE",
        level: "B1",
      ),
      PhraseData(
        phrase: "Ich empfehle dieses Buch.",
        translation: "I recommend this book.",
        meaning: "Making a recommendation.",
        languageCode: "de-DE",
        level: "B1",
      ),
    ],
    'B1-M11-T3': [
      // Adjective Endings
      PhraseData(
        phrase: "der gute Freund",
        translation: "the good friend",
        meaning: "Adjective ending with masculine article.",
        languageCode: "de-DE",
        level: "B1",
      ),
      PhraseData(
        phrase: "eine schöne Blume",
        translation: "a beautiful flower",
        meaning: "Adjective ending with feminine article.",
        languageCode: "de-DE",
        level: "B1",
      ),
    ],
    'B1-M11-T4': [
      // Relative Clauses
      PhraseData(
        phrase: "Der Mann, den ich gesehen habe, ist mein Lehrer.",
        translation: "The man whom I saw is my teacher.",
        meaning: "Relative clause with accusative relative pronoun.",
        languageCode: "de-DE",
        level: "B1",
      ),
      PhraseData(
        phrase: "Das Buch, das ich lese, ist interessant.",
        translation: "The book that I am reading is interesting.",
        meaning: "Relative clause with neuter relative pronoun.",
        languageCode: "de-DE",
        level: "B1",
      ),
    ],
    // B1 Module 12: Abstract Thinking
    'B1-M12-T1': [
      // Subjunctive Mood
      PhraseData(
        phrase: "Wenn ich Zeit hätte, würde ich reisen.",
        translation: "If I had time, I would travel.",
        meaning: "Konjunktiv II expressing wishes.",
        languageCode: "de-DE",
        level: "B1",
      ),
      PhraseData(
        phrase: "Ich wünschte, ich könnte fliegen.",
        translation: "I wish I could fly.",
        meaning: "Expressing wishes with Konjunktiv II.",
        languageCode: "de-DE",
        level: "B1",
      ),
    ],
    'B1-M12-T2': [
      // Complex Connectors
      PhraseData(
        phrase: "Trotzdem gehe ich zur Arbeit.",
        translation: "Nevertheless, I go to work.",
        meaning: "Connector expressing contrast.",
        languageCode: "de-DE",
        level: "B1",
      ),
      PhraseData(
        phrase: "Obwohl es regnet, gehe ich raus.",
        translation: "Although it is raining, I go outside.",
        meaning: "Connector expressing concession.",
        languageCode: "de-DE",
        level: "B1",
      ),
    ],
    'B1-M12-T3': [
      // Indirect Questions
      PhraseData(
        phrase: "Ich frage, ob du kommst.",
        translation: "I ask whether you are coming.",
        meaning: "Indirect question with 'ob'.",
        languageCode: "de-DE",
        level: "B1",
      ),
      PhraseData(
        phrase: "Ich weiß nicht, wann er kommt.",
        translation: "I don't know when he is coming.",
        meaning: "Indirect question with 'wann'.",
        languageCode: "de-DE",
        level: "B1",
      ),
    ],
    'B1-M12-T4': [
      // Writing a Short Essay
      PhraseData(
        phrase: "Zunächst möchte ich darauf hinweisen, dass...",
        translation: "First, I would like to point out that...",
        meaning: "Essay introduction phrase.",
        languageCode: "de-DE",
        level: "B1",
      ),
      PhraseData(
        phrase: "Zusammenfassend kann man sagen, dass...",
        translation: "In summary, one can say that...",
        meaning: "Essay conclusion phrase.",
        languageCode: "de-DE",
        level: "B1",
      ),
    ],
    // B2 Module 13: Precision and Style
    'B2-M13-T1': [
      // Synonyms & Stylistic Devices
      PhraseData(
        phrase: "Das ist sehr wichtig.",
        translation: "That is very important.",
        meaning: "Basic expression.",
        languageCode: "de-DE",
        level: "B2",
      ),
      PhraseData(
        phrase: "Das ist von großer Bedeutung.",
        translation: "That is of great importance.",
        meaning: "More sophisticated synonym.",
        languageCode: "de-DE",
        level: "B2",
      ),
    ],
    'B2-M13-T2': [
      // Formal vs. Informal Register
      PhraseData(
        phrase: "Kannst du mir helfen?",
        translation: "Can you help me?",
        meaning: "Informal register.",
        languageCode: "de-DE",
        level: "B2",
      ),
      PhraseData(
        phrase: "Könnten Sie mir bitte helfen?",
        translation: "Could you please help me?",
        meaning: "Formal register.",
        languageCode: "de-DE",
        level: "B2",
      ),
    ],
    'B2-M13-T3': [
      // Nominalization
      PhraseData(
        phrase: "Ich lerne.",
        translation: "I learn.",
        meaning: "Verb form.",
        languageCode: "de-DE",
        level: "B2",
      ),
      PhraseData(
        phrase: "Das Lernen ist wichtig.",
        translation: "Learning is important.",
        meaning: "Nominalized form (verb to noun).",
        languageCode: "de-DE",
        level: "B2",
      ),
    ],
    'B2-M13-T4': [
      // Participle Attributes
      PhraseData(
        phrase: "das gelesene Buch",
        translation: "the read book",
        meaning: "Past participle as attribute.",
        languageCode: "de-DE",
        level: "B2",
      ),
      PhraseData(
        phrase: "die laufende Maschine",
        translation: "the running machine",
        meaning: "Present participle as attribute.",
        languageCode: "de-DE",
        level: "B2",
      ),
    ],
    // B2 Module 14: Specialized Language
    'B2-M14-T1': [
      // Complex Topics
      PhraseData(
        phrase: "Die Klimapolitik ist ein komplexes Thema.",
        translation: "Climate policy is a complex topic.",
        meaning: "Discussing political topics.",
        languageCode: "de-DE",
        level: "B2",
      ),
      PhraseData(
        phrase: "Die Forschung zeigt interessante Ergebnisse.",
        translation: "Research shows interesting results.",
        meaning: "Academic language.",
        languageCode: "de-DE",
        level: "B2",
      ),
    ],
    'B2-M14-T2': [
      // Academic Vocabulary
      PhraseData(
        phrase: "Die Hypothese wurde bestätigt.",
        translation: "The hypothesis was confirmed.",
        meaning: "Academic terminology.",
        languageCode: "de-DE",
        level: "B2",
      ),
      PhraseData(
        phrase: "Die Studie analysiert verschiedene Faktoren.",
        translation: "The study analyzes various factors.",
        meaning: "Research vocabulary.",
        languageCode: "de-DE",
        level: "B2",
      ),
    ],
    'B2-M14-T3': [
      // Genitive Case in Depth
      PhraseData(
        phrase: "Das Auto meines Vaters",
        translation: "My father's car",
        meaning: "Genitive case showing possession.",
        languageCode: "de-DE",
        level: "B2",
      ),
      PhraseData(
        phrase: "Während des Gesprächs",
        translation: "During the conversation",
        meaning: "Genitive with preposition.",
        languageCode: "de-DE",
        level: "B2",
      ),
    ],
    'B2-M14-T4': [
      // Figurative Language
      PhraseData(
        phrase: "Er ist ein Fels in der Brandung.",
        translation: "He is a rock in the surf.",
        meaning: "Metaphor meaning someone is reliable.",
        languageCode: "de-DE",
        level: "B2",
      ),
      PhraseData(
        phrase: "Das ist ein Tropfen auf den heißen Stein.",
        translation: "That is a drop on the hot stone.",
        meaning: "Idiom meaning insufficient help.",
        languageCode: "de-DE",
        level: "B2",
      ),
    ],
    // B2 Module 15: Fluent Conversation
    'B2-M15-T1': [
      // Understanding Nuances
      PhraseData(
        phrase: "Das ist interessant.",
        translation: "That is interesting.",
        meaning: "Can be genuine or sarcastic depending on context.",
        languageCode: "de-DE",
        level: "B2",
      ),
      PhraseData(
        phrase: "Na ja, das ist so eine Sache.",
        translation: "Well, that's a thing.",
        meaning: "Expressing uncertainty or reservation.",
        languageCode: "de-DE",
        level: "B2",
      ),
    ],
    'B2-M15-T2': [
      // Idioms & Proverbs
      PhraseData(
        phrase: "Alles hat ein Ende, nur die Wurst hat zwei.",
        translation: "Everything has an end, only the sausage has two.",
        meaning: "German proverb meaning everything comes to an end.",
        languageCode: "de-DE",
        level: "B2",
      ),
      PhraseData(
        phrase: "Da liegt der Hund begraben.",
        translation: "That's where the dog is buried.",
        meaning: "Idiom meaning 'that's the real problem'.",
        languageCode: "de-DE",
        level: "B2",
      ),
    ],
    'B2-M15-T3': [
      // Spontaneous Speech
      PhraseData(
        phrase: "Moment, lass mich kurz überlegen.",
        translation: "Wait, let me think for a moment.",
        meaning: "Filler phrase for spontaneous speech.",
        languageCode: "de-DE",
        level: "B2",
      ),
      PhraseData(
        phrase: "Wie soll ich das ausdrücken?",
        translation: "How should I express that?",
        meaning: "Hesitation phrase in conversation.",
        languageCode: "de-DE",
        level: "B2",
      ),
    ],
    'B2-M15-T4': [
      // Regional Dialects
      PhraseData(
        phrase: "Grüß Gott!",
        translation: "Hello!",
        meaning: "Bavarian/Austrian greeting.",
        languageCode: "de-DE",
        level: "B2",
      ),
      PhraseData(
        phrase: "Moin!",
        translation: "Hello!",
        meaning: "Northern German greeting.",
        languageCode: "de-DE",
        level: "B2",
      ),
    ],
    // B2 Module 16: Expression and Analysis
    'B2-M16-T1': [
      // Writing Coherent Texts
      PhraseData(
        phrase: "Im Folgenden werde ich die wichtigsten Punkte erläutern.",
        translation:
            "In the following, I will explain the most important points.",
        meaning: "Structuring a written text.",
        languageCode: "de-DE",
        level: "B2",
      ),
      PhraseData(
        phrase: "Zusammenfassend lässt sich feststellen, dass...",
        translation: "In summary, it can be stated that...",
        meaning: "Conclusion phrase in essays.",
        languageCode: "de-DE",
        level: "B2",
      ),
    ],
    'B2-M16-T2': [
      // Analyzing Literary Excerpts
      PhraseData(
        phrase: "Der Autor verwendet Metaphern, um...",
        translation: "The author uses metaphors to...",
        meaning: "Literary analysis language.",
        languageCode: "de-DE",
        level: "B2",
      ),
      PhraseData(
        phrase: "Die Symbolik in diesem Text deutet auf...",
        translation: "The symbolism in this text suggests...",
        meaning: "Analyzing literary devices.",
        languageCode: "de-DE",
        level: "B2",
      ),
    ],
    'B2-M16-T3': [
      // All Tenses
      PhraseData(
        phrase: "Ich werde lernen.",
        translation: "I will learn.",
        meaning: "Future tense.",
        languageCode: "de-DE",
        level: "B2",
      ),
      PhraseData(
        phrase: "Ich hatte gelernt.",
        translation: "I had learned.",
        meaning: "Past perfect tense.",
        languageCode: "de-DE",
        level: "B2",
      ),
    ],
    'B2-M16-T4': [
      // Final Mastery
      PhraseData(
        phrase: "Ich beherrsche die deutsche Sprache.",
        translation: "I master the German language.",
        meaning: "Expressing language mastery.",
        languageCode: "de-DE",
        level: "B2",
      ),
      PhraseData(
        phrase: "Ich kann mich in allen Situationen ausdrücken.",
        translation: "I can express myself in all situations.",
        meaning: "Advanced language proficiency.",
        languageCode: "de-DE",
        level: "B2",
      ),
    ],
  };
}
