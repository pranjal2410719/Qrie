import 'package:flutter/material.dart';
import '../models/student_profile.dart';
import '../models/subject.dart';
import '../models/chapter.dart';
import '../models/lesson.dart';
import '../models/quiz_question.dart';
import '../models/doubt_message.dart';
import '../theme/app_colors.dart';

class MockData {
  MockData._();

  static StudentProfile initialStudent = const StudentProfile(
    id: 'student_1',
    name: 'Aarav Sharma',
    grade: 'Class 8',
    board: 'CBSE',
    streakDays: 6,
    totalXp: 1420,
    gems: 380,
    dailyGoalCurrent: 2,
    dailyGoalTarget: 3,
    completedLessonIds: {
      'sci_ch1_les1',
      'sci_ch1_les2',
      'math_ch1_les1',
      'math_ch1_les2',
      'math_ch1_les3',
      'phy_ch1_les1',
    },
    bookmarkedLessonIds: {
      'sci_ch1_les3',
      'math_ch1_les2',
    },
  );

  static const List<Subject> subjects = [
    Subject(
      id: 'math',
      name: 'Mathematics',
      imageUrl: 'https://images.unsplash.com/photo-1635070041078-e363dbe005cb?auto=format&fit=crop&w=400&q=80',
      icon: Icons.square_foot_rounded,
      primaryColor: AppColors.sparkBlue,
      shadowColor: AppColors.sparkBlueDark,
      chaptersCount: 14,
      progress: 0.65,
      tagLine: 'Linear equations, Geometry & Powers',
    ),
    Subject(
      id: 'science',
      name: 'Science & Bio',
      imageUrl: 'https://images.unsplash.com/photo-1532094349884-543bc11b234d?auto=format&fit=crop&w=400&q=80',
      icon: Icons.biotech_rounded,
      primaryColor: AppColors.eagerGreen,
      shadowColor: AppColors.eagerGreenDark,
      chaptersCount: 16,
      progress: 0.50,
      tagLine: 'Cell structure, Microorganisms & Life',
    ),
    Subject(
      id: 'physics',
      name: 'Physics',
      imageUrl: 'https://images.unsplash.com/photo-1507668077129-56e32842fceb?auto=format&fit=crop&w=400&q=80',
      icon: Icons.speed_rounded,
      primaryColor: AppColors.fireOrange,
      shadowColor: AppColors.fireOrangeDark,
      chaptersCount: 12,
      progress: 0.35,
      tagLine: 'Force, Pressure, Sound & Light',
    ),
    Subject(
      id: 'chemistry',
      name: 'Chemistry',
      imageUrl: 'https://images.unsplash.com/photo-1603126857599-f6e157fa2fe6?auto=format&fit=crop&w=400&q=80',
      icon: Icons.science_rounded,
      primaryColor: AppColors.royalPurple,
      shadowColor: Color(0xFF9E4BDB),
      chaptersCount: 10,
      progress: 0.20,
      tagLine: 'Synthetic fibres, Metals & Non-metals',
    ),
    Subject(
      id: 'social',
      name: 'Social Studies',
      imageUrl: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?auto=format&fit=crop&w=400&q=80',
      icon: Icons.public_rounded,
      primaryColor: Color(0xFF00C7A9),
      shadowColor: Color(0xFF009882),
      chaptersCount: 15,
      progress: 0.40,
      tagLine: 'Modern India, Resources & Judiciary',
    ),
  ];

