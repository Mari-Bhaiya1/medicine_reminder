class Pill {
  final int id;
  final String name;
  final String amount;
  final String type;
  final int howManyDays;
  final String medicineForm;
  final int time;
  final int notifyId;
  final int groupId;

  Pill({
    required this.id,
    required this.howManyDays,
    required this.time,
    required this.amount,
    required this.medicineForm,
    required this.name,
    required this.type,
    required this.notifyId,
    required this.groupId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'type': type,
      'howManyDays': howManyDays,
      'medicineForm': medicineForm,
      'time': time,
      'notifyId': notifyId,
      'groupId': groupId,
    };
  }

  factory Pill.fromMap(Map<String, dynamic> pillMap) {
    return Pill(
      id: pillMap['id'] ?? 0,
      name: pillMap['name'] ?? '',
      amount: pillMap['amount'] ?? '',
      type: pillMap['type'] ?? '',
      howManyDays: pillMap['howManyDays'] ?? 0,
      medicineForm: pillMap['medicineForm'] ?? '',
      time: pillMap['time'] ?? 0,
      notifyId: pillMap['notifyId'] ?? 0,
      groupId: pillMap['groupId'] ?? 0,
    );
  }

  String get image {
    switch (medicineForm) {
      case "Syrup":
        return "assets/images/syrup.png";
      case "Pill":
        return "assets/images/pills.png";
      case "Capsule":
        return "assets/images/capsule.png";
      case "Cream":
        return "assets/images/cream.png";
      case "Drops":
        return "assets/images/drops.png";
      case "Syringe":
        return "assets/images/syringe.png";
      default:
        return "assets/images/pills.png";
    }
  }
}
