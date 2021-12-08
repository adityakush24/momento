import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:momento/Service/Auth_Service.dart';
import 'package:momento/pages/AddTodo.dart';
import 'package:momento/pages/SignInPage.dart';
import 'package:momento/pages/TodoCard.dart';
import 'package:momento/pages/ViewData.dart';
import 'package:intl/intl.dart';
import 'package:grouped_list/grouped_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthClass authClass = AuthClass();
  bool _switchvalue = true;
  bool _value = false;
  Map<String, bool> _categoriesFilter = {
    'Study': true,
    'Work': true,
    'Workout': true,
    'Food': true,
    'Design': true,
  };
  final FirebaseAuth auth = FirebaseAuth.instance;
  final Stream<QuerySnapshot> _todos = FirebaseFirestore.instance
      .collection('Todo')
      .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('Todo')
        .get()
        .then((value) => value.docs.forEach((element) {
              FirebaseFirestore.instance
                  .collection('Todo')
                  .doc(element.id)
                  .update({'visible': true});
            }));
    return Scaffold(
      backgroundColor: _switchvalue ? Colors.black87 : Colors.white,
      appBar: AppBar(
        backgroundColor: _switchvalue ? Colors.black87 : Colors.white,
        title: Text(
          'Todo List',
          style: TextStyle(
            color: _switchvalue ? Colors.white : Colors.black87,
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.filter_list,
                color: _switchvalue ? Colors.white : Colors.black87,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Filter'),
                        content: StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SwitchListTile(
                                  title: Text('Study'),
                                  value: _categoriesFilter['Study']!,
                                  onChanged: (bool value) {
                                    updateVisible(value, 'Study');
                                    setState(() {
                                      _categoriesFilter['Study'] = value;
                                    });
                                  },
                                ),
                                SwitchListTile(
                                  title: Text('Work'),
                                  value: _categoriesFilter['Work']!,
                                  onChanged: (bool value) {
                                    updateVisible(value, 'Work');
                                    setState(() {
                                      _categoriesFilter['Work'] = value;
                                    });
                                  },
                                ),
                                SwitchListTile(
                                  title: Text('Workout'),
                                  value: _categoriesFilter['Workout']!,
                                  onChanged: (bool value) {
                                    updateVisible(value, 'Workout');
                                    setState(() {
                                      _categoriesFilter['Workout'] = value;
                                    });
                                  },
                                ),
                                SwitchListTile(
                                  title: Text('Food'),
                                  value: _categoriesFilter['Food']!,
                                  onChanged: (bool value) {
                                    updateVisible(value, 'Food');
                                    setState(() {
                                      _categoriesFilter['Food'] = value;
                                    });
                                  },
                                ),
                                SwitchListTile(
                                  title: Text('Design'),
                                  value: _categoriesFilter['Design']!,
                                  onChanged: (bool value) {
                                    updateVisible(value, 'Design');
                                    setState(() {
                                      _categoriesFilter['Design'] = value;
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    });
              }),
          Switch(
            value: _switchvalue,
            onChanged: (newValue) {
              setState(() {
                _switchvalue = newValue;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('Todo')
                  .get()
                  .then((value) => value.docs.forEach((element) {
                        FirebaseFirestore.instance
                            .collection('Todo')
                            .doc(element.id)
                            .delete();
                      }));
            },
          ),
          IconButton(
              icon: Icon(Icons.logout,
                  color: _switchvalue ? Colors.white : Colors.black87),
              onPressed: () async {
                await authClass.logout();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (builder) => SignInPage()),
                    (route) => false);
              }),
        ],
        bottom: PreferredSize(
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: _switchvalue ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
          preferredSize: Size.fromHeight(35),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: _switchvalue ? Colors.black87 : Colors.white,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 32,
                color: _switchvalue ? Colors.white : Colors.black87,
              ),
              label: "Home"),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => AddTodoPage(
                              switchState: _switchvalue,
                            )));
              },
              child: Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.indigoAccent,
                      Colors.purple,
                    ],
                  ),
                ),
                child: Icon(
                  Icons.add,
                  size: 32,
                  color: _switchvalue ? Colors.white : Colors.black87,
                ),
              ),
            ),
            label: "Add To-do",
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle_rounded,
                size: 32,
                color: _switchvalue ? Colors.white : Colors.black87,
              ),
              label: "User"),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _todos,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Padding(
                padding: const EdgeInsets.all(15.0),
                child: GroupedListView<dynamic, String>(
                    elements: snapshot.data!.docs,
                    groupBy: (todo) =>
                        todo['isCompleted'] ? 'Incomplete' : 'Complete',
                    groupHeaderBuilder: (todo) => Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            todo['isCompleted'] ? 'Complete' : 'Incomplete',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color:
                                  _switchvalue ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                    indexedItemBuilder: (context, snapshot, int index) {
                      Map<String, dynamic> todo =
                          snapshot.data() as Map<String, dynamic>;
                      String id = snapshot.id;
                      IconData iconData = Icons.list_alt_rounded;
                      Color iconColor = Colors.black;
                      switch (todo['category']) {
                        case 'Work':
                          iconData = Icons.work;
                          iconColor = Colors.blue;
                          break;
                        case 'Workout':
                          iconData = Icons.fitness_center;
                          iconColor = Colors.yellow;
                          break;
                        case 'Study':
                          iconData = Icons.school;
                          iconColor = Colors.green;
                          break;
                        case 'Food':
                          iconData = Icons.fastfood;
                          iconColor = Colors.red;
                          break;
                        case 'Design':
                          iconData = Icons.brush;
                          iconColor = Colors.purple;
                          break;
                      }

                      return Visibility(
                          visible: todo['visible'] == true,
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) => ViewData(
                                              todo: todo,
                                              id: id,
                                              switchState: _switchvalue,
                                            )));
                              },
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Theme(
                                      child: Transform.scale(
                                        scale: 1.5,
                                        child: Checkbox(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          activeColor: Color(0xff6cf8a9),
                                          checkColor: Color(0xff0e3e26),
                                          value: todo["isCompleted"] as bool,
                                          onChanged: (value) {
                                            FirebaseFirestore.instance
                                                .collection("Todo")
                                                .doc(id)
                                                .update({"isCompleted": value});
                                          },
                                        ),
                                      ),
                                      data: ThemeData(
                                        primarySwatch: Colors.blue,
                                        unselectedWidgetColor:
                                            Color(0xff5e616a),
                                      ),
                                    ),
                                  ),
                                  TodoCard(
                                      title: todo["title"] == null
                                          ? "No Title"
                                          : todo["title"],
                                      iconBgColor: Colors.white,
                                      iconColor: iconColor,
                                      iconData: iconData,
                                      switchState: _switchvalue,
                                      time: todo["date"] == null
                                          ? "No Date"
                                          : DateFormat('dd/MM/yyyy, HH:mm')
                                              .format(DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      todo["date"]))),
                                ],
                              )));
                    }));
          }),
    );
  }

  void updateVisible(bool value, String category) {
    FirebaseFirestore.instance
        .collection("Todo")
        .where("category", isEqualTo: category)
        .get()
        .then((todos) {
      todos.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection("Todo")
            .doc(element.id)
            .update({"visible": value});
      });
    });
  }
}