  static const List<Chapter> chapters = [
    Chapter(
      id: 'sci_ch1',
      subjectId: 'science',
      title: 'Chapter 1: Cell — Structure & Functions',
      subtitle: 'The fundamental unit of all living organisms',
      icon: Icons.lens_blur_rounded,
      order: 1,
      isUnlocked: true,
      lessons: [
        Lesson(
          id: 'sci_ch1_les1',
          chapterId: 'sci_ch1',
          title: 'Discovery of the Cell',
          subtitle: 'Robert Hooke & Cork slices in 1665',
          type: LessonType.video,
          durationMinutes: 7,
          xpReward: 20,
          keyPoints: [
            'Robert Hooke observed honeycomb-like compartments in 1665.',
            'He coined the term "cell" from Latin "cellula" (little rooms).',
            'Anton van Leeuwenhoek later discovered free living cells in pond water.',
          ],
          summaryText:
              'All living organisms are made up of basic building blocks called cells. Some organisms consist of a single cell (unicellular like Amoeba), while others consist of trillions of cells (multicellular like humans).',
          funFact: 'An ostrich egg is the largest single cell known to science!',
        ),
        Lesson(
          id: 'sci_ch1_les2',
          chapterId: 'sci_ch1',
          title: 'Parts of a Cell & Membrane',
          subtitle: 'Plasma membrane, Cytoplasm & Nucleus',
          type: LessonType.interactive,
          durationMinutes: 10,
          xpReward: 25,
          keyPoints: [
            'Plasma membrane is selectively permeable.',
            'Cytoplasm contains jelly-like fluid with organelles.',
            'Nucleus acts as the command brain containing chromosomes (DNA).',
          ],
          summaryText:
              'The three essential parts of every typical cell are the cell membrane (boundary), cytoplasm (fluid workspace), and the nucleus (genetic master controller).',
          funFact: 'Your body produces about 2 million new red blood cells every second!',
        ),
        Lesson(
          id: 'sci_ch1_les3',
          chapterId: 'sci_ch1',
          title: 'Plant vs Animal Cells',
          subtitle: 'Cell walls, Chloroplasts & Large Vacuoles',
          type: LessonType.video,
          durationMinutes: 9,
          xpReward: 30,
          keyPoints: [
            'Plant cells have a rigid outer Cell Wall made of cellulose.',
            'Chloroplasts with green chlorophyll enable photosynthesis.',
            'Plant cells contain one huge central vacuole; animal cells have tiny vacuoles.',
          ],
          summaryText:
              'Plant cells require extra structural rigidity against wind and climate variations, which is provided by the cell wall. They also capture solar photons via chloroplasts.',
          funFact: 'Without chloroplasts, Earth would have run out of oxygen billions of years ago!',
        ),
        Lesson(
          id: 'sci_ch1_les4',
          chapterId: 'sci_ch1',
          title: 'Cell Powerhouse: Mitochondria & Organelles',
          subtitle: 'ATP energy factories and protein synthesis',
          type: LessonType.interactive,
          durationMinutes: 12,
          xpReward: 35,
          keyPoints: [
            'Mitochondria produce ATP (adenosine triphosphate) energy.',
            'Endoplasmic Reticulum transports proteins and lipids.',
            'Lysosomes are known as the suicide bags of the cell.',
          ],
          summaryText:
              'Organelles are specialized sub-units within a cell that carry out distinct functions like energy manufacturing, packaging, and waste cleanup.',
          funFact: 'Mitochondria have their own unique DNA inherited only from mothers!',
        ),
        Lesson(
          id: 'sci_ch1_les5',
          chapterId: 'sci_ch1',
          title: 'Chapter Mastery Challenge',
          subtitle: 'Prove your knowledge & earn the Cell Master badge',
          type: LessonType.quiz,
          durationMinutes: 15,
          xpReward: 50,
          keyPoints: [
            'Test covers discovery, organelles, plant vs animal comparisons.',
            'Score 80%+ to unlock Chapter 2: Microorganisms Friend & Foe.',
          ],
          summaryText:
              'A fast-paced diagnostic checkpoint to lock in your conceptual clarity and boost your school exam readiness.',
          funFact: 'Students who complete chapter challenges retain concepts 3.4x longer!',
        ),
      ],
    ),
    Chapter(
      id: 'math_ch1',
      subjectId: 'math',
      title: 'Chapter 2: Linear Equations in One Variable',
      subtitle: 'Balancing the scales of algebraic expressions',
      icon: Icons.functions_rounded,
      order: 2,
      isUnlocked: true,
      lessons: [
        Lesson(
          id: 'math_ch1_les1',
          chapterId: 'math_ch1',
          title: 'What is an Algebraic Equation?',
          subtitle: 'Variables, coefficients, and the equals sign',
          type: LessonType.video,
          durationMinutes: 8,
          xpReward: 20,
          keyPoints: [
            'An equation states that two mathematical expressions are equal.',
            'Linear equations have power/exponent of the variable equal to 1.',
            'Solving means finding the value that makes LHS = RHS true.',
          ],
          summaryText:
              'Think of an algebraic equation as a balancing scale. Whatever operation you perform on one side (+, -, ×, ÷), you must perform identically on the other side to keep balance.',
          funFact: 'The word "Algebra" comes from the Arabic "al-jabr", meaning "reunion of broken parts"!',
        ),
        Lesson(
          id: 'math_ch1_les2',
          chapterId: 'math_ch1',
          title: 'Solving by Transposition',
          subtitle: 'Moving terms across the equals sign seamlessly',
          type: LessonType.interactive,
          durationMinutes: 11,
          xpReward: 25,
          keyPoints: [
            'When moving a term across "=", "+" becomes "-", and "-" becomes "+".',
            'Multiplication turns into division, and vice versa.',
            'Group all variable terms on one side, constants on the other.',
          ],
          summaryText:
              'Transposition is just a handy shortcut for performing the exact same operation on both sides of the equal sign simultaneously.',
          funFact: 'Computers solve billions of linear equations every second to render 3D games!',
        ),
        Lesson(
          id: 'math_ch1_les3',
          chapterId: 'math_ch1',
          title: 'Equations with Variables on Both Sides',
          subtitle: 'Example: 2x - 3 = x + 2',
          type: LessonType.video,
          durationMinutes: 10,
          xpReward: 30,
          keyPoints: [
            'Subtract smaller variable term from both sides.',
            'Isolate the coefficient and solve for x.',
            'Always plug the answer back in to verify LHS = RHS.',
          ],
          summaryText:
              'Example walkthrough: 2x - 3 = x + 2. Subtract x: x - 3 = 2. Add 3: x = 5. Verify: 2(5)-3 = 7, and 5+2 = 7! Perfect balance.',
          funFact: 'Aryabhata in 499 CE described systematic steps to solve linear indeterminate equations.',
        ),
        Lesson(
          id: 'math_ch1_les4',
          chapterId: 'math_ch1',
          title: 'Word Problems: Age & Number Puzzles',
          subtitle: 'Translate real-world English into equations',
          type: LessonType.interactive,
          durationMinutes: 14,
          xpReward: 35,
          keyPoints: [
            'Step 1: Identify what is unknown and label it "x".',
            'Step 2: Express given conditions mathematically.',
            'Step 3: Solve and check if the result makes real-world sense.',
          ],
          summaryText:
              'The secret to cracking math word problems is reading sentence by sentence: "Sum of two numbers is 95" -> x + (x+15) = 95.',
          funFact: 'Riddles written on ancient Egyptian papyrus 3,600 years ago used this exact method!',
        ),
      ],
    ),
    Chapter(
      id: 'phy_ch1',
      subjectId: 'physics',
      title: 'Chapter 3: Force & Pressure',
      subtitle: 'Pushes, pulls, and contact vs non-contact forces',
      icon: Icons.speed_rounded,
      order: 3,
      isUnlocked: true,
      lessons: [
        Lesson(
          id: 'phy_ch1_les1',
          chapterId: 'phy_ch1',
          title: 'What is Force? Push or Pull',
          subtitle: 'Direction, magnitude, and net force vectors',
          type: LessonType.video,
          durationMinutes: 8,
          xpReward: 20,
          keyPoints: [
            'A force is a push or pull on an object resulting from interaction.',
            'Forces applied in the same direction add up: F_net = F1 + F2.',
            'Opposite forces subtract from each other.',
          ],
          summaryText:
              'Force has both magnitude and direction. It can change an object’s state of motion, speed, or its physical shape.',
          funFact: 'The SI unit of force is named Newton (N) after Sir Isaac Newton!',
        ),
        Lesson(
          id: 'phy_ch1_les2',
          chapterId: 'phy_ch1',
          title: 'Atmospheric Pressure & Barometers',
          subtitle: 'The heavy ocean of air above our heads',
          type: LessonType.interactive,
          durationMinutes: 10,
          xpReward: 30,
          keyPoints: [
            'Pressure = Force / Area (P = F / A).',
            'Smaller area causes much higher pressure (sharp knife cuts easily).',
            'Atmosphere exerts ~101.3 kPa pressure on every square meter at sea level.',
          ],
          summaryText:
              'We don’t feel crushed by atmospheric pressure because the pressure of blood and fluids inside our body balances it equally from within!',
          funFact: 'Suction cups stick because air pressure outside pushes them firmly against smooth glass!',
        ),
      ],
    ),
  ];

