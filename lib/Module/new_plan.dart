import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/AppComponent/appcomponant.dart';
import 'package:notes_app/AppCubit/cubit.dart';
import 'package:notes_app/AppCubit/state.dart';


class NewTask extends StatelessWidget {
  const NewTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var plan = AppCubit.get(context).newTasks;
        return Scaffold(
          backgroundColor: const Color.fromARGB(187, 84, 170, 204),
          body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 0.60,
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
                          color: Color.fromARGB(187, 84, 170, 204),
                          size: 80.0,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "Today's planning",
                          style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 35.0,
                  ),
                  planBuilder(plan: plan)
                ]),
          ),
        );
      },
    );
  }
}
