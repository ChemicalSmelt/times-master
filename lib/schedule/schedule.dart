import 'package:flutter/material.dart';
import 'schedule_list/schedule_list.dart';
import '../kit/function_menu.dart';
import 'to-do_list/to-do_list.dart';
import 'personal_habit/personal_habit.dart';

class Schedule extends StatefulWidget{
  final String title = "行程管理";
  const Schedule({super.key});
  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> with SingleTickerProviderStateMixin{
  TabController ?_controller;
  var _tabs = <Tab>[];

  @override
  void initState(){
    super.initState();
    _controller = TabController(initialIndex: 0, length: 3, vsync: this);
    _tabs = <Tab>[
      const Tab(text: "行程列表",),
      const Tab(text: "待辦事項",),
      const Tab(text: "個人習慣",),
    ];
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: TabBar(tabs: _tabs,
          indicatorColor: Colors.white,
          indicatorWeight: 5,
          indicatorSize: TabBarIndicatorSize.tab,
          controller: _controller,
        ),
      ),
      drawer: const FunctionMenu(),
      body: TabBarView(
          controller: _controller,
          children: const <Widget>[
            Center(
              child: ScheduleList(),
            ),
            Center(
              child: TodoList(),
            ),
            Center(
              child: PersonalHabit(),
            ),
          ]
      ),
    );
  }

  @override
  void dispose(){
    super.dispose();
    _controller?.dispose();
  }
}