import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/Shared/cubit/cubit.dart';
import 'package:todoapp/Shared/cubit/states.dart';

class Home_Layot extends StatelessWidget {
  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();
  var titlecontroller = TextEditingController();
  var timecontroller = TextEditingController();
  var datecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => Appcubit()..createdatabase(),
      child: BlocConsumer<Appcubit, Appstates>(
        listener: (BuildContext context, Appstates state)
        {
            if(state is AppInsertDataState)
            {
              Navigator.pop(context);
            }
        },
        builder: (BuildContext context, Appstates state)
        {
          Appcubit cubit = Appcubit.get(context);

          return Scaffold(
            key: scaffoldkey,
            appBar: AppBar(
              title: Text(cubit.Titles[cubit.currentindex]),
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                if (cubit.isbottomsheetshow) {
                  if (formkey.currentState!.validate()) {
                    cubit.insertdatabase(
                        title: titlecontroller.text,
                        time: timecontroller.text,
                        date: datecontroller.text
                    );
                    // insertdatabase(
                    //     time: timecontroller.text,
                    //     title: titlecontroller.text,
                    //     date: datecontroller.text)
                    //     .then((value) {
                    //   getdatabase(database).then((value) => {
                    //     Navigator.pop(context),
                    //     tasks = value,
                    //     print(tasks),
                    //     isbottomsheetshow = false,
                    //     fabicon = Icons.edit,
                    //   });
                    // });
                  }
                } else {
                  scaffoldkey.currentState!
                      .showBottomSheet(
                  (context) => Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: formkey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.text,
                                controller: titlecontroller,
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return "Title must not be empty";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    labelText: "Title",
                                    prefixIcon: Icon(Icons.title),
                                    border: OutlineInputBorder()),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.datetime,
                                controller: timecontroller,
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return "Time must not be empty";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    labelText: "Time",
                                    prefixIcon: Icon(Icons.access_time_outlined),
                                    border: OutlineInputBorder()),
                                onTap: () async {
                                  var value = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now());
                                  timecontroller.text = value!.format(context);
                                },
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.datetime,
                                controller: datecontroller,
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return "Date must not be empty";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    labelText: "Date",
                                    prefixIcon:
                                    Icon(Icons.calendar_today_rounded),
                                    border: OutlineInputBorder()),
                                onTap: () async {
                                  var value = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2050));
                                  datecontroller.text =
                                      DateFormat.yMMMd().format(value!);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    elevation: 20.0,
                  )
                      .closed
                      .then((value) {
                    cubit.ChangeBottomSheetShow(
                        isshow: false,
                        icon: Icons.edit);
                  });
                  cubit.ChangeBottomSheetShow(
                      isshow: true,
                      icon: Icons.add);
                }
              },
              child: Icon(cubit.fabicon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: true,
              onTap: (index) {
                cubit.changeindex(index);
              },
              currentIndex: cubit.currentindex,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Tasks"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline), label: "Done"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: "Archived"),
              ],
            ),
            body: cubit.screens[cubit.currentindex],
          );
        },

      ),
    );
  }
}
