import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_task_app/controllers/appcubit/cubit.dart';
import 'package:manage_task_app/controllers/appcubit/states.dart';
import 'package:manage_task_app/shared/widgets/componants.dart';
import 'package:manage_task_app/views/add_task/add_task.dart';
import 'package:manage_task_app/views/home_screen/widgets/all_task.dart';
import 'package:manage_task_app/views/home_screen/widgets/complete_task.dart';
import 'package:manage_task_app/views/home_screen/widgets/uncomplete_task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    BlocProvider.of<AppCubit>(context).getAllTasks();
    BlocProvider.of<AppCubit>(context).getAllEmployees();

    if (BlocProvider.of<AppCubit>(context).isManager == false) {
      BlocProvider.of<AppCubit>(context).getAllTasksOfEmployee();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(builder: (context, state) {
      var cubit = AppCubit.get(context);
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Board',
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Colors.white),
          ),
        ),
        body: SizedBox(
          width: double.infinity,
          child: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                TabBar(
                    labelColor: Colors.teal,
                    unselectedLabelColor: Colors.grey.shade400,
                    labelStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: const [
                      Tab(
                        text: "All",
                      ),
                      Tab(
                        text: "Completed",
                      ),
                      Tab(
                        text: "UnCompleted",
                      ),
                    ]),
                Divider(
                  height: 1.0,
                  color: Colors.grey.shade300,
                ),
                const Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child:
                        TabBarView(physics: BouncingScrollPhysics(), children: [
                      AllTasks(),
                      CompleteTasks(),
                      UnCompleteTasks(),
                    ]),
                  ),
                ),
                const SizedBox(height: 20),
                cubit.isManager
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: DefaultButton(
                            onPressed: () async {
                              navigatorTo(context: context, widget: AddTask());
                            },
                            text: 'Add Task'))
                    : const SizedBox(height: 0),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      );
    });
  }
}
