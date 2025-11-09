import 'package:ductuch_master/Utilities/Models/model.dart';
import 'package:flutter/material.dart';

class LearningPathData {
  static Map<String, LevelInfo> get levelInfo => {
    'a1': LevelInfo(
      ID: 'A1',
      title: 'A1 - Beginner',
      description:
          'Master basic greetings, self-introductions, daily routines, and essential vocabulary.',
      progress: 0,
      modules: [
        ModuleInfo(
          ID: 'A1-M1',
          title: '👋 Module 1: Hello!',
          lessonCount:
              3, // This is actually topicCount (3 topics: Greetings, Alphabet, Numbers)
          completedLessons: 0,
          icon: Icons.waving_hand,
          isLocked: false,
        ),
        ModuleInfo(
          ID: 'A1-M2',
          title: '👤 Module 2: Me and You',
          lessonCount: 4, // This is actually topicCount (4 topics)
          completedLessons: 0,
          icon: Icons.person,
          isLocked: false,
        ),
        ModuleInfo(
          ID: 'A1-M3',
          title: '🏠 Module 3: At Home and Out',
          lessonCount: 4, // This is actually topicCount (4 topics)
          completedLessons: 0,
          icon: Icons.home,
          isLocked: false,
        ),
        ModuleInfo(
          ID: 'A1-M4',
          title: '📅 Module 4: Daily Life',
          lessonCount: 4, // This is actually topicCount (4 topics)
          completedLessons: 0,
          icon: Icons.calendar_today,
          isLocked: false,
        ),
      ],
    ),
    'a2': LevelInfo(
      ID: 'A2',
      title: 'A2 - Elementary',
      description:
          'Build on your foundation with daily routines, shopping, health topics, and travel stories.',
      progress: 0,
      modules: [
        ModuleInfo(
          ID: 'A2-M5',
          title: '🗓️ Module 5: My Routine',
          lessonCount: 4,
          completedLessons: 0,
          icon: Icons.schedule,
          isLocked: false,
        ),
        ModuleInfo(
          ID: 'A2-M6',
          title: '🛍️ Module 6: Shopping and More',
          lessonCount: 4,
          completedLessons: 0,
          icon: Icons.shopping_bag,
          isLocked: false,
        ),
        ModuleInfo(
          ID: 'A2-M7',
          title: '❤️ Module 7: Health and Feelings',
          lessonCount: 4,
          completedLessons: 0,
          icon: Icons.favorite,
          isLocked: false,
        ),
        ModuleInfo(
          ID: 'A2-M8',
          title: '✈️ Module 8: Travel and Stories',
          lessonCount: 4,
          completedLessons: 0,
          icon: Icons.flight,
          isLocked: false,
        ),
      ],
    ),
    'b1': LevelInfo(
      ID: 'B1',
      title: 'B1 - Intermediate',
      description:
          'Advance your skills with working life, media, culture, and abstract thinking.',
      progress: 0,
      modules: [
        ModuleInfo(
          ID: 'B1-M9',
          title: '💼 Module 9: Working Life',
          lessonCount: 4,
          completedLessons: 0,
          icon: Icons.business_center,
          isLocked: false,
        ),
        ModuleInfo(
          ID: 'B1-M10',
          title: '📰 Module 10: Media and Opinions',
          lessonCount: 4,
          completedLessons: 0,
          icon: Icons.newspaper,
          isLocked: false,
        ),
        ModuleInfo(
          ID: 'B1-M11',
          title: '🎭 Module 11: Culture and Society',
          lessonCount: 4,
          completedLessons: 0,
          icon: Icons.theater_comedy,
          isLocked: false,
        ),
        ModuleInfo(
          ID: 'B1-M12',
          title: '💭 Module 12: Abstract Thinking',
          lessonCount: 4,
          completedLessons: 0,
          icon: Icons.psychology,
          isLocked: false,
        ),
      ],
    ),
    'b2': LevelInfo(
      ID: 'B2',
      title: 'B2 - Upper Intermediate',
      description:
          'Master precision, specialized language, fluent conversation, and advanced expression.',
      progress: 0,
      modules: [
        ModuleInfo(
          ID: 'B2-M13',
          title: '🎯 Module 13: Precision and Style',
          lessonCount: 4,
          completedLessons: 0,
          icon: Icons.precision_manufacturing,
          isLocked: false,
        ),
        ModuleInfo(
          ID: 'B2-M14',
          title: '🔬 Module 14: Specialized Language',
          lessonCount: 4,
          completedLessons: 0,
          icon: Icons.science,
          isLocked: false,
        ),
        ModuleInfo(
          ID: 'B2-M15',
          title: '💬 Module 15: Fluent Conversation',
          lessonCount: 4,
          completedLessons: 0,
          icon: Icons.chat_bubble_outline,
          isLocked: false,
        ),
        ModuleInfo(
          ID: 'B2-M16',
          title: '✍️ Module 16: Expression and Analysis',
          lessonCount: 4,
          completedLessons: 0,
          icon: Icons.edit_note,
          isLocked: false,
        ),
      ],
    ),
    // C1 and C2 are empty for now - will be added later
    'c1': LevelInfo(
      ID: 'C1',
      title: 'C1 - Advanced',
      description: 'Coming soon...',
      progress: 0,
      modules: [],
    ),
    'c2': LevelInfo(
      ID: 'C2',
      title: 'C2 - Mastery',
      description: 'Coming soon...',
      progress: 0,
      modules: [],
    ),
  };

