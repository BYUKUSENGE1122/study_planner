import 'package:flutter/material.dart';

void main() {
  runApp(const MyStudyPlannerApp());
}

// STATIC: Main application widget
class MyStudyPlannerApp extends StatelessWidget {
  const MyStudyPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Study Planner',

      // STATIC: Dark navy-blue application theme
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF101827),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1B2738),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        useMaterial3: true,
      ),
      home: const StudyPlannerHome(),
    );
  }
}

// STATIC: Reusable statistics card
class StatCard extends StatelessWidget {
  final String title;
  final int value;
  final IconData icon;
  final Color iconColor;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1B2738),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 23),
            const SizedBox(height: 8),
            Text(
              '$value',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
            ),
          ],
        ),
      ),
    );
  }
}

// LOGIC: Stateful home screen
class StudyPlannerHome extends StatefulWidget {
  const StudyPlannerHome({super.key});

  @override
  State<StudyPlannerHome> createState() => _StudyPlannerHomeState();
}

class _StudyPlannerHomeState extends State<StudyPlannerHome> {
  // LOGIC: Store study goals in a List of Maps
  List<Map<String, dynamic>> goals = [
    {'subject': 'Dart Programming', 'hours': 3, 'done': false},
    {'subject': 'Database Management', 'hours': 2, 'done': false},
    {'subject': 'Udemy Online Course', 'hours': 4, 'done': false},
    {'subject': 'English', 'hours': 1, 'done': false},
    {'subject': 'Information Technology', 'hours': 5, 'done': false},
    {'subject': 'Python and Java Programming', 'hours': 6, 'done': false},
  ];

  // LOGIC: Calculate total study hours using fold()
  int get totalHours {
    return goals.fold(0, (sum, goal) => sum + (goal['hours'] as int));
  }

  // LOGIC: Count completed goals using where()
  int get completedGoals {
    return goals.where((goal) => goal['done'] == true).length;
  }

  // LOGIC: Count remaining goals using where()
  int get remainingGoals {
    return goals.where((goal) => goal['done'] == false).length;
  }

  // LOGIC: Change the completion status of a goal
  void toggleGoal(int index) {
    setState(() {
      goals[index]['done'] = !goals[index]['done'];
    });
  }

  // LOGIC: Delete a goal
  void deleteGoal(int index) {
    setState(() {
      goals.removeAt(index);
    });
  }

  // LOGIC: Open Add Goal screen and receive the new goal
  Future<void> addGoal() async {
    // CONNECTION: Open the second screen
    final Map<String, dynamic>? newGoal =
        await Navigator.push<Map<String, dynamic>>(
          context,
          MaterialPageRoute(builder: (context) => const AddGoalScreen()),
        );

    // LOGIC: Check whether the user cancelled
    if (newGoal == null || !mounted) {
      return;
    }

    // CONNECTION: Add the returned goal to the existing list
    setState(() {
      goals.add(newGoal);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // STATIC: Application AppBar
      appBar: AppBar(title: const Text('My Study Planner')),

      // STATIC: Main screen layout
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 24, 20, 8),
            child: Text(
              'My Study Goals',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Stay organized and keep working towards your dreams.',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            ),
          ),

          const SizedBox(height: 12),

          // STATIC: Summary row with three reusable cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Total hours',
                    value: totalHours,
                    icon: Icons.access_time,
                    iconColor: const Color(0xFF38BDF8),
                  ),
                ),
                Expanded(
                  child: StatCard(
                    title: 'Completed',
                    value: completedGoals,
                    icon: Icons.check_circle_outline,
                    iconColor: const Color(0xFF34D399),
                  ),
                ),
                Expanded(
                  child: StatCard(
                    title: 'Remaining',
                    value: remainingGoals,
                    icon: Icons.menu_book,
                    iconColor: const Color(0xFFA78BFA),
                  ),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Text(
              'Your Goals',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          // CONNECTION: Display goals using ListView.builder
          Expanded(
            child: goals.isEmpty
                // STATIC: Friendly empty-state message
                ? const Center(
                    child: Text(
                      'No study goals yet. Add your first goal!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 15),
                    ),
                  )
                : ListView.builder(
                    itemCount: goals.length,
                    itemBuilder: (context, index) {
                      final goal = goals[index];
                      final bool isDone = goal['done'] as bool;

                      return Card(
                        color: const Color(0xFF1B2738),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 7,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ListTile(
                          // CONNECTION: Connect tile to toggleGoal
                          onTap: () {
                            toggleGoal(index);
                          },

                          leading: Checkbox(
                            value: isDone,
                            activeColor: const Color(0xFF6366F1),
                            onChanged: (value) {
                              toggleGoal(index);
                            },
                          ),

                          title: Text(
                            goal['subject'] as String,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              decoration: isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),

                          subtitle: Text(
                            '${goal['hours']} study hours',
                            style: const TextStyle(color: Color(0xFF94A3B8)),
                          ),

                          // LOGIC: Delete button
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {
                              deleteGoal(index);
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      // CONNECTION: Connect floating button to addGoal
      floatingActionButton: FloatingActionButton(
        onPressed: addGoal,
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// STATIC: Second screen for adding a new study goal
class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen({super.key});

  @override
  State<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  // LOGIC: Controllers read values entered by the user
  final TextEditingController _subjectController = TextEditingController();

  final TextEditingController _hoursController = TextEditingController();

  // LOGIC: Key used to validate the form
  final _formKey = GlobalKey<FormState>();

  // LOGIC: Validate and save the new study goal
  void saveGoal() {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> newGoal = {
        'subject': _subjectController.text.trim(),
        'hours': int.parse(_hoursController.text.trim()),
        'done': false,
      };

      // CONNECTION: Return new goal to the home screen
      Navigator.pop(context, newGoal);
    }
  }

  // LOGIC: Release controllers when the screen is destroyed
  @override
  void dispose() {
    _subjectController.dispose();
    _hoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // STATIC: Add Goal AppBar
      appBar: AppBar(title: const Text('Add Study Goal')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create a New Goal',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              const Text(
                'Enter your study subject and planned hours.',
                style: TextStyle(color: Color(0xFF94A3B8)),
              ),

              const SizedBox(height: 28),

              // CONNECTION: Subject input field
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(
                  labelText: 'Subject',
                  hintText: 'e.g. Dart Programming',
                  prefixIcon: Icon(Icons.book_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a study subject';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // CONNECTION: Study hours input field
              TextFormField(
                controller: _hoursController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Study Hours',
                  hintText: 'e.g. 3',
                  prefixIcon: Icon(Icons.access_time),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter study hours';
                  }

                  final int? hours = int.tryParse(value.trim());

                  if (hours == null) {
                    return 'Please enter a valid whole number';
                  }

                  if (hours <= 0) {
                    return 'Hours must be greater than zero';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 30),

              // LOGIC: Save and cancel actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: saveGoal,
                      child: const Text('Save Goal'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
