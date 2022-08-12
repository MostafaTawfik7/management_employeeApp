import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_task_app/controllers/appcubit/cubit.dart';
import 'package:manage_task_app/controllers/appcubit/states.dart';
import 'package:manage_task_app/models/user.dart';
import 'package:manage_task_app/shared/widgets/componants.dart';
import 'package:manage_task_app/views/home_screen/home_screen.dart';
import 'package:manage_task_app/views/login_screen/login_screen.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: ((context, state) {
          if(state is CreateUserSucceedState){
            ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(message: 'sign up succeed', color: Colors.green),);
            navigatorAndRemove(context: context, widget:const HomeScreen());
          }else if(state is CreateUserFailedState){
            ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(message: 'sign up failed', color: Colors.red));
          }
        }),
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Register',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                ?.copyWith(color: Colors.black, fontSize: 30)),
                        Text('Register now to view tasks',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(color: Colors.grey)),
                        const SizedBox(height: 15),
                        defaultFormField(
                          radius: 10,
                          controller: nameController,
                          type: TextInputType.name,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'please enter your name';
                            }
                            return null;
                          },
                          label: 'Name',
                          prefix: Icons.person_outline,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        defaultFormField(
                          radius: 10,
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'please enter your email';
                            }
                            return null;
                          },
                          label: 'Email Address',
                          prefix: Icons.email_outlined,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        defaultFormField(
                            radius: 10,
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'password is too short';
                              }
                              return null;
                            },
                            isPassword: cubit.isShowPassword,
                            label: 'Password',
                            prefix: Icons.lock_outline,
                            suffix: cubit.seen,
                            suffixPressed: () {
                              cubit.changeVisibilityPassword();
                            }),
                        const SizedBox(
                          height: 30,
                        ),
                        state is! LoadingState
                            ? DefaultButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    UserModel userModel = UserModel(
                                        name: nameController.text,
                                        email: emailController.text,
                                        osUserID: '',
                                        isManager: cubit.isManager);
                                    cubit.createUser(
                                        user: userModel,
                                        password: passwordController.text);
                                  }
                                },
                                text: 'Register',
                              )
                            : const Center(child: CircularProgressIndicator()),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("already I have an account "),
                            TextButton(
                              onPressed: () {
                                navigatorTo(
                                    context: context, widget: LoginScreen());
                              },
                              child: const Text('Login'),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
