import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:manage_task_app/controllers/appcubit/cubit.dart';
import 'package:manage_task_app/controllers/appcubit/states.dart';
import 'package:manage_task_app/models/task.dart';
import 'package:manage_task_app/shared/widgets/componants.dart';

class CompleteTasks extends StatelessWidget {
  const CompleteTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          List<DataOfTask> list;
          if (cubit.isManager) {
            list = cubit.dataOfTaskComplete;
          } else {
            list = cubit.dataOfTaskOfEmployeeComplete;
          }
          return list.isNotEmpty
              ? ListView.builder(
                  itemBuilder: (context, index) {
                    return BuildTaskItem(
                      dataOfTask: list[index],
                      cubit: cubit,
                    );
                  },
                  itemCount: list.length)
              : Center(
                  child: SvgPicture.asset(
                    'assets/images/task.svg',
                    color: Colors.teal,
                    width: 150,
                    height: 150,
                  ),
                );
        });
  }
}
