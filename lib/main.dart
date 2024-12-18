import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HabitProvider(),
      child: MaterialApp(
        title: 'Habit Tracker',
        home: HabitListScreen(),
      ),
    );
  }
}

class HabitProvider with ChangeNotifier {
  final List<Habit> _habits = [];

  List<Habit> get habits => _habits;

  void addHabit(String habitName) {
    _habits.add(Habit(name: habitName));
    notifyListeners();
  }

  void toggleHabit(int index) {
    _habits[index].isCompleted = !_habits[index].isCompleted;
    if (_habits[index].isCompleted) {
      _habits[index].count++;
    }
    notifyListeners();
  }

  void removeHabit(int index) {
    _habits.removeAt(index);
    notifyListeners();
  }
}

class HabitListScreen extends StatelessWidget {
  HabitListScreen({super.key});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Habit Tracker')),
      body: Column(
        children: [
          Expanded(
            child: Consumer<HabitProvider>(
              builder: (context, habitProvider, child) {
                return ListView.builder(
                  itemCount: habitProvider.habits.length,
                  itemBuilder: (context, index) {
                    final habit = habitProvider.habits[index];
                    return ListTile(
                      title: Text(
                        habit.name,
                        style: TextStyle(
                          decoration: habit.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      subtitle: Text('Durchführungen: ${habit.count}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          habitProvider.removeHabit(index);
                        },
                      ),
                      onTap: () {
                        habitProvider.toggleHabit(index);
                      },
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(labelText: 'Neues Habit'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      Provider.of<HabitProvider>(context, listen: false)
                          .addHabit(_controller.text);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
