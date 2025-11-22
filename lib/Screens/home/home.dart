import 'package:flutter/material.dart';
import 'package:medicinereminder/Screens/add_new_medicine/add_new_medicine.dart';
import 'package:medicinereminder/Screens/home/calendar.dart';
import 'package:medicinereminder/Screens/home/medicine_list.dart';
import 'package:medicinereminder/Screens/home/refresh_screen.dart';
import 'package:medicinereminder/database/respository.dart';
import 'package:medicinereminder/logout_Screen/logout_Screen.dart';
import 'package:medicinereminder/models/calendardaymodel.dart';
import 'package:medicinereminder/models/pill_type.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'home_screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _lastchooseday = 0;
  List<CalendarDayModel> _daylist = [];

  List<Pill> alllistofPills = [];
  final Respository _respository = Respository();
  List<Pill> dailyPills = [];

  @override
  void initState() {
    super.initState();
    _daylist = CalendarDayModel('', 0, 0, 0, false).getcurrentday();
    setData();
  }

  Future<void> setData() async {
    alllistofPills.clear();
    var fetchedPills = await _respository.getAlldata("Pills");
    alllistofPills =
        fetchedPills.map((pillMap) => Pill.fromMap(pillMap)).toList();

    if (mounted) {
      setState(() {
        chooseDay(_daylist[_lastchooseday]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget addbutton = FloatingActionButton(
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddNewMedicine()),
        );
        if (result != null && result as bool) {
          await setData();
        }
      },
      backgroundColor: Theme.of(context).primaryColor,
      child: const Icon(Icons.add, color: Colors.white, size: 25.0),
    );

    final double deviceheight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Scaffold(
      floatingActionButton: addbutton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              SizedBox(height: deviceheight * 0.05),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, LogoutScreen.id);
                      },
                      child: const Icon(Icons.exit_to_app, size: 42.0),
                    ),
                    Text(
                      "Journal",
                      style: Theme.of(
                        context,
                      ).textTheme.displayLarge!.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    TextButton(
                      onPressed: () {
                        setData();
                        Navigator.pushNamed(context, RefreshScreen.id);
                      },
                      child: const Icon(Icons.refresh, size: 42.0),
                    ),
                  ],
                ),
              ),
              SizedBox(height: deviceheight * 0.05),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Calendar(daylist: _daylist, chooseDay: chooseDay),
              ),
              SizedBox(height: deviceheight * 0.05),
              Expanded(
                child: dailyPills.isEmpty
                    ? const Center(
                        child: Text(
                          "No medicines scheduled for this day.",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                    : MedicineList(
                        listofMedicine: dailyPills,
                        setData: setData,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void chooseDay(CalendarDayModel clickedDay) {
    setState(() {
      _lastchooseday = _daylist.indexOf(clickedDay);
      for (var day in _daylist) {
        day.ischecked = false;
      }
      _daylist[_lastchooseday].ischecked = true;

      dailyPills.clear();
      for (var pill in alllistofPills) {
        DateTime pillDate = DateTime.fromMillisecondsSinceEpoch(pill.time);
        if (clickedDay.daynumber == pillDate.day &&
            clickedDay.monthnumber == pillDate.month &&
            clickedDay.yearnumber == pillDate.year) {
          dailyPills.add(pill);
        }
      }
      dailyPills.sort((pill1, pill2) => pill1.time.compareTo(pill2.time));
    });
  }
}
