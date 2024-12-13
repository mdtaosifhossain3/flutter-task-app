import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:todo_app/colors.dart';
import 'package:todo_app/views/otpView/otp_send_view.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/local_data/db_helper.dart';

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  _TodoHomePageState createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  final DbHelper _dbHelper = DbHelper.instance;
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _tasks = [];
  List<Map<String, dynamic>> _filteredTasks = [];

  int? _editingId;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    final tasks = await _dbHelper.getTasks();
    setState(() {
      _tasks = tasks;
      _filteredTasks = tasks;
    });
  }

  void _addOrUpdateTask() async {
    final taskTitle = _taskController.text.trim();
    if (taskTitle.isEmpty) return;

    if (_editingId == null) {
      await _dbHelper.addTask(taskTitle);
    } else {
      await _dbHelper.updateTask(_editingId!, taskTitle);
      _editingId = null;
    }
    FocusScope.of(context).unfocus(); // Collapse the keyboard
    _taskController.clear();
    _loadTasks();
  }

  void _deleteTask(int id) async {
    await _dbHelper.deleteTask(id);
    _loadTasks();
  }

  void _searchTasks(String query) {
    final filtered = _tasks
        .where(
            (task) => task['title'].toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _filteredTasks = filtered;
    });
  }

  // Function to send a message to the SMS app
  Future<void> sendStopMessage() async {
    const phoneNumber = '21213';
    const message = 'STOP todoa';

    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: {'body': message}, // pre-fill message
    );

    // Check if the URL can be launched (i.e., if SMS is available)
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri); // Opens SMS app with pre-filled message
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch SMS')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/logo.png",
                          width: 50,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "GetTODOS",
                          style: TextStyle(fontSize: 20, color: whiteColor),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                      top: 20,
                      right: 1,
                      child: Builder(builder: (context) {
                        return IconButton(
                            onPressed: () async {
                              await showPopover(
                                  context: context,
                                  bodyBuilder: (context) => Column(
                                        children: [
                                          TextButton(
                                              onPressed: () async {
                                                await sendStopMessage();
                                                await Future.delayed(
                                                    const Duration(seconds: 6));
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (_) {
                                                  return OtpSendView();
                                                }));
                                              },
                                              child: const Text(
                                                "Unsubscribe",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ))
                                        ],
                                      ),
                                  width: 120,
                                  height: 35,
                                  backgroundColor: blackColor,
                                  direction: PopoverDirection.bottom);
                            },
                            icon: const Icon(
                              Icons.more_vert,
                              color: whiteColor,
                            ));
                      }))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                height: 45,
                child: TextField(

                  controller: _searchController,
                  cursorColor: primaryColor,
                  style: const TextStyle(color: whiteColor),
                  decoration: const InputDecoration(
                      hintText: "Search...",
                      hintStyle: TextStyle(color: inputFilledTextColor),
                      prefixIcon: Icon(
                        Icons.search,
                        color: inputFilledTextColor,
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor)),
                      filled: true,
                      fillColor: inputFilledColor),
                  onChanged: _searchTasks,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.only(left: 16.00),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "My Tasks",
                  style: TextStyle(
                      color: whiteColor,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = _filteredTasks[index];

                  return Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 8.0,
                    ),
                    color: tileColor,
                    child: ListTile(
                      title: Text(
                        task['title'],
                        style: const TextStyle(color: whiteColor, fontSize: 18),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Icon(
                                Icons.edit,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _editingId = task['id'];
                                _taskController.text = task['title'];
                              });
                            },
                          ),
                          IconButton(
                            icon: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  color: redColor,
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Icon(
                                Icons.delete,
                              ),
                            ),
                            onPressed: () => _deleteTask(task['id']),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              color: const Color(0xff263238),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              child: Column(
                children: [
                  TextField(
                    controller: _taskController,
                    cursorColor: primaryColor,
                    style: const TextStyle(color: whiteColor),
                    decoration: const InputDecoration(
                        hintText: 'Add Task',
                        hintStyle: TextStyle(color: inputFilledTextColor),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor)),
                        filled: true,
                        fillColor: backgroundColor),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .8,
                    height: MediaQuery.of(context).size.width * .11,
                    child: ElevatedButton(
                      onPressed: _addOrUpdateTask,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: blackColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2))),
                      child: Text(
                        _editingId == null ? 'Add Task' : 'Update Task',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
