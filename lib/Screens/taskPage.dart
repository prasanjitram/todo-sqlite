import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/Screens/Homepage.dart';
import 'package:todo_app/Widgets.dart';
import 'package:todo_app/model/Todo.dart';
import 'package:todo_app/model/database_helper.dart';
import 'package:todo_app/model/task.dart';

class TaskPage extends StatefulWidget {
  final Task task;

  const TaskPage({required this.task});

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  bool isVisible = false;
  late FocusNode _titleFocus;
  late FocusNode _descFocus;
  late FocusNode _toDoFocus;
  DatabaseHelper _dbHelper = DatabaseHelper();
  String? _taskTitle = '';
  String? _taskDescription ='';
  String? _todo='';
  int _taskId = 0;

  void initState() {
    if (widget.task.id == 0) {
      _taskTitle = "";
      _taskDescription = '';
    }
    else {
      _taskTitle = widget.task.title;
      _taskId = widget.task.id!;
      _taskDescription= widget.task.description;
      isVisible = true;
    }
    _titleFocus = FocusNode();
    _descFocus = FocusNode();
    _toDoFocus = FocusNode();
    print('ID: ${widget.task.id}');
    super.initState();
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _descFocus.dispose();
    _toDoFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 24.0, bottom: 6.0),
                    child: Row(
                      children: [
                        Padding(
                            padding: EdgeInsets.all(24.0),
                            child: InkWell(
                              onTap: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Homepage())),
                              child: Image(
                                image: AssetImage(
                                    'assets/images/back_arrow_icon.png'),
                              ),
                            )),
                        Expanded(
                          child: TextField(
                            focusNode: _titleFocus,
                            controller: TextEditingController()
                              ..text = (_taskTitle.toString() == 'null'
                                  ? ""
                                  : _taskTitle.toString()),
                            onChanged: (value) async {
                              print(value);
                              if (value != "") {
                                if (widget.task.id == 0)  {
                                  DatabaseHelper _dbHelper = DatabaseHelper();
                                  Task _newTask = Task(title: value);
                                  _taskId = await _dbHelper.insertTask(_newTask)  ;
                                  print('New task created taskId: $_taskId');
                                  setState(() {
                                    isVisible =true;
                                    _taskTitle=value;
                                  });
                                } else {
                                  _dbHelper.updateTaskTitle(_taskId, value);
                                  print("Update the details");
                                }
                                _descFocus.requestFocus();
                              }
                            },
                            decoration: InputDecoration(
                                hintText: 'Enter Title',
                                border: InputBorder.none),
                            style: TextStyle(
                                fontSize: 26.0,
                                color: Color(0xFF211551),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: isVisible,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: TextField(
                        controller: TextEditingController()..text= _taskDescription==null?"":_taskDescription.toString(),
                        focusNode: _descFocus,
                        onSubmitted: (value) {
                          if(_taskId !=0){
                            _dbHelper.updateDescription(_taskId, value);
                            _taskDescription = value;
                          }
                          _toDoFocus.requestFocus();
                        },
                        decoration: InputDecoration(
                            hintText: 'Enter Description',
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 24.0)),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isVisible,
                    child: FutureBuilder(
                        future: _dbHelper.getToDo(_taskId),
                        builder: (context, AsyncSnapshot<List<ToDo>> snapshot) {
                          return Expanded(
                            child: ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      if(snapshot.data![index].isDone==0)
                                        await _dbHelper.updateToDoDone((snapshot.data![index].id as int), 1);
                                      else
                                        await _dbHelper.updateToDoDone((snapshot.data![index].id as int), 0);
                                      setState(() {
                                        _toDoFocus.requestFocus();
                                      });
                                    },
                                    child: ToDoWidget(
                                      text: snapshot.data![index].title,
                                      isDone: snapshot.data![index].isDone == 0
                                          ? false
                                          : true,
                                    ),
                                  );
                                }),
                          );
                        }),
                  ),
                  Visibility(
                    visible: isVisible,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        children: [
                          Container(
                            width: 20.0,
                            height: 20.0,
                            margin: EdgeInsets.only(right: 12.0),
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(6.0),
                                border: Border.all(color: Color(0xFF86829D))),
                            child: Image(
                              image: AssetImage('assets/images/check_icon.png'),
                            ),
                          ),
                          Expanded(
                              child: TextField(
                                controller: TextEditingController()..text='',
                            focusNode: _toDoFocus,
                            onSubmitted: (value) async {
                              print(value);
                              if (value != "") {
                                if (_taskId != 0) {
                                  ToDo _newToDo = ToDo(
                                      title: value,
                                      isDone: 1,
                                      taskId: _taskId);
                                  _dbHelper.insertToDo(_newToDo);
                                  setState(() {});
                                  print('New toDo created');
                                } else {
                                  print("Update the details");
                                }
                              }
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter ToDo item",
                            ),
                            style: TextStyle(fontSize: 20.0),
                          ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Visibility(
                visible: isVisible,
                child: Positioned(
                  bottom: 24.0,
                  right: 24.0,
                  child: GestureDetector(
                    onTap: () async {
                      if(_taskId!=0)  {
                        await _dbHelper.deleteTask(_taskId);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Homepage()));
                      }
                    },
                    child: Container(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 24.0),
                        height: 60.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                            color: Color(0xFFFE3577),
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Image(
                          image: AssetImage('assets/images/delete_icon.png'),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
