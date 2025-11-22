import 'package:flutter/material.dart';
import 'package:medicinereminder/models/pill_type.dart';
import 'medicine_card.dart';

class MedicineList extends StatelessWidget {
  final List<Pill> listofMedicine;
  final Function setData;

  const MedicineList({
    required this.listofMedicine,
    required this.setData,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => MedicineCard(
        medicine: listofMedicine[index],
        setData: setData,
      ),
      itemCount: listofMedicine.length,
      // shrinkWrap: true,
      // physics: const NeverScrollableScrollPhysics(),
    );
  }
}