  // Topics for each module (Level → Module → Topic)
  static Map<String, List<String>> get moduleTopics => {
    // A1 Module 1: Hello!
    'A1-M1': [
      'Greetings & Farewells',
      'The Alphabet & Pronunciation',
      'Numbers 0-20',
    ],
    // A1 Module 2: Me and You
    'A1-M2': [
      'Personal Pronouns (I, you, he, she...)',
      'Verbs: `to be` (sein) & `to have` (haben)',
      'Introducing Yourself',
      'Jobs & Nationalities',
    ],
    // A1 Module 3: At Home and Out
    'A1-M3': [
      'Articles (der, die, das)',
      'Family & Hobbies',
      'Food & Drinks (In a Café)',
      'Telling Time & Days of the Week',
    ],
    // A1 Module 4: Daily Life
    'A1-M4': [
      'Regular Verbs (Present Tense)',
      'Numbers 20-100',
      'My City & Directions',
      'Modal Verbs (can, must, want...)',
    ],
    // A2 Module 5: My Routine
    'A2-M5': [
      'Daily Schedule',
      'Separable Verbs',
      'Accusative & Dative Cases',
      'Prepositions (in, on, at, to...)',
    ],
    // A2 Module 6: Shopping and More
    'A2-M6': [
      'Clothing & Shopping',
      'Comparative & Superlative',
      'Money & Prices',
      'Past Tense (Perfekt)',
    ],
    // A2 Module 7: Health and Feelings
    'A2-M7': [
      'Body Parts & Health',
      'Emotions & Adjectives',
      'At the Doctor\'s',
      'Two-Way Prepositions',
    ],
    // A2 Module 8: Travel and Stories
    'A2-M8': [
      'Travel & Holidays',
      'Narrating the Past',
      'Simple Past (Präteritum) of `to be` & `to have`',
      'Weather & Seasons',
    ],
    // B1 Module 9: Working Life
    'B1-M9': [
      'Writing Formal Emails',
      'Job Applications',
      'Subordinate Clauses (because, that, if)',
      'Reflexive Verbs',
    ],
    // B1 Module 10: Media and Opinions
    'B1-M10': [
      'Understanding News Headlines',
      'Expressing Opinions & Debating',
      'Passive Voice',
      'Prepositions with Genitive',
    ],
    // B1 Module 11: Culture and Society
    'B1-M11': [
      'German Customs & Culture',
      'Film & Book Reviews',
      'Adjective Endings',
      'Relative Clauses',
    ],
    // B1 Module 12: Abstract Thinking
    'B1-M12': [
      'Discussing Dreams & Hopes (Subjunctive Mood - Konjunktiv II)',
      'Complex Connectors (therefore, despite, although)',
      'Indirect Questions',
      'Writing a Short Essay',
    ],
    // B2 Module 13: Precision and Style
    'B2-M13': [
      'Synonyms & Stylistic Devices',
      'Formal vs. Informal Register',
      'Nominalization (Turning verbs into nouns)',
      'Participle Attributes',
    ],
    // B2 Module 14: Specialized Language
    'B2-M14': [
      'Discussing Complex Topics (Politics, Science)',
      'Academic Vocabulary',
      'Genitive Case in Depth',
      'Figurative Language',
    ],
    // B2 Module 15: Fluent Conversation
    'B2-M15': [
      'Understanding Nuances & Humor',
      'Idioms & Proverbs',
      'Spontaneous Speech Practice',
      'Regional Dialects',
    ],
    // B2 Module 16: Expression and Analysis
    'B2-M16': [
      'Writing Coherent Texts (Reports, Stories)',
      'Analyzing Literary Excerpts',
      'All Tenses (Active & Passive)',
      'Final Mastery & Review',
    ],
    // C1 and C2 topics will be added later when modules are defined
  };
}
