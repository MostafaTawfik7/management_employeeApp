import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_task_app/controllers/appcubit/cubit.dart';
import 'package:manage_task_app/controllers/appcubit/states.dart';
import 'package:manage_task_app/models/task.dart';
import 'package:manage_task_app/models/user.dart';
import 'package:manage_task_app/shared/widgets/componants.dart';

class AddTask extends StatefulWidget {
  DataOfTask? dataTask;
  AddTask({Key? key, this.dataTask}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titleController = TextEditingController();

  TextEditingController decriptionController = TextEditingController();

  TextEditingController deadlineController = TextEditingController();

  TextEditingController endTimeController = TextEditingController();
  TextEditingController employeeController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.dataTask != null) {
      titleController.text = widget.dataTask!.task.title;
      deadlineController.text = widget.dataTask!.task.deadline;
      decriptionController.text = widget.dataTask!.task.description;
      endTimeController.text = widget.dataTask!.task.endTime;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(
                widget.dataTask!.task == null ? 'Add task' : 'Update task',
              ),
              leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 15,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Title'),
                                const SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                  controller: titleController,
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.black),
                                  decoration: const InputDecoration(
                                    hintText: 'Design team meeting',
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'you must enter value';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12),
                                const Text('Description'),
                                const SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                  controller: decriptionController,
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.black),
                                  decoration: const InputDecoration(
                                    hintText: 'write description',
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'you must enter value';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12),
                                const Text('Deadline'),
                                const SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                  controller: deadlineController,
                                  readOnly: true,
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.black),
                                  onTap: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime.now().add(
                                                const Duration(
                                                    days: (365 * 5))))
                                        .then((value) {
                                      String deadline =
                                          value.toString().substring(0, 10);
                                      debugPrint(deadline);
                                      deadlineController.text = deadline;
                                    }).catchError((error) {
                                      debugPrint(error.toString());
                                    });
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'you must enter value';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      hintText: DateTime.now()
                                          .toString()
                                          .substring(0, 10),
                                      suffixIcon: const Icon(
                                          Icons.keyboard_arrow_down_outlined)),
                                ),
                                const SizedBox(height: 12),
                                const Text('End time'),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: endTimeController,
                                  readOnly: true,
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      String startTime =
                                          value!.format(context).toString();
                                      debugPrint(startTime);
                                      endTimeController.text = startTime;
                                    }).catchError((error) {
                                      debugPrint(error.toString());
                                    });
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'you must enter value';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      hintText: TimeOfDay.now().format(context),
                                      suffixIcon: const Icon(
                                        Icons.watch_later_outlined,
                                        size: 20,
                                      )),
                                ),
                                const SizedBox(height: 12),
                                const Text('Employee'),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<DataUserModel>(
                                    isDense: true,
                                    hint: const Text('Select an employee'),
                                    validator: (value) {
                                      if (value == null) {
                                        return 'you must select value';
                                      }
                                      return null;
                                    },
                                    items: cubit.employeesData
                                        .asMap()
                                        .map(
                                          (key, value) => MapEntry(
                                              key,
                                              DropdownMenuItem(
                                                value: value,
                                                child:
                                                    Text(value.userModel.name),
                                              )),
                                        )
                                        .values
                                        .toList(),
                                    onChanged: (value) {
                                      cubit.chnageSelectedUser(value!);
                                    }),
                                const SizedBox(height: 40),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    DefaultButton(
                        onPressed: () {
                          late String taskID;
                          if (formKey.currentState!.validate()) {
                            TaskModel task = TaskModel(
                                title: titleController.text,
                                description: decriptionController.text,
                                deadline: deadlineController.text,
                                endTime: endTimeController.text,
                                employee: cubit.selectedUser!.userModel.name,
                                uID: cubit.selectedUser!.uID,
                                managerID: cubit.currentUser.uID);
                            if (widget.dataTask!.taskID == null) {
                              taskID = cubit.createTask(task: task);
                            } else {
                              taskID = widget.dataTask!.taskID;
                              task.isTimeUp = false;
                              task.isComplete = false;
                              cubit.updateTask(
                                  dataOfTask:
                                      DataOfTask(taskID: taskID, task: task));
                            }

                            cubit.sendNotification(
                              reciverUser: cubit.selectedUser!,
                              task: task,
                            );
                            cubit.sendNotificationAfterDeadline(
                                reciverUser: cubit.currentUser,
                                datatask:
                                    DataOfTask(taskID: taskID, task: task));
                            cubit.sendNotificationAfterDeadline(
                                reciverUser: cubit.selectedUser!,
                                datatask:
                                    DataOfTask(taskID: taskID, task: task));
                            Navigator.pop(context);
                          }
                        },
                        text: widget.dataTask!.task == null
                            ? 'Create'
                            : 'Update'),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
