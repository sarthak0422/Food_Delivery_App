import 'package:flutter/material.dart';
class MyDescriptionBox extends StatelessWidget {
  const MyDescriptionBox({super.key});

  @override
  Widget build(BuildContext context) {

    //textstyle
    var myPrimaryTextStyle =
    TextStyle(color: Theme.of(context).colorScheme.inversePrimary);
    var mySecodaryTextStyle =
    TextStyle(color: Theme.of(context).colorScheme.primary);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.secondary),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(25),
      margin: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //delivery free
          Column(
            children: [
              Text("800 ₹", style: myPrimaryTextStyle,),
              Text("Delivery Free", style: mySecodaryTextStyle,),
            ],
          ),
          //delivery time
          Column(
            children: [
              Text("30 mins", style: myPrimaryTextStyle,),
              Text("Delivery Time", style: mySecodaryTextStyle,),
            ],
          ),
        ],
      ),
    );
  }
}
