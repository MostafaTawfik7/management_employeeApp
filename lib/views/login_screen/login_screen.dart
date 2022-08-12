import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_task_app/controllers/appcubit/cubit.dart';
import 'package:manage_task_app/controllers/appcubit/states.dart';
import 'package:manage_task_app/shared/widgets/componants.dart';
import 'package:manage_task_app/views/home_screen/home_screen.dart';
import '../register_screen/register_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(listener: ((context, state) {
      var cubit1 = AppCubit.get(context);
      if (state is SignInUserSucceedState) {
        if (cubit1.isManager) {
          for (var element in cubit1.managersData) {
            if (element.uID == cubit1.userID) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildSnackBar(message: 'sign in succeed', color: Colors.green),
              );
              navigatorAndRemove(context: context, widget: const HomeScreen());
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                buildSnackBar(
                    message: 'sign in failed your are not manager',
                    color: Colors.red),
              );
            }
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            buildSnackBar(message: 'sign in succeed', color: Colors.green),
          );
          navigatorAndRemove(context: context, widget: const HomeScreen());
        }
      } else if (state is SignInUserFailedState) {
        ScaffoldMessenger.of(context).showSnackBar(
          buildSnackBar(message: 'sign in failed', color: Colors.red),
        );
      }
    }), builder: (context, state) {
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
                    Text('LOGIN',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(color: Colors.black, fontSize: 30)),
                    Text('Login now to view tasks',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(color: Colors.grey)),
                    const SizedBox(height: 15),
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
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                cubit.signInUser(
                                    email: emailController.text,
                                    password: passwordController.text);
                              }
                            },
                            text: 'Login',
                          )
                        : const Center(child: CircularProgressIndicator()),
                    const SizedBox(
                      height: 8,
                    ),
                    cubit.isManager
                        ? Container()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account ?"),
                              TextButton(
                                onPressed: () {
                                  navigatorTo(
                                      context: context,
                                      widget: RegisterScreen());
                                },
                                child: const Text('Register'),
                              )
                            ],
                          )
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