  static const List<QuizQuestion> quizQuestions = [
    QuizQuestion(
      id: 'q1',
      subjectId: 'science',
      question: 'Which organelle is universally known as the "Powerhouse of the Cell"?',
      options: [
        'Ribosome',
        'Mitochondria',
        'Golgi Apparatus',
        'Endoplasmic Reticulum',
      ],
      correctIndex: 1,
      rethinkPrompt: 'Think about which organelle creates the fuel molecules used whenever you run or play.',
      hint: 'It synthesizes energy packets known as ATP molecules.',
      scaffoldSubstep: 'Step: Cellular respiration takes place inside this double-membraned organelle to release ATP.',
      explanation:
          'Mitochondria are called the powerhouse of the cell because they produce energy in the form of ATP (Adenosine Triphosphate) through cellular respiration.',
      xpReward: 20,
      category: 'Cell Biology',
    ),
    QuizQuestion(
      id: 'q2',
      subjectId: 'science',
      question: 'What is the rigid outer layer found exclusively in plant cells but absent in animal cells?',
      options: [
        'Plasma Membrane',
        'Nuclear Envelope',
        'Cell Wall',
        'Cytoskeleton',
      ],
      correctIndex: 2,
      rethinkPrompt: 'Notice the question says "rigid outer layer" that animal cells do not possess.',
      hint: 'It is made of cellulose and provides mechanical protection against weather.',
      scaffoldSubstep: 'Plant cells have a cell membrane inside, but outside of it lies this rigid wall.',
      explanation:
          'Plant cells have an extra tough outer layer called the Cell Wall made of cellulose to withstand osmotic pressure and environmental conditions.',
      xpReward: 20,
      category: 'Plant Anatomy',
    ),
    QuizQuestion(
      id: 'q3',
      subjectId: 'math',
      question: 'Solve for x in the linear equation: 3x - 5 = 16',
      options: [
        'x = 5',
        'x = 6',
        'x = 7',
        'x = 8',
      ],
      correctIndex: 2,
      rethinkPrompt: 'To isolate the x term, what operation should you perform to remove the -5?',
      hint: 'Add 5 to both sides first: 3x = 21, then divide by 3.',
      scaffoldSubstep: 'Step 1: 3x = 16 + 5 = 21.\nStep 2: Divide both sides by 3.',
      explanation:
          '3x - 5 = 16 ➔ 3x = 16 + 5 ➔ 3x = 21 ➔ x = 21 / 3 = 7. Excellent algebraic transposition!',
      xpReward: 25,
      category: 'Algebra',
    ),
    QuizQuestion(
      id: 'q4',
      subjectId: 'physics',
      question: 'If a force of 50 N acts perpendicular to an area of 2 m², calculate the pressure generated (in Pascals):',
      questionType: QuestionType.numeric,
      numericAnswer: 25.0,
      options: [
        '25 Pascals (N/m²)',
        '100 Pascals (N/m²)',
        '50 Pascals (N/m²)',
        '10 Pascals (N/m²)',
      ],
      correctIndex: 0,
      rethinkPrompt: 'What is the formula relating Force, Area, and Pressure?',
      hint: 'Pressure = Force divided by Area (P = F / A). Divide 50 by 2.',
      scaffoldSubstep: 'Substitute values: P = 50 N / 2 m² = ?',
      explanation:
          'Pressure P = Force / Area = 50 N / 2 m² = 25 N/m² or 25 Pa. Sharp mathematical thinking!',
      xpReward: 20,
      category: 'Pressure & Forces',
    ),
    QuizQuestion(
      id: 'q5',
      subjectId: 'science',
      question: 'Which green pigment traps sunlight inside chloroplasts during photosynthesis?',
      options: [
        'Hemoglobin',
        'Chlorophyll',
        'Carotene',
        'Melanin',
      ],
      correctIndex: 1,
      rethinkPrompt: 'Look at the root words: "chloro" comes from Greek for green.',
      hint: 'It is responsible for giving plant leaves their bright green color.',
      scaffoldSubstep: 'This molecule absorbs blue and red wavelengths while reflecting green light.',
      explanation:
          'Chlorophyll is the green pigment in chloroplasts that absorbs light energy to drive the chemical conversion of CO2 and water into glucose and oxygen.',
      xpReward: 20,
      category: 'Photosynthesis',
    ),
  ];

