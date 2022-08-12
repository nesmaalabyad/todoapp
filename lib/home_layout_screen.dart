import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'components.dart';
import 'cubit/app_cubit.dart';
import 'cubit/states.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, states) {
          if (states is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, states) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(

            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                '${cubit.title[cubit.currentIndex]}',
                style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),

              ),
              backgroundColor: Colors.orange,
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.orange,
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,
                    );
                    titleController.text = '';
                    timeController.text = '';
                    dateController.text = '';
                    showToast(text: 'Task Added', state: ToastStates.SUCCESS);

                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                          padding: const EdgeInsets.all(20),



                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(



                                  controller: titleController,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(

                                    iconColor: Colors.orange,

                                    labelText: 'Task Title',


                                    border: OutlineInputBorder(


                                    ),
                                    prefixIcon: Icon(
                                      Icons.title,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'title must be not empty';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      timeController.text =
                                          value!.format(context).toString();
                                    });
                                  },
                                  controller: timeController,
                                  keyboardType: TextInputType.datetime,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Task Time',
                                    prefixIcon: Icon(
                                      Icons.watch_later_outlined,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Time must be not empty';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2030-05-01'),
                                    ).then((value) {
                                      dateController.text =
                                          DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                  controller: dateController,
                                  keyboardType: TextInputType.datetime,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Task Date',
                                    prefixIcon: Icon(
                                      Icons.calendar_today,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Date must be not empty';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheet(isShow: false, icon: Icons.edit,);
                  });
                  cubit.changeBottomSheet(
                    isShow: true,
                    icon: Icons.add,
                  );
                }
              },
              child: Icon(
                cubit.fabIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              selectedItemColor: Colors.orange,
              onTap: (index) {
                cubit.changeIndex(index);
                // setState(() {
                //   currentIndex = index;
                // });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.question_answer,),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_task),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archived',
                ),
              ],
            ),
            body: cubit.screens[cubit.currentIndex],
          );
        },
      ),
    );
  }
}
