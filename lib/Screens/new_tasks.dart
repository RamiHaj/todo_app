import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart' as new_tasks;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/Shared/cubit/cubit.dart';
import 'package:todoapp/Shared/cubit/states.dart';

class NewTasks extends StatelessWidget {
  const NewTasks({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<Appcubit, Appstates>(
      listener: (context, state) {},
      builder: (context, state) {

        var tasks = Appcubit
            .get(context)
            .newtasks;

        return new_tasks.ConditionalBuilder(
          condition: tasks.isNotEmpty,
          builder: (context) => ListView.separated(
              itemBuilder: (context, index) =>
                  Dismissible(
                    key: Key(tasks[index]['id'].toString()),
                    onDismissed: (direction)
                    {
                      Appcubit.get(context).deletedatabase(id: tasks[index]['id']);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            child: Text("${tasks[index]['time']}"),
                          ),
                          const SizedBox(width: 10,),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${tasks[index]['title']}",
                                  style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text(
                                  "${tasks[index]['date']}",
                                  style: const TextStyle(
                                      color: Colors.grey
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                Appcubit.get(context).updatedatabase(
                                    status: "Done", id: tasks[index]['id']);
                              },
                              icon: const Icon(
                                Icons.check_box,
                                color: Colors.green,
                              )
                          ),
                          IconButton(
                              onPressed: () {
                                Appcubit.get(context).updatedatabase(
                                    status: "Archived", id: tasks[index]['id']);
                              },
                              icon: const Icon(
                                Icons.archive_sharp,
                                color: Colors.grey,
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
              separatorBuilder: (context, index) =>
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                        start: 20.0
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 1.0,
                      color: Colors.grey,
                    ),
                  ),
              itemCount: tasks.length),
          fallback: (context) => Center(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
                Icon(Icons.menu
                  ,size: 100.0,
                  color: Colors.grey,
                ),
                Text(
                    "No Tasks Yet, Please Add Some Tasks",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey
                  ),
                )
            ],
        ),
          ),
        );
      },
    );
  }
}