  static final List<DoubtMessage> initialDoubtMessages = [
    DoubtMessage(
      id: 'dm_0',
      text:
          'Hi Aarav! I am Qrie, your school AI tutor. Ask me any school doubt, upload a question from your book, or select a topic below to explore step-by-step.',
      isStudent: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      followUpSuggestions: const [
        'How does a cell membrane control what enters?',
        'Solve 5x + 3 = 2x + 18 step by step',
        'Why does a sharp knife cut better than a blunt knife?',
      ],
    ),
    DoubtMessage(
      id: 'dm_1',
      text: 'Why does a sharp knife cut much better than a blunt knife?',
      isStudent: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
    ),
    DoubtMessage(
      id: 'dm_2',
      text:
          'Great physics question! It is completely based on the formula of Pressure:\n\nPressure = Force / Area (P = F / A)\n\n• A sharp knife has an extremely thin, tiny edge (very small contact area A).\n• When you apply normal cutting force with your hand, the small area creates ENORMOUS pressure on the vegetable!\n• A blunt knife has a rounded, thicker edge (larger area), so the pressure created is much smaller for the same force.',
      isStudent: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 11)),
      formulaOrSnippet: 'P = F / A  (where A ↓ implies P ↑)',
      keyConcept: 'Inverse relationship between Area and Pressure',
      followUpSuggestions: const [
        'Why do heavy trucks have 10-14 wide tires?',
        'Calculate pressure if force = 80N and area = 0.04 m²',
      ],
    ),
  ];

  static const List<Map<String, dynamic>> formulaCards = [
    {
      'subject': 'Physics',
      'title': 'Pressure Formula',
      'formula': 'P = Force / Area = F / A',
      'unit': 'Pascal (Pa) or N/m²',
      'tip': 'Halving the contact area doubles the pressure exerted!',
    },
    {
      'subject': 'Physics',
      'title': 'Speed & Velocity',
      'formula': 'Speed = Distance / Time  (v = d / t)',
      'unit': 'm/s or km/h',
      'tip': 'To convert km/h to m/s, multiply by 5/18.',
    },
    {
      'subject': 'Mathematics',
      'title': 'Linear Equation Standard Form',
      'formula': 'ax + b = c  ➔  x = (c - b) / a',
      'unit': 'Algebraic root',
      'tip': 'Always verify LHS equals RHS after computing your answer.',
    },
    {
      'subject': 'Mathematics',
      'title': 'Area of Triangle & Rectangle',
      'formula': 'Triangle: ½ × b × h  |  Rectangle: l × w',
      'unit': 'Square units (cm², m²)',
      'tip': 'Height must always be perpendicular to the base chosen.',
    },
    {
      'subject': 'Science',
      'title': 'Photosynthesis Equation',
      'formula': '6CO₂ + 6H₂O + Sunlight ➔ C₆H₁₂O₆ + 6O₂',
      'unit': 'Chemical equilibrium',
      'tip': 'Takes place inside the thylakoid discs of chloroplasts.',
    },
  ];

  static const List<Map<String, dynamic>> badges = [
    {
      'name': '7-Day Streak',
      'icon': Icons.local_fire_department_rounded,
      'color': AppColors.fireOrange,
      'unlocked': true,
      'description': 'Studied consistently for 7 consecutive days',
    },
    {
      'name': 'Bio Explorer',
      'icon': Icons.biotech_rounded,
      'color': AppColors.eagerGreen,
      'unlocked': true,
      'description': 'Completed all lessons in Cell Biology',
    },
    {
      'name': 'Math Wizard',
      'icon': Icons.calculate_rounded,
      'color': AppColors.sparkBlue,
      'unlocked': true,
      'description': 'Scored 100% on 3 linear equation quizzes',
    },
    {
      'name': 'Doubt Buster',
      'icon': Icons.smart_toy_rounded,
      'color': AppColors.royalPurple,
      'unlocked': true,
      'description': 'Asked and solved 10 doubts with Qrie AI',
    },
    {
      'name': 'Speed Demon',
      'icon': Icons.bolt_rounded,
      'color': AppColors.goldYellow,
      'unlocked': false,
      'description': 'Finish a speed quiz in under 60 seconds',
    },
    {
      'name': 'Master Scholar',
      'icon': Icons.military_tech_rounded,
      'color': AppColors.charcoal,
      'unlocked': false,
      'description': 'Reach 5,000 XP across all school subjects',
    },
  ];

  static const List<double> weeklyStudyHours = [1.5, 2.0, 1.2, 2.8, 2.2, 3.5, 2.4];
  static const List<String> weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
}
