
import 'package:flutter/material.dart';
import 'package:medicinereminder/Screens/add_new_medicine/slider.dart';

class FormFieldforaddingmedicine extends StatelessWidget {
  final List<String> weightValues = ["pills", "ml", "mg"];
  final TextEditingController nameController, ammountController;
  final int howmanydays;
  final Function onPopupMenuChange;
  final ValueChanged<double> onSliderChange;
  final String selectedValue;

  FormFieldforaddingmedicine({
    required this.nameController,
    required this.ammountController,
    required this.howmanydays,
    required this.onPopupMenuChange,
    required this.onSliderChange,
    required this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    final focus = FocusScope.of(context);
    return LayoutBuilder(
      builder:
          (context, constrains) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Container(
                height: constrains.maxHeight * 0.22,
                child: TextField(
                  textInputAction: TextInputAction.next,
                  controller: nameController,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 20.0,
                    ),
                    labelText: "Pill Name",

                    labelStyle: TextStyle(
                      color: Colors.grey[600],
                    ),

                    floatingLabelStyle: TextStyle(
                      color: Color.fromRGBO(7, 190, 200, 1),
                      fontWeight: FontWeight.w600,
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        width: 0.5,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    focusedBorder:
                    OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        width: 1.5,
                        color: Color.fromRGBO(7, 190, 200, 1),
                      ),
                    ),

                  ),
                  onSubmitted: (val) => focus.nextFocus(),
                ),
              ),
              SizedBox(height: constrains.maxHeight * 0.07),
              Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: Container(
                      height: constrains.maxHeight * 0.22,
                      child: TextField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        controller: ammountController,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 15.0,
                            vertical: 20.0,
                          ),
                          labelText: "Pill Amount",

                          labelStyle: TextStyle(
                            color: Colors.grey[600],
                          ),

                          floatingLabelStyle: TextStyle(
                            color: Color.fromRGBO(7, 190, 200, 1),
                            fontWeight: FontWeight.w600,
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              width: 0.5,
                              color: Colors.grey.shade600,
                            ),
                          ),

                          focusedBorder:
                          OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              width: 1.5,
                              color: Color.fromRGBO(7, 190, 200, 1),
                            ),
                          ),

                        ),



                        onSubmitted: (val) => focus.nextFocus(),
                      ),
                    ),
                  ),

                  SizedBox(width: 10),

                  Flexible(
                    flex: 1,
                    child: Container(
                      height: constrains.maxHeight * 0.22,
                      child: DropdownButtonFormField<String>(
                        onTap: focus.unfocus,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 15.0,
                            vertical: 20.0,
                          ),
                          labelText: "Type",

                          labelStyle: TextStyle(
                            color: Colors.grey[600],
                          ),

                          floatingLabelStyle: TextStyle(
                            color: Color.fromRGBO(7, 190, 200, 1),
                            fontWeight: FontWeight.w600,
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              width: 0.5,
                              color: Colors.grey.shade600,
                            ),
                          ),

                          focusedBorder:
                          OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              width: 1.5,
                              color: Color.fromRGBO(7, 190, 200, 1),
                            ),
                          ),

                        ),
                        items:
                            weightValues.map((weight) {
                              return DropdownMenuItem<String>(
                                value: weight,
                                child: Text(weight),
                              );
                            }).toList(),
                        onChanged: (value) => this.onPopupMenuChange(value),
                        value: selectedValue,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: constrains.maxHeight * 0.1),
              Container(
                height: constrains.maxHeight * 0.1,
                child: FittedBox(
                  child: Text(
                    'How Long',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Container(
                  height: constrains.maxHeight * 0.18,
                  child: UserSlider(
                    handler: this.onSliderChange,
                    howmanydays: howmanydays,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FittedBox(child: Text('$howmanydays Days')),
              ),
            ],
          ),
    );
  }
}
