import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicinereminder/Screens/add_new_medicine/form_field.dart';
import 'package:medicinereminder/Screens/add_new_medicine/medicine_type_card.dart';
import 'package:medicinereminder/database/respository.dart';
import 'package:medicinereminder/helper/platform_button.dart';
import 'package:medicinereminder/models/medicine_type.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../helper/snack_bar.dart';
import '../../models/pill_type.dart';
import '../../notifications/notifications.dart';

class AddNewMedicine extends StatefulWidget {
  static String id = 'Add_New_Screen';
  final Pill? pill;

  const AddNewMedicine({super.key, this.pill});

  @override
  State<AddNewMedicine> createState() => _AddNewMedicineState();
}

class _AddNewMedicineState extends State<AddNewMedicine> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final Snackbar snackbar = Snackbar();

  final List<MedicineType> medicineTypes = [
    MedicineType("Syrup", Image.asset("assets/images/syrup.png"), false),
    MedicineType("Pill", Image.asset("assets/images/pills.png"), false),
    MedicineType("Capsule", Image.asset("assets/images/capsule.png"), false),
    MedicineType("Cream", Image.asset("assets/images/cream.png"), false),
    MedicineType("Drops", Image.asset("assets/images/drops.png"), false),
    MedicineType("Syringe", Image.asset("assets/images/syringe.png"), false),
  ];

  final List<String> weightValues = ["pills", "ml", "mg"];
  int howManyDays = 1;
  String selectedWeight = "pills";
  DateTime setDate = DateTime.now();

  final Respository _repository = Respository();
  final Notifications _notifications = Notifications();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  bool get isEditMode => widget.pill != null;

  @override
  void initState() {
    super.initState();
    selectedWeight = weightValues[0];

    if (isEditMode) {
      final pill = widget.pill!;
      nameController.text = pill.name;
      amountController.text = pill.amount;
      howManyDays = pill.howManyDays;
      selectedWeight = pill.type;
      setDate = DateTime.fromMillisecondsSinceEpoch(pill.time);
      for (var type in medicineTypes) {
        type.isChoose = (type.name == pill.medicineForm);
      }
    } else {
      medicineTypes.first.isChoose = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(248, 248, 248, 1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 30,
            bottom: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: deviceHeight * 0.05,
                    child: FittedBox(
                      child: InkWell(
                        onTap: () => Navigator.pop(context, false),
                        child: const Icon(Icons.arrow_back),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 50.0,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 15.0),
                    height: deviceHeight * 0.05,
                    child: FittedBox(
                      child: Text(
                        isEditMode ? 'Edit Pills' : 'Add Pills',
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: deviceHeight * 0.03),
              SizedBox(
                height: deviceHeight * 0.40,
                child: FormFieldforaddingmedicine(
                  nameController: nameController,
                  ammountController: amountController,
                  howmanydays: howManyDays,
                  onPopupMenuChange: popUpMenuItemChanged,
                  onSliderChange: sliderChanged,
                  selectedValue: selectedWeight,
                ),
              ),
              Container(
                height: deviceHeight * 0.035,
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  'Medicine Form',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              SizedBox(height: deviceHeight * 0.02),
              SizedBox(
                height: 100,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: medicineTypes
                      .map(
                        (type) => MedicineTypeCard(
                          pillType: type,
                          handler: medicineTypeClick,
                        ),
                      )
                      .toList(),
                ),
              ),
              SizedBox(height: deviceHeight * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: PlatformButton(
                      color: const Color.fromRGBO(7, 190, 200, 0.1),
                      ButtonChild: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat.Hm().format(setDate),
                            style: const TextStyle(
                              fontSize: 32.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.access_time,
                            size: 30,
                            color: Colors.teal,
                          ),
                        ],
                      ),
                      handle: openTimePicker,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: PlatformButton(
                      handle: openDatePicker,
                      color: const Color.fromRGBO(7, 190, 200, 0.1),
                      ButtonChild: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('dd.MM').format(setDate),
                            style: const TextStyle(
                              fontSize: 32.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.event,
                            size: 30,
                            color: Colors.teal,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: deviceHeight * 0.03),
              SizedBox(
                height: deviceHeight * 0.09,
                width: double.infinity,
                child: PlatformButton(
                  handle: () {
                    isEditMode ? handleUpdate() : handleSave();
                  },
                  color: Theme.of(context).primaryColor,
                  ButtonChild: Text(
                    isEditMode ? 'Update' : 'Done',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 17.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sliderChanged(double value) {
    setState(() => howManyDays = value.round());
  }

  void popUpMenuItemChanged(String? value) {
    if (value != null) {
      setState(() => selectedWeight = value);
    }
  }

  void medicineTypeClick(MedicineType medicine) {
    setState(() {
      for (var m in medicineTypes) {
        m.isChoose = false;
      }
      medicine.isChoose = true;
    });
  }

  Future<void> openTimePicker() async {
    final value = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(setDate),
    );
    if (value != null) {
      setState(() {
        setDate = DateTime(
          setDate.year,
          setDate.month,
          setDate.day,
          value.hour,
          value.minute,
        );
      });
    }
  }

  Future<void> openDatePicker() async {
    final value = await showDatePicker(
      context: context,
      initialDate: setDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (value != null) {
      setState(() {
        setDate = DateTime(
          value.year,
          value.month,
          value.day,
          setDate.hour,
          setDate.minute,
        );
      });
    }
  }

  Future<void> handleUpdate() async {
    final pillToUpdate = widget.pill!;
    
    Pill updatedPill = Pill(
      id: pillToUpdate.id,
      amount: amountController.text,
      howManyDays: pillToUpdate.howManyDays,
      medicineForm: medicineTypes.firstWhere((e) => e.isChoose).name,
      name: nameController.text,
      time: setDate.millisecondsSinceEpoch,
      type: selectedWeight,
      notifyId: pillToUpdate.notifyId,
      groupId: pillToUpdate.groupId,
    );

    await _repository.updateData("Pills", updatedPill.toMap());

    await _notifications.cancelNotification(pillToUpdate.notifyId);
    String description = "${updatedPill.amount} ${updatedPill.type} of ${updatedPill.medicineForm}";
    await _notifications.showNotification(updatedPill.name, description, updatedPill.time, updatedPill.notifyId);

    snackbar.showSnack("Updated successfully", context, null);
    Navigator.pop(context, true);
  }

  Future<void> handleSave() async {
    final BuildContext? scaffoldContext = _scaffoldKey.currentContext;
    if (scaffoldContext == null) return;

    if (setDate.isBefore(DateTime.now())) {
      setDate = setDate.add(const Duration(days: 1));
    }

    String selectedMedicineForm =
        medicineTypes.firstWhere((element) => element.isChoose).name;
    final groupId = DateTime.now().millisecondsSinceEpoch;

    for (int i = 0; i < howManyDays; i++) {
      DateTime notificationDate = setDate.add(Duration(days: i));
      int pillId = DateTime.now().millisecondsSinceEpoch + i;
      int notifyId = Random().nextInt(10000000);

      Pill pill = Pill(
        id: pillId,
        amount: amountController.text,
        howManyDays: howManyDays,
        medicineForm: selectedMedicineForm,
        name: nameController.text,
        time: notificationDate.millisecondsSinceEpoch,
        type: selectedWeight,
        notifyId: notifyId,
        groupId: groupId,
      );

      Map<String, dynamic> pillMap = pill.toMap();

      dynamic result = await _repository.insertData("Pills", pillMap);
      if (result == null) {
        snackbar.showSnack("Something went wrong", scaffoldContext, null);
        return;
      }

      String description;
      if (pill.type == 'pills') {
        description = "${pill.amount} ${pill.medicineForm}";
      } else {
        description = "${pill.amount} ${pill.type} of ${pill.medicineForm}";
      }

      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Asia/Karachi'));

      await _notifications.showNotification(
        pill.name,
        description,
        pill.time,
        notifyId,
      );
    }

    snackbar.showSnack("Saved successfully", scaffoldContext, null);
    Navigator.pop(scaffoldContext, true);
  }
}
