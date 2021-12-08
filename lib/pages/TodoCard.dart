// ignore: file_names
// ignore: file_names
import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  const TodoCard(
      {Key? key,
      required this.title,
      required this.iconData,
      required this.iconColor,
      required this.time,
      required this.iconBgColor,
      required this.switchState})
      : super(key: key);

  final String title;
  final IconData iconData;
  final Color iconColor;
  final String time;
  final Color iconBgColor;
  final bool switchState;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.redAccent),
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: switchState ? Color(0xff2a2e3d) : Colors.white,
                child: Row(
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      height: 33,
                      width: 36,
                      decoration: BoxDecoration(
                        color: iconBgColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.redAccent),
                      ),
                      child: Icon(
                        iconData,
                        color: iconColor,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w500,
                          color: switchState ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 15,
                        color: switchState ? Colors.white : Colors.black87,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
