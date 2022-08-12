import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components.dart';
import '../cubit/app_cubit.dart';
import '../cubit/states.dart';

class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, states) {},
      builder: (context, states) {
        var tasks = AppCubit.get(context).archivedTasks;

        return ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
          separatorBuilder: (context, index) => Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey[300],
          ),
          itemCount: tasks.length,
        );
      },
    );
  }
}
