import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TodoListPage(),
    );
  }
}

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final List<String> _tasks = [];
  final List<bool> _completed = [];
  final TextEditingController _taskController = TextEditingController();
  String? _errorText;

  void _addTask() {
    final task = _taskController.text.trim();
    if (task.isEmpty) {
      setState(() {
        _errorText = 'Task cannot be empty';
      });
      return;
    }
    if (_tasks.contains(task)) {
      setState(() {
        _errorText = 'Task already exists';
      });
      return;
    }
    setState(() {
      _tasks.add(task);
      _completed.add(false);
      _taskController.clear();
      _errorText = null;
    });
  }

  void _removeCompletedTasks() {
    setState(() {
      for (int i = _completed.length - 1; i >= 0; i--) {
        if (_completed[i]) {
          _tasks.removeAt(i);
          _completed.removeAt(i);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _removeCompletedTasks,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(
                      labelText: 'Add a new task',
                      errorText: _errorText,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: _addTask,
                  child: Text('Add'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: _tasks.isEmpty
                  ? Center(
                child: Text(
                  'No tasks added yet',
                  style: TextStyle(fontSize: 18.0, color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2.0,
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      leading: Checkbox(
                        value: _completed[index],
                        onChanged: (bool? value) {
                          setState(() {
                            _completed[index] = value!;
                          });
                        },
                      ),
                      title: Text(
                        _tasks[index],
                        style: TextStyle(
                          decoration: _completed[index]
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}