// ignore_for_file: avoid_print, must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/AppComponent/appcomponant.dart';
import 'package:notes_app/AppCubit/cubit.dart';
import 'package:notes_app/AppCubit/state.dart';


class HomeLayout extends StatelessWidget {
  HomeLayout({Key? key}) : super(key: key);
  var tittlecontroler = TextEditingController();
  var timecontroler = TextEditingController();
  var datecontroler = TextEditingController();

  bool isbottomsheetshown = false;
  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createdatabase(),
      child: BlocConsumer<AppCubit, AppState>(listener: (context, state) {
        if (state is AppInsretDataBase) {
          Navigator.pop(context);
          AppCubit.get(context).showtost();
        }
      }, builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          key: scaffoldkey,
          backgroundColor: const Color.fromARGB(187, 84, 170, 204),
          body: ConditionalBuilder(
            builder: (context) => cubit.screens[cubit.currentIndex],
            condition: state is! AppLoading,
            fallback: (context) =>
                const Center(child: CircularProgressIndicator()),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.add,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              if (isbottomsheetshown) {
                if (formkey.currentState!.validate()) {
                  cubit.inserttodatabase(
                    title: tittlecontroler.text,
                    date: datecontroler.text,
                    time: timecontroler.text,
                  );
                }
              } else {
                scaffoldkey.currentState!
                    .showBottomSheet(
                      (context) => Container(
                        color: const Color.fromARGB(185, 46, 113, 139),
                        child: Form(
                          key: formkey,
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.width * 0.30,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(90.0),
                                          bottomRight: Radius.circular(90.0))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.tips_and_updates_outlined,
                                        color:
                                            Color.fromARGB(187, 84, 170, 204),
                                        size: 50.0,
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        "Add a Plan",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                defultformfield(
                                    controller: tittlecontroler,
                                    validate: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'Title must be not empty';
                                      }
                                      return null;
                                    },
                                    name: 'Plan of The day',
                                    iconData: Icons.title,
                                    ontap: () {},
                                    type: TextInputType.text),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                defultformfield(
                                    controller: datecontroler,
                                    validate: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'Date must be not empty';
                                      }
                                      return null;
                                    },
                                    name: 'Get your date',
                                    iconData: Icons.calendar_today,
                                    ontap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate:
                                                  DateTime.parse('2023-10-08'))
                                          .then((value) {
                                        datecontroler.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                    type: TextInputType.datetime),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                defultformfield(
                                    controller: timecontroler,
                                    validate: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'Time must be not empty';
                                      }
                                      return null;
                                    },
                                    name: 'Get your Time',
                                    iconData: Icons.watch_later_outlined,
                                    ontap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) {
                                        timecontroler.text =
                                            value!.format(context).toString();
                                      });
                                    },
                                    type: TextInputType.datetime),
                                const SizedBox(height: 15.0),
                              ]),
                        ),
                      ),
                    )
                    .closed
                    .then((value) {
                  isbottomsheetshown = false;
                });
                isbottomsheetshown = true;
              }
            },
          ),
          bottomNavigationBar: GNav(
            tabBackgroundColor: Colors.white,
            color: Colors.white,
            padding: const EdgeInsets.all(15.0),
            tabs: const [
              GButton(
                icon: Icons.menu,
                text: 'Task',
              ),
              GButton(
                icon: Icons.check_circle_outline,
                text: 'Done',
              ),
              GButton(
                icon: Icons.archive_outlined,
                text: 'Archived',
              ),
            ],
            selectedIndex: cubit.currentIndex,
            onTabChange: (index) {
              cubit.changapp(index);
            },
          ),
        );
      }),
    );
  }
}
