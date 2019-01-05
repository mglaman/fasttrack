import 'package:fasttrack/time_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileWidget extends StatefulWidget {
  @override
  ProfileWidgetState createState() {
    return new ProfileWidgetState();
  }
}

class ProfileWidgetState extends State<ProfileWidget> {
  final timeFormat = DateFormat("h:mm a");

  final TextEditingController fastEndTextController = new TextEditingController();
  final TextEditingController fastStartTextController = new TextEditingController();
  TimeOfDay fastEnd;
  TimeOfDay fastStart;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fastEnd = new TimeOfDay(
          hour: prefs.getInt('fastEndHour') ?? 12,
          minute: prefs.getInt('fastEndMinute') ?? 00,
      );
      fastEndTextController.text = timeFormat.format(DateTime(0).add(Duration(hours: fastEnd.hour, minutes: fastEnd.minute)));

      fastStart = new TimeOfDay(
        hour: prefs.getInt('fastStartHour') ?? 20,
        minute: prefs.getInt('fastStartMinute') ?? 00,
      );
      fastStartTextController.text = timeFormat.format(DateTime(0).add(Duration(hours: fastStart.hour, minutes: fastStart.minute)));
    });
  }
  _updateFastingTimeSetting(key, TimeOfDay value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt("${key}Hour", value.hour);
      prefs.setInt("${key}Minute", value.minute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Text(
            'Profile',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 28),
          ),
          Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20.0,),
                Text(
                    "Eating schedule",
                    style: TextStyle(fontWeight: FontWeight.bold)
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TimePickerFormField(
                        controller: fastEndTextController,
                        format: timeFormat,
                        decoration: InputDecoration(labelText: 'Start'),
                        onChanged: (t) => setState(() {
                          if (t != null) {
                            fastEnd = t;
                            _updateFastingTimeSetting('fastEnd', fastEnd);
                          }
                        }),
                      ),
                    ),
                    SizedBox(width: 20,),
                    Expanded(
                      child: TimePickerFormField(
                        controller: fastStartTextController,
                        format: timeFormat,
                        decoration: InputDecoration(labelText: 'End'),
                        onChanged: (t) => setState(() {
                          if (t != null) {
                            fastStart = t;
                            _updateFastingTimeSetting('fastStart', fastStart);
                          }
                        }),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}