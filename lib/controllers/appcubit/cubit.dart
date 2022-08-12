import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_task_app/controllers/appcubit/states.dart';
import 'package:manage_task_app/models/task.dart';
import 'package:manage_task_app/models/user.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  bool isManager = false;
  void changeIsManager({required bool value}) {
    isManager = value;
    emit(ChangeIsManager());
  }

  DataUserModel? selectedUser;
  void chnageSelectedUser(DataUserModel user) {
    selectedUser = user;
    emit(ChangeSelectedUserState());
  }

  void createUser({required UserModel user, required String password}) {
    emit(LoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: user.email, password: password)
        .then((value) {
      userID = value.user!.uid;
      updateOSUserID();
      emit(CreateUserSucceedState());
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(user.toMap())
          .then((value) {
        emit(StoreUserInFireStoreSucceedState());
        getCurrentUser();
      }).catchError((error) {
        debugPrint('store user error ${error.toString()}');
        emit(StoreUserInFireStoreFailedState());
      });
    }).catchError((error) {
      debugPrint('create user error ${error.toString()}');
      emit(CreateUserFailedState());
    });
  }

  late String userID;
  Future<String> signInUser(
      {required String email, required String password}) async {
    String uID = '';
    emit(LoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      userID = value.user!.uid;
      uID = value.user!.uid;

      emit(SignInUserSucceedState());
      getCurrentUser();
      updateOSUserID();
    }).catchError((error) {
      debugPrint('sign in user error ${error.toString()}');
      emit(SignInUserFailedState());
    });
    return uID;
  }

  String createTask({required TaskModel task}) {
    late String taskID;
    emit(LoadingState());
    FirebaseFirestore.instance
        .collection('tasks')
        .add(task.toMap())
        .then((value) {
      taskID = value.id;
      debugPrint(value.toString());

      emit(CreateTaskSucceedState());
    }).catchError((error) {
      debugPrint(error.toString());
      emit(CreateTaskFailedState());
    });
    return taskID;
  }

  void deleteTask({required String taskId}) {
    emit(LoadingState());
    FirebaseFirestore.instance
        .collection('tasks')
        .doc(taskId)
        .delete()
        .then((value) {
      emit(DeleteTaskSucceedState());
    }).catchError((error) {
      debugPrint('error from method delete task ${error.toString()}');
      emit(DeleteTaskFailedState());
    });
  }

  List<DataOfTask> dataOfTasks = [];
  List<DataOfTask> dataOfTaskComplete = [];
  List<DataOfTask> dataOfTaskUncomplete = [];
  void getAllTasks() {
    emit(LoadingState());
    FirebaseFirestore.instance
        .collection('tasks')
        .orderBy('endTime')
        .snapshots()
        .listen((event) {
      dataOfTasks = [];
      dataOfTaskComplete = [];
      dataOfTaskUncomplete = [];
      for (var element in event.docs) {
        dataOfTasks.add(DataOfTask(
            taskID: element.id, task: TaskModel.fromMap(element.data())));
      }
      for (var element in dataOfTasks) {
        if (element.task.isComplete == true) {
          dataOfTaskComplete.add(element);
        } else {
          dataOfTaskUncomplete.add(element);
        }
      }
      emit(GetAllTasksSucceedState());
    }).onError((error) {
      debugPrint(error.toString());
      emit(GetAllTasksFailedState());
    });
  }

  List<DataOfTask> dataOfTasksOfEmployee = [];
  List<DataOfTask> dataOfTaskOfEmployeeComplete = [];
  List<DataOfTask> dataOfTaskOfEmployeeUncomplete = [];
  void getAllTasksOfEmployee() {
    dataOfTasksOfEmployee = [];
    dataOfTaskOfEmployeeComplete = [];
    dataOfTaskOfEmployeeUncomplete = [];
    for (var element in dataOfTasks) {
      if (element.task.uID == userID) {
        dataOfTasksOfEmployee.add(element);
      }
    }
    for (var element in dataOfTasksOfEmployee) {
      if (element.task.isComplete == true) {
        dataOfTaskOfEmployeeComplete.add(element);
      } else {
        dataOfTaskOfEmployeeUncomplete.add(element);
      }
    }
  }

  List<DataUserModel> employeesData = [];
  List<DataUserModel> managersData = [];

  void getAllEmployees() {
    emit(LoadingState());
    FirebaseFirestore.instance.collection('users').snapshots().listen((event) {
      employeesData = [];
      managersData = [];

      for (var element in event.docs) {
        if (element.data()['isManager'] == false) {
          employeesData.add(DataUserModel(
              uID: element.id, userModel: UserModel.fromMap(element.data())));
        } else {
          managersData.add(DataUserModel(
              uID: element.id, userModel: UserModel.fromMap(element.data())));
        }
      }
      debugPrint('length of employeeusers ${employeesData.length.toString()}');
      debugPrint("user is ${employeesData[0].userModel.name}");
      emit(GetAllEmployeesSucceedState());
    }).onError((error) {
      debugPrint(error.toString());
      emit(GetAllEmployeesFailedState());
    });
  }

  updateTask({required DataOfTask dataOfTask}) {
    emit(LoadingState());
    FirebaseFirestore.instance
        .collection('tasks')
        .doc(dataOfTask.taskID)
        .update(dataOfTask.task.toMap())
        .then((value) {
      getAllTasksOfEmployee();
      emit(UpdateTaskSucceedState());
    }).catchError((error) {
      debugPrint(error.toString());
      emit(UpdateTaskFailedState());
    });
  }

  late DataUserModel currentUser;
  getCurrentUser() {
    emit(LoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .get()
        .then((value) {
      currentUser = DataUserModel(
          uID: userID, userModel: UserModel.fromMap(value.data()!));
      emit(GetSpacificUserSucceedState());
    }).catchError((error) {
      debugPrint('error of get spacific user method $error');
      emit(GetSpacificUserFailedState());
    });
  }

  DataUserModel getSpacificUser({required String uID}) {
    late DataUserModel userModel;
    emit(LoadingState());
    FirebaseFirestore.instance.collection('users').doc(uID).get().then((value) {
      userModel =
          DataUserModel(uID: uID, userModel: UserModel.fromMap(value.data()!));
      emit(GetSpacificUserSucceedState());
    }).catchError((error) {
      debugPrint('error of get spacific user method $error');
      emit(GetSpacificUserFailedState());
    });
    return userModel;
  }

  bool isShowPassword = true;
  IconData seen = Icons.visibility_off_outlined;
  void changeVisibilityPassword() {
    if (!isShowPassword) {
      isShowPassword = !isShowPassword;
      seen = Icons.visibility_outlined;
    } else {
      isShowPassword = !isShowPassword;
      seen = Icons.visibility_off_outlined;
    }
    emit(LoginChangePasswordVisibilityState());
  }

  sendNotification({
    required DataUserModel reciverUser,
    required TaskModel task,
  }) async {
    emit(LoadingState());

    var imgUrlString =
        "https://i.pinimg.com/564x/5f/9c/33/5f9c33accdb78c4704cce33fbb0b9f99.jpg";

    var notification = OSCreateNotification(
      playerIds: [reciverUser.userModel.osUserID],
      content: " ${task.description}",
      heading: task.title,
      subtitle: 'Is created now',
      iosAttachments: {"id1": imgUrlString},
      bigPicture: imgUrlString,
    );

    OneSignal.shared.postNotification(notification).then((value) {
      debugPrint("Sent notification with response: $value");
      emit(SendNotificationsSucceedState());
    }).catchError((error) {
      debugPrint('error from sendNotification ${error.toString()}');
      emit(SendNotificationsFailedState());
    });
  }

  sendNotificationAfterDeadline({
    required DataUserModel reciverUser,
    required DataOfTask datatask,
  }) async {
    emit(LoadingState());

    var imgUrlString =
        "https://i.pinimg.com/564x/5f/9c/33/5f9c33accdb78c4704cce33fbb0b9f99.jpg";

    var notification = OSCreateNotification(
      playerIds: [reciverUser.userModel.osUserID],
      content: " ${datatask.task.description}",
      heading: datatask.task.title,
      subtitle: 'Time up',
      iosAttachments: {"id1": imgUrlString},
      bigPicture: imgUrlString,
      // well done to more infomations go to oneSignal Api
      sendAfter: hendleDateOfTask(datatask.task).toUtc(),
      deliveryTimeOfDay: datatask.task.endTime,
      delayedOption: OSCreateNotificationDelayOption.timezone,
    );

    OneSignal.shared.postNotification(notification).then((value) {
      debugPrint("Sent notification with response: $value");
      datatask.task.isTimeUp = true;
      updateTask(dataOfTask: datatask);
      emit(SendNotificationsSucceedState());
    }).catchError((error) {
      debugPrint(
          'error from sendNotificationAfterDeadline ${error.toString()}');
      emit(SendNotificationsFailedState());
    });
  }

  DateTime hendleDateOfTask(TaskModel task) {
    late DateTime taskDate;
    if (task.endTime.contains('PM')) {
      int hour = int.parse(task.endTime.split(':')[0]) + 12;
      int minutes = int.parse(task.endTime.split(':')[1].split(" ")[0]);
      if (minutes == 0) {
        taskDate = DateTime.parse('${task.deadline} $hour:${minutes}0:00');
      } else if (minutes < 10) {
        taskDate = DateTime.parse('${task.deadline} $hour:0$minutes:00');
      } else {
        taskDate = DateTime.parse('${task.deadline} $hour:$minutes:00');
      }
    } else {
      int hour = int.parse(task.endTime.split(':')[0]);
      if (hour > 9) {
        taskDate = DateTime.parse(
            '${task.deadline} $hour${task.endTime.substring(2, 4)}:00');
      } else {
        taskDate = DateTime.parse(
            '${task.deadline} 0${task.endTime.substring(0, 4)}:00');
      }
    }
    debugPrint('from method hendler date of task $taskDate');
    return taskDate;
  }

  updateOSUserID() {
    emit(LoadingState());
    OneSignal.shared.getDeviceState().then((value) {
      DocumentReference ref =
          FirebaseFirestore.instance.collection('users').doc(userID);

      ref.update({
        'osUserID': '${value!.userId}',
      });
      debugPrint(value.userId);
      emit(UpdateOSUserIDSucceedState());
    }).catchError((error) {
      debugPrint(error.toString());
      emit(UpdateOSUserIDFailedState());
    });
  }

  hundleOpenNotifications() {
    OneSignal.shared.setNotificationOpenedHandler((openedResult) {
      debugPrint('Notification Opened $openedResult');
    });
  }
}
