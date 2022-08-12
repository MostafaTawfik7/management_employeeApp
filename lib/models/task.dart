class DataOfTask {
  String taskID;
  TaskModel task;
  DataOfTask({
    required this.taskID,
    required this.task,
  });

  Map<String, dynamic> toMap() {
    return {
      'taskID': taskID,
      'task': task.toMap(),
    };
  }

  factory DataOfTask.fromMap(Map<String, dynamic> map) {
    return DataOfTask(
      taskID: map['taskID'] ?? '',
      task: TaskModel.fromMap(map['task']),
    );
  }
}

class TaskModel {
  late String title;
  late String description;
  late String deadline;
  late String endTime;
  late String employee;
  late String uID;
  late String managerID;
  late bool isComplete;
  late bool isTimeUp;

  TaskModel(
      {required this.title,
        required this.description,
        required this.deadline,
        required this.endTime,
        required this.employee,
        required this.uID,
        required this.managerID,
        this.isComplete = false,
        this.isTimeUp = false});

  TaskModel.fromMap(Map<String, dynamic> map) {
    title = map['title'];
    description = map['description'];
    deadline = map['deadline'];
    employee = map['employee'];
    uID = map['uID'];
    managerID = map['managerID'];
    endTime = map['endTime'];
    isComplete = map['isComplete'];
    isTimeUp = map['isTimeUp'];
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'deadline': deadline,
      'endTime': endTime,
      'employee': employee,
      'uID': uID,
      'managerID': managerID,
      'isComplete': isComplete,
      'isTimeUp': isTimeUp,
    };
  }
}
