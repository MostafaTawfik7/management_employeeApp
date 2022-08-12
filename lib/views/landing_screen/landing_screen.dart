import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_task_app/controllers/appcubit/cubit.dart';
import 'package:manage_task_app/controllers/appcubit/states.dart';
import 'package:manage_task_app/shared/widgets/componants.dart';
import 'package:manage_task_app/views/login_screen/login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: ((context, state) {}),
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return Scaffold(
            body: SizedBox(
              width: double.infinity,
              child: Column(children: [
                Expanded(
                    child: Image.asset(
                  'assets/images/Logo.png',
                  height: 200,
                  width: 200,
                )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: DefaultButton(
                      text: 'Manager',
                      onPressed: () {
                        cubit.changeIsManager(value: true);
                        navigatorTo(context: context, widget: LoginScreen());
                      }),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: DefaultButton(
                      text: 'Employee',
                      onPressed: () {
                        cubit.changeIsManager(value: false);
                        navigatorTo(context: context, widget: LoginScreen());
                      }),
                ),
                const SizedBox(
                  height: 50,
                )
              ]),
            ),
          );
        });
  }
}
