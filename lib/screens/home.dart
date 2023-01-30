import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield_new.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskapp/notification_service.dart';
import 'package:taskapp/widgets/search_field.dart';

import '../widgets/task_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final taskTitleController = TextEditingController();
  final taskDescController = TextEditingController();
  final taskDateController = TextEditingController();

  bool _isLoading = false;
  String search = '';
  DateTime selectedDate = DateTime.now();
  DateTime fullDate = DateTime.now();

  final NotificationService _notificationService = NotificationService();

  // Future<void> _selectDate(BuildContext context) async {
  //   DateTime? pickedDate = await showDatePicker(
  //       context: context,
  //       initialDate: DateTime.now(), //get today's date
  //       firstDate: DateTime(
  //           2000), //DateTime.now() - not to allow to choose before today.
  //       lastDate: DateTime(2101));
  //   if (pickedDate != null) {
  //     taskDateController.text = DateFormat.yMd().format(pickedDate);
  //   }
  // }

  // Future<void> _selectTime(BuildContext context) async {
  //   TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: const TimeOfDay(hour: 00, minute: 00),
  //   );
  //   if (picked != null) {
  //     taskTimeController.text = formatDate(
  //         DateTime(2019, 08, 1, picked.hour, picked.minute),
  //         [hh, ':', nn, " ", am]).toString();
  //   }
  // }

  Future<DateTime?> _selectDate(BuildContext context) async {
    final date = await showDatePicker(
        context: context,
        firstDate: DateTime(1900),
        initialDate: selectedDate,
        lastDate: DateTime(2100));
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDate),
      );

      if (time != null) {
        setState(() {
          selectedDate = DateTimeField.combine(date, time);
        });
        return DateTimeField.combine(date, time);
      }
    } else {
      return selectedDate;
    }
    return null;
  }

  // This function will be triggered when the button is pressed
  Future<void> _addTask(context) async {
    final newTaskRef = FirebaseFirestore.instance.collection('tasks').doc();
    int taskId = Timestamp.fromDate(DateTime.now()).nanoseconds;
    final data = {
      "description": taskDescController.text,
      "title": taskTitleController.text,
      "date": selectedDate,
      "updatedTime": Timestamp.now(),
      "taskId": taskId,
    };

    await newTaskRef.set(data);

    _notificationService.showScheduledLocalNotification(
        id: 1,
        title: "Drink Water",
        body: "Time to drink some water!",
        payload: "You just took water! Huurray!",
        seconds: 6);

    Navigator.pop(context);
    resetForm();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _deleteTask(id) async {
    DocumentReference documentRef =
        FirebaseFirestore.instance.collection('tasks').doc(id);

    await documentRef.delete();
  }

  void resetForm() {
    taskDescController.clear();
    taskTitleController.clear();
    taskDateController.clear();
  }

  @override
  void dispose() {
    taskDescController.dispose();
    taskTitleController.dispose();
    taskDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF99CBFA),
              Color(0x00A968C8),
            ],
            // tileMode: TileMode.mirror,
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: 12),
                child: Text(
                  "Elavarasan M",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: SearchFieldWidget(
                          placeholderText: 'Search here...',
                          isSearch: true,
                          onChange: (text) {
                            setState(() {
                              search = text;
                            });
                          }),
                    ),
                    Expanded(
                        flex: 1,
                        child: FloatingActionButton(
                          backgroundColor:
                              const Color.fromARGB(255, 26, 12, 231),
                          onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                              return Dialog(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        const Text(
                                          'Add Task',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Divider(
                                          height: 3,
                                          color: Colors.black87,
                                        ),
                                        TextField(
                                          controller:
                                              taskTitleController, //editing controller of this TextField
                                          decoration: const InputDecoration(
                                              icon: Icon(Icons
                                                  .title), //icon of text field
                                              labelText:
                                                  "Task Name" //label text of field
                                              ),
                                          // when true user cannot edit text
                                        ),
                                        TextField(
                                          controller:
                                              taskDescController, //editing controller of this TextField
                                          decoration: const InputDecoration(
                                              icon: Icon(Icons
                                                  .description), //icon of text field
                                              labelText:
                                                  "Task description" //label text of field
                                              ),
                                          // when true user cannot edit text
                                        ),
                                        DateTimeField(
                                          controller: taskDateController,
                                          format:
                                              DateFormat("MMM d, yyyy h:mm a"),
                                          onShowPicker:
                                              (context, currentValue) =>
                                                  _selectDate(context),
                                          decoration: const InputDecoration(
                                              icon: Icon(Icons
                                                  .calendar_today), //icon of text field
                                              labelText:
                                                  "Select Date" //label text of field
                                              ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                setState(() {
                                                  _isLoading = false;
                                                });
                                              },
                                              child: const Text('Close'),
                                            ),
                                            ElevatedButton.icon(
                                              icon: _isLoading
                                                  ? const SizedBox(
                                                      height: 10.0,
                                                      width: 10.0,
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Colors.white,
                                                        strokeWidth: 3.0,
                                                      ),
                                                    )
                                                  : const Icon(Icons.add),
                                              label: Text(
                                                _isLoading
                                                    ? 'Adding...'
                                                    : 'Add',
                                                style: const TextStyle(
                                                    fontSize: 15),
                                              ),
                                              onPressed: _isLoading
                                                  ? null
                                                  : () {
                                                      setState(() {
                                                        _isLoading = true;
                                                      });
                                                      _addTask(context);
                                                    },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          child: const Icon(Icons.add,
                              size: 40.0, color: Colors.white),
                        ))
                  ],
                ),
              ),

              // implement GridView.builder

              Flexible(
                child: Container(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 12),
                  margin: const EdgeInsets.only(bottom: 15),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: (search != "")
                          ? FirebaseFirestore.instance
                              .collection('tasks')
                              .orderBy('title')
                              .startAt([search]).endAt(
                                  ['$search\uf8ff']).snapshots()
                          : FirebaseFirestore.instance
                              .collection('tasks')
                              .orderBy("updatedTime", descending: true)
                              .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color.fromARGB(255, 2, 4, 14),
                              strokeWidth: 4.0,
                            ),
                          );
                        }
                        return ListView(
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          DateTime dateAdded = data["updatedTime"].toDate();
                          String dateOfTask =
                              DateFormat.yMMMd().add_jm().format(dateAdded);
                          return TaskCardWidget(
                            title: data['title'],
                            updatedTime: dateOfTask,
                            description: data['description'],
                            onTap: () {
                              _deleteTask(document.id);
                            },
                          );
                        }).toList());
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
      ]),
    );
  }
}
