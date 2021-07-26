class Task{
  final String? title;
  final String? description;
  final int? id;

  Task({this.id, this.title, this.description});

  Map<String,dynamic> toMap(){
    return{
      'id': id,
      'title': title,
      'description': description
    };
  }
}