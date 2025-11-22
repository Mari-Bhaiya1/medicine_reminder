import 'package:flutter/material.dart';
import 'package:medicinereminder/models/medicine_type.dart';


class MedicineTypeCard extends StatelessWidget {

  final MedicineType pillType;
  final Function handler;

  const MedicineTypeCard({required this.pillType,required this.handler});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: (){
            handler(pillType);
          },
          child: Container(
            width: 100,
            decoration: BoxDecoration(
              color: pillType.isChoose?Color.fromRGBO(7, 190, 200, 1):Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 5.0,),
                Container(width: 50.0,height: 50,child: pillType.image,),
                SizedBox(height: 5.0,),
                Container(child: Text(pillType.name,style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: pillType.isChoose?Colors.white:Colors.black,
                ),),),
              ],
            ),
          ),
        ),
        SizedBox(width: 15),
      ],
    );
  }
}
