import 'package:flutter/material.dart';
import 'package:manage_task_app/controllers/appcubit/cubit.dart';
import 'package:manage_task_app/models/task.dart';
import 'package:manage_task_app/views/add_task/add_task.dart';

class DefaultButton extends StatelessWidget {
  double width;
  double height;
  String text;
  double elevation;
  void Function()? onPressed;
  DefaultButton({
    Key? key,
    this.width = double.infinity,
    this.height = 45,
    required this.text,
    this.elevation = 5,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: elevation,
            minimumSize: Size(width, height)),
        onPressed: onPressed,
        child: Text(text));
  }
}

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  ValueChanged<String>? onSubmit,
  ValueChanged<String>? onChange,
  GestureTapCallback? onTap,
  bool isPassword = false,
  required FormFieldValidator<String>? validate,
  required String label,
  required IconData prefix,
  double radius = 0.0,
  IconData? suffix,
  Function? suffixPressed,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: () {
                  suffixPressed!();
                },
                icon: Icon(
                  suffix,
                ),
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(radius)),
      ),
    );

void navigatorTo({required context, required Widget widget}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

void navigatorAndRemove({required context, required Widget widget}) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => widget),
    (route) {
      return false;
    },
  );
}

SnackBar buildSnackBar(
    {required String message, required Color color, int duration = 2}) {
  return SnackBar(
    content: Text(
      message,
      style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w500),
    ),
    duration: Duration(seconds: duration),
  );
}

class BuildTaskItem extends StatelessWidget {
  DataOfTask dataOfTask;
  AppCubit cubit;
  BuildTaskItem({
    Key? key,
    required this.dataOfTask,
    required this.cubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10).copyWith(top: 10),
      child: Card(
        shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.teal, width: 2),
            borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Title : ${dataOfTask.task.title}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  PopupMenuButton(
                      color: Colors.teal,
                      onSelected: (value) {
                        if (value == 1) {
                          navigatorTo(
                              context: context,
                              widget: AddTask(
                                dataTask: dataOfTask,
                              ));
                        } else if (value == 2) {
                          cubit.deleteTask(taskId: dataOfTask.taskID);
                        }
                      },
                      itemBuilder: (context) => [
                            const PopupMenuItem(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                              value: 1,
                              child: Text("Update"),
                            ),
                            const PopupMenuItem(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                              value: 2,
                              child: Text("Delete"),
                            )
                          ]),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Description : ${dataOfTask.task.description}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Deadline : ${dataOfTask.task.endTime} ${dataOfTask.task.deadline} ',
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Employee : ${dataOfTask.task.employee}',
                style: const TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.teal, width: 5)),
                    child: IconButton(
                        onPressed: cubit.isManager
                            ? null
                            : () {
                                if (dataOfTask.task.isTimeUp == false) {
                                  dataOfTask.task.isComplete =
                                      !dataOfTask.task.isComplete;
                                  cubit.updateTask(dataOfTask: dataOfTask);
                                  if (dataOfTask.task.isComplete == true &&
                                      dataOfTask.task.isTimeUp == false) {
                                    cubit.sendNotification(
                                        reciverUser: cubit.getSpacificUser(
                                            uID: dataOfTask.task.managerID),
                                        task: dataOfTask.task);
                                  }
                                } else if (dataOfTask.task.isTimeUp &&
                                    dataOfTask.task.isComplete == false) {
                                  return;
                                } else {
                                  dataOfTask.task.isComplete = false;
                                  cubit.updateTask(dataOfTask: dataOfTask);
                                }
                              },
                        icon: dataOfTask.task.isComplete
                            ? const Icon(
                                Icons.done,
                                color: Colors.teal,
                              )
                            : const Icon(
                                Icons.circle_outlined,
                                color: Colors.white,
                              )),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
