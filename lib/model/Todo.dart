class ToDo{
  final int? id;
  final String? title;
  final int? isDone;
  final int? taskId;

  ToDo({this.taskId,this.id, this.title, this.isDone});

  Map<String,dynamic> toMap(){
    return{
      'id': id,
      'title': title,
      'isDone': isDone,
      'taskId': taskId
    };
  }

}