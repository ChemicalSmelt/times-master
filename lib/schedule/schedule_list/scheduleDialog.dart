import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'scheduleDateTime.dart';
import 'trip.dart';

class ScheduleDialog extends StatefulWidget {
  String name = '';
  String content = '';
  late ScheduleDateTime dateTime;
  ScheduleDialog({super.key}){
    dateTime = ScheduleDateTime(
        year: DateTime.now().year,
        month: DateTime.now().month,
        day: DateTime.now().day,
        hour: DateTime.now().hour,
        minute: DateTime.now().minute
    );
  }
  ScheduleDialog.select({super.key, required this.dateTime});
  ScheduleDialog.update({super.key, required this.name, required this.content, required this.dateTime});

  @override
  State<ScheduleDialog> createState() => _ScheduleDialogState();
}

class _ScheduleDialogState extends State<ScheduleDialog> {
  //String name = '';
  //String content = '';
  //late ScheduleDateTime dateTime;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState(){
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("添加行程"),
      content: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 300,
                child: TextFormField(
                  initialValue: widget.name,
                  autofocus: true,
                  decoration: const InputDecoration(
                      labelText: "行程名稱", hintText: '請輸入行程名稱'),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return '請輸入行程名稱';
                    }
                    widget.name = value;
                    return null;
                  },
                ),
              ),
              Container(
                width: 300,
                child: TextFormField(
                  initialValue: widget.content,
                  autofocus: true,
                  decoration: const InputDecoration(
                      labelText: "行程內容", hintText: '請輸入行程內容'),
                  validator: (value){
                    widget.content = value ?? "";
                    return null;
                  },
                ),
              ),
              Container(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        chooseDateTime();
                      });
                    },
                    child: const Text('選擇日期'),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  //year
                  Container(
                    width: 50,
                    child: TextFormField(
                      controller: TextEditingController(text: widget.dateTime.year.toString()),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      maxLength: 4,
                      validator: (value){
                        int ?v = int.tryParse(value ?? "") ;
                        if(v == null || v < DateTime.now().year){
                          return '';
                        }
                        widget.dateTime.year = v;
                        return null;
                      },
                    ),
                  ),
                  Container(
                    width: 10,
                    child: const Text("-"),
                  ),
                  //month
                  Container(
                    width: 30,
                    child: TextFormField(
                      controller: TextEditingController(text: widget.dateTime.month.toString()),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      maxLength: 2,
                      validator: (value){
                        int ?v = int.tryParse(value ?? "") ;
                        if(v == null || v < 1 || v > 12){
                          return '';
                        }
                        widget.dateTime.month = v;
                        return null;
                      },
                    ),
                  ),
                  Container(
                    width: 10,
                    child: const Text("-"),
                  ),
                  Container(
                    width: 30,
                    child: TextFormField(
                      controller: TextEditingController(text: widget.dateTime.day.toString()),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      maxLength: 2,
                      validator: (value){
                        int ?v = int.tryParse(value ?? "") ;
                        if(v == null || v < 1 || v > getMaxDaysInMonth(widget.dateTime.year, widget.dateTime.month)){
                          return '';
                        }
                        widget.dateTime.day = v;
                        return null;
                      },
                    ),
                  ),
                  Container(
                    width: 10,
                    child: const Text(" "),
                  ),
                  // hour
                  Container(
                    width: 30,
                    child: TextFormField(
                      controller: TextEditingController(text: widget.dateTime.hour.toString()),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      maxLength: 2,
                      validator: (value){
                        int ?v = int.tryParse(value ?? "") ;
                        if(v == null || v < 0 || v > 59){
                          return '';
                        }
                        widget.dateTime.hour = v;
                        return null;
                      },
                    ),
                  ),
                  Container(
                    width: 10,
                    child: const Text(":"),
                  ),
                  Container(
                    width: 30,
                    child: TextFormField(
                      controller: TextEditingController(text: widget.dateTime.minute.toString()),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      maxLength: 2,
                      validator: (value){
                        int ?v = int.tryParse(value ?? "") ;
                        if(v == null || v < 0 || v > 59){
                          return '';
                        }
                        widget.dateTime.minute = v;
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if(_formKey.currentState!.validate()) {
                        Navigator.pop(
                          context,
                          Trip(
                              id: 0,
                              headerValue: widget.name,
                              expandedValue: widget.content,
                              date: widget.dateTime
                          ),
                        );
                      }
                    },
                    child: const Text('submit'),
                  ),
                ],
              )
            ],
          )
      ) ,

    );
  }
  int getMaxDaysInMonth(int year, int month){
    DateTime firstDayOfMonth = DateTime(year, month, 1);
    DateTime firstDayOfNextMonth = DateTime.utc(year, month+1, 1);

    Duration difference = firstDayOfNextMonth.difference(firstDayOfMonth);

    return difference.inDays;
  }

  ScheduleDateTime? getDate() {
    return widget.dateTime;
  }

  void chooseDateTime() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    ).then((date) {
      showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      ).then((time) {
        setState(() {
          widget.dateTime = ScheduleDateTime(
              year: date?.year ?? DateTime.now().year,
              month: date?.month ?? DateTime.now().month,
              day: date?.day ?? DateTime.now().day,
              hour: time?.hour ?? TimeOfDay.now().hour,
              minute: time?.minute ?? TimeOfDay.now().minute);
        });
      }).catchError((errorMsg) {
        debugPrint(errorMsg.toString());
      }).catchError((errorMsg) {
        debugPrint(errorMsg.toString());
      });
    });
  }
}
