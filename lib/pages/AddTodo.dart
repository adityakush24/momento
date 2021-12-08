// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'HomePage.dart';

class AddTodoPage extends StatefulWidget {
  AddTodoPage({Key? key, required this.switchState}) : super(key: key);

  final bool switchState;
  @override
  _AddTodoPageState createState() => _AddTodoPageState(switchState);
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String category = "";
  bool switchStatus = false;

  _AddTodoPageState(bool switchState) {
    this.switchStatus = switchState;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: switchStatus ? Colors.black87 : Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                height: 30,
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (builder) => HomePage()));
                },
                icon: Icon(
                  Icons.home,
                  color: switchStatus ? Colors.white : Colors.black87,
                  size: 28,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create Todo",
                      style: TextStyle(
                          fontSize: 33,
                          color: switchStatus ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    label("Task Title"),
                    SizedBox(
                      height: 12,
                    ),
                    title(),
                    SizedBox(
                      height: 25,
                    ),
                    label("Description"),
                    SizedBox(
                      height: 12,
                    ),
                    description(),
                    SizedBox(
                      height: 25,
                    ),
                    label("Category"),
                    SizedBox(
                      height: 25,
                    ),
                    Wrap(
                      runSpacing: 10,
                      children: [
                        categorySelect("Workout", 0xfff29732),
                        SizedBox(
                          width: 20,
                        ),
                        categorySelect("Study", 0xff00FF00),
                        SizedBox(
                          width: 20,
                        ),
                        categorySelect("Food", 0xffff6d6e),
                        SizedBox(
                          width: 20,
                        ),
                        categorySelect("Work", 0xff234ebd),
                        SizedBox(
                          width: 20,
                        ),
                        categorySelect("Design", 0xffad32f9),
                      ],
                    ),
                    SizedBox(
                      width: 50,
                      height: 25,
                    ),
                    button(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget button() {
    return InkWell(
        onTap: () {
          final FirebaseAuth auth = FirebaseAuth.instance;
          final User? user = auth.currentUser;
          final uid = user!.uid;
          FirebaseFirestore.instance.collection("Todo").add({
            "title": _titleController.text,
            "description": _descriptionController.text,
            "category": category,
            "date": DateTime.now().millisecondsSinceEpoch,
            "isCompleted": false,
            "uid": uid,
            "visible": true,
          });
          Navigator.pop(context);
        },
        child: Container(
          height: 56,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Colors.redAccent, Colors.redAccent],
            ),
          ),
          child: Center(
            child: Text(
              "Create",
              style: TextStyle(
                color: switchStatus ? Colors.white : Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ));
  }

  Widget categorySelect(String label, int color) {
    return InkWell(
        onTap: () {
          setState(() {
            category = label;
          });
        },
        child: Chip(
            backgroundColor: category == label
                ? (switchStatus ? Colors.black : Colors.grey)
                : Color(color),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            label: Text(
              label,
              style: TextStyle(
                color: switchStatus ? Colors.white : Colors.black87,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            )));
  }

  Widget description() {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: switchStatus ? Color(0xff2a2e3d) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.redAccent),
      ),
      child: TextFormField(
        controller: _descriptionController,
        style: TextStyle(
          color: switchStatus ? Colors.grey : Colors.black,
          fontSize: 17,
        ),
        maxLines: null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Description",
          hintStyle: TextStyle(
            color: switchStatus ? Colors.grey : Colors.black,
            fontSize: 17,
          ),
          contentPadding: EdgeInsets.only(
            left: 20,
            right: 20,
          ),
        ),
      ),
    );
  }

  Widget title() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: switchStatus ? Color(0xff2a2e3d) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.redAccent),
      ),
      child: TextFormField(
        controller: _titleController,
        style: TextStyle(
          color: switchStatus ? Colors.grey : Colors.black,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Task Title",
          hintStyle: TextStyle(
            color: switchStatus ? Colors.grey : Colors.black,
            fontSize: 17,
          ),
          contentPadding: EdgeInsets.only(
            left: 20,
            right: 20,
          ),
        ),
      ),
    );
  }

  Widget label(String label) {
    return Text(
      label,
      style: TextStyle(
          color: switchStatus ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w600,
          fontSize: 16.5,
          letterSpacing: 0.2),
    );
  }
}
