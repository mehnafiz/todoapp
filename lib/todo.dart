import 'package:flutter/material.dart';
import 'about.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  List<Map<String, dynamic>> _tasks = [];
  bool showActiveTasks = true;

  void _addTask(String task) {
    setState(() {
      _tasks.add({
        'task': task,
        'completed': false,
      });
      Navigator.pop(context);
    });
  }

  void _showTaskDialog({int? index}) {
    TextEditingController _taskController = TextEditingController(
      text: index != null ? _tasks[index]['task'] : '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(index != null ? 'Edit Task' : 'Add Task',
            style: const TextStyle(fontWeight: FontWeight.w400)),
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: TextField(
            controller: _taskController,
            decoration: const InputDecoration(
              hintText: '  Enter Task',
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_taskController.text.trim().isNotEmpty) {
                if (index != null) {
                  setState(() {
                    _tasks[index]['task'] = _taskController.text;
                  });
                  Navigator.pop(context);
                } else {
                  _addTask(_taskController.text);
                }
              }
            },
            child: Text(index != null ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  void toggleTaskStatus(int index) {
    setState(() {
      _tasks[index]['completed'] = !_tasks[index]['completed'];
    });
  }

  void deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  int get activeCount => _tasks.where((task) => !task['completed']).length;
  int get completedCount => _tasks.where((task) => task['completed']).length;

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredTasks =
    _tasks.where((task) => task['completed'] != showActiveTasks).toList();

    return Scaffold(
      backgroundColor: Colors.greenAccent[100],
      appBar: AppBar(
        title: const Text(
          'Todo App',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.green[400],
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green[400]),
              child: const Text(
                'Todo Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // close drawer
                Navigator.pop(context); // navigate back (adjust if needed)
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context); // close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    showActiveTasks = true;
                  });
                },
                child: Card(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        children: [
                          Text(
                            activeCount.toString(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            ' Active Tasks',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    showActiveTasks = false;
                  });
                },
                child: Card(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        children: [
                          Text(
                            completedCount.toString(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Completed Tasks',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                int trueIndex = _tasks.indexOf(filteredTasks[index]);
                return Dismissible(
                  key: Key(UniqueKey().toString()),
                  background: Container(
                    color: Colors.green,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    child: const Icon(Icons.check, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.startToEnd) {
                      toggleTaskStatus(trueIndex);
                    } else {
                      deleteTask(trueIndex);
                    }
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(
                        filteredTasks[index]['task'],
                        style: TextStyle(
                          fontSize: 20,
                          decoration: filteredTasks[index]['completed']
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      leading: Checkbox(
                        shape: const CircleBorder(),
                        value: filteredTasks[index]['completed'],
                        onChanged: (value) => toggleTaskStatus(trueIndex),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showTaskDialog(index: trueIndex),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskDialog(),
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}
