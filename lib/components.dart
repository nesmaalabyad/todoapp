import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

import 'cubit/app_cubit.dart';



Widget buildTaskItem(Map model, context) => Dismissible(
  key: Key(model['id'].toString()),
  onDismissed: (direction) {
    showToast(text: 'Item Deleted successfully', state: ToastStates.WARNING);
    AppCubit.get(context).deleteData(id: model['id']);
  },
  child: Padding(
    padding: const EdgeInsets.all(10.0),
    child:

    Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.orange,),

      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.white,),

              child: Row(
          children: [
              Padding(
                padding: const EdgeInsets.only(left: 8,top: 8,bottom: 8,),
                child: CircleAvatar(
                  backgroundColor: Colors.orange,
                  radius: 40,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 40,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '${model['time']}',
                              style: TextStyle( color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${model['title']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      '${model['date']}',
                      style: const TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              IconButton(
                onPressed: () {
                  showToast(text: 'Task is Done', state: ToastStates.SUCCESS);
                  AppCubit.get(context)
                      .updateData(status: 'done', id: model['id']);
                },
                icon: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 30,
                ),
              ),

              IconButton(
                  onPressed: () {
                    showToast(text: 'Task Archived', state: ToastStates.SUCCESS);
                    AppCubit.get(context)
                        .updateData(status: 'archive', id: model['id']);
                  },
                  icon: const Icon(
                    Icons.archive_outlined,
                    color: Colors.black54,
                    size: 30,
                  )),
          ],
        ),
            ),
      ),
    ),
  ),
);


void showToast({
  required text,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );

enum ToastStates { ERROR, SUCCESS, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}
