import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Screens/taskPage.dart';

class TaskCard extends StatelessWidget {
  final String? title, desc;

  const TaskCard({this.title, this.desc});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? 'Unnamed',
            style: TextStyle(
                color: Color(0xFF211551),
                fontWeight: FontWeight.bold,
                fontSize: 22.0),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              desc ?? 'No description',
              style: TextStyle(
                  color: Color(0xFF86829D),
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class ToDoWidget extends StatelessWidget {
  final String? text;
  bool isDone;

  ToDoWidget({Key? key, this.text, required this.isDone}) : super(key: key);
  void toggleDone()=>isDone=!isDone;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: (){
                  },
                  child: Container(
                    width: 20.0,
                    height: 20.0,
                    margin: EdgeInsets.only(right: 12.0),
                    decoration: BoxDecoration(
                        color: isDone ? Color(0xFF7349FE) : Colors.transparent,
                        borderRadius: BorderRadius.circular(6.0),
                        border: isDone
                            ? null
                            : Border.all(color: Color(0xFF86829D), width: 1.5)),
                    child: Image(
                      image: AssetImage('assets/images/check_icon.png'),
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    text ?? '(Unnamed ToDo)',
                    style: TextStyle(
                        fontWeight: isDone ? FontWeight.bold : FontWeight.w500,
                        fontSize: 16.0,
                        color: isDone ? Color(0xFF211551): Color(0xFF86829D)),
                  ),
                )
              ],
            )
          ],
        ));
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
