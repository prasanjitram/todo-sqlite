import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/Screens/taskPage.dart';
import 'package:todo_app/model/database_helper.dart';
import 'package:todo_app/model/task.dart';
import '../Widgets.dart';

class Homepage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomepageState();
  }
}

class _HomepageState extends State<Homepage> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
          color: Color(0xFFF6F6F6),
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(bottom: 32.0, top: 32.0),
                      child:
                          Image(image: AssetImage('assets/images/logo.png'))),
                  Expanded(
                    child: FutureBuilder(

                      future: _dbHelper.getTask(),
                      builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
                        return ScrollConfiguration(
                          behavior: MyBehavior(),
                          child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context,index){
                            return GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>TaskPage(task: snapshot.data![index]))).then((value) {
                                  setState(() {
                                  });
                                });
                              },
                              child: TaskCard(
                                title: snapshot.data![index].title,
                                desc: snapshot.data![index].description,
                              ),
                            );
                          }),
                        );
                      },

                    ),
                  )
                ],
              ),
              Positioned(
                bottom: 24.00,
                right: 0.0,
                child: GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TaskPage(task: Task(id: 0),))).then((value){
                        setState(() {
                        });
                  }),
                  child: Container(
                    child: Container(
                      height: 60.0,
                      width: 60.0,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0xFF7349FE), Color(0xFF643FDB)],
                              begin: Alignment(0.0, -1.0),
                              end: Alignment(0.0, 1.0)),
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Image(
                        image: AssetImage('assets/images/add_icon.png'),
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
    ));
  }
}
