import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
    Fluttertoast.showToast(
      msg: "Task added successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
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
    Fluttertoast.showToast(
      msg: "Completed tasks removed successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _toggleAllTasks(bool? value) {
    setState(() {
      for (int i = 0; i < _completed.length; i++) {
        _completed[i] = value!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool anyCompleted = _completed.contains(true);
    bool allSelected = _completed.isNotEmpty && _completed.every((completed) => completed);

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
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
                    primary: Colors.teal,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            if (_tasks.isNotEmpty)
              Row(
                children: [
                  Checkbox(
                    value: allSelected,
                    onChanged: (bool? value) {
                      _toggleAllTasks(value);
                    },
                  ),
                  Text('Select All'),
                  Spacer(),
                  if (anyCompleted)
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: _removeCompletedTasks,
                    ),
                ],
              ),
            SizedBox(height: 10.0),
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