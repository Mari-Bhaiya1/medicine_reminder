import 'package:flutter/material.dart';
import 'package:medicinereminder/Screens/add_new_medicine/add_new_medicine.dart';
import 'package:medicinereminder/database/respository.dart';
import 'package:medicinereminder/models/pill_type.dart';
import 'package:medicinereminder/notifications/notifications.dart';
import 'package:intl/intl.dart';

class MedicineCard extends StatelessWidget {
  final Pill medicine;
  final Function setData;

  const MedicineCard({super.key, required this.medicine, required this.setData});

  @override
  Widget build(BuildContext context) {
    final bool isTaken = DateTime.now().millisecondsSinceEpoch > medicine.time;
    String description;
    if (medicine.type == 'pills') {
      description = "${medicine.amount} ${medicine.medicineForm}";
    } else {
      description = "${medicine.amount} ${medicine.type} of ${medicine.medicineForm}";
    }

    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 5.0),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNewMedicine(pill: medicine),
            ),
          ).then((_) => setData());
        },
        onLongPress: () => _showLongPressMenu(context),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
          title: Text(
            medicine.name,
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: Colors.black,
                  fontSize: 20.0,
                  decoration: isTaken ? TextDecoration.lineThrough : null,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            description,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Colors.grey[600],
                  fontSize: 15.0,
                  decoration: isTaken ? TextDecoration.lineThrough : null,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateFormat("HH:mm")
                    .format(DateTime.fromMillisecondsSinceEpoch(medicine.time)),
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  decoration: isTaken ? TextDecoration.lineThrough : null,
                ),
              ),
              const SizedBox(height: 4),
              Icon(
                isTaken ? Icons.check_circle : Icons.check_circle_outline,
                color: isTaken ? Theme.of(context).primaryColor : Colors.grey,
              ),
            ],
          ),
          leading: SizedBox(
            width: 60.0,
            height: 60.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  isTaken ? Colors.white : Colors.transparent,
                  BlendMode.saturation,
                ),
                child: Image.asset(medicine.image),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showLongPressMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.arrow_back),
              title: const Text('Back'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete This'),
              onTap: () {
                _showDeleteDialog(context, 'Delete This Reminder?', () async {
                  await Respository().deletePill(medicine.id, medicine.notifyId);
                  setData();
                  Navigator.pop(context); // Close the bottom sheet
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_sweep),
              title: const Text('Delete All'),
              onTap: () {
                _showDeleteDialog(context, 'Delete All Reminders for this Medicine?', () async {
                  await Respository().deleteAllPills(medicine.groupId);
                  setData();
                  Navigator.pop(context);
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, String title, VoidCallback onDelete) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
          TextButton(
            onPressed: () {
              onDelete();
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
