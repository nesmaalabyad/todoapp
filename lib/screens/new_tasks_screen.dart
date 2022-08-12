import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import '../components.dart';
import '../cubit/app_cubit.dart';
import '../cubit/states.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, states) {},
      builder: (context, states) {
        var tasks = AppCubit.get(context).newTasks;

        return Conditional.single(
          context: context,
          conditionBuilder: (BuildContext context) => tasks.isNotEmpty,
          widgetBuilder: (BuildContext context) {
            return ListView.separated(
              itemBuilder: (context, index) =>
                  buildTaskItem(tasks[index], context),
              separatorBuilder: (context, index) => Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ),
              itemCount: tasks.length,
            );
          },
          fallbackBuilder: (BuildContext context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.question_answer_outlined,
                  size: 50,
                  color: Colors.grey,
                ),
                Text(
                  'No Tasks Here !',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
