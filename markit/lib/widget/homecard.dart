import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  Color color;
  IconData icon;
  String name;
  HomeCard({Key? key,required this.name,required this.icon,required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: size.height*0.15,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
        ),
        Container(
          width: size.width*0.80,
          height: size.height*0.15,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0xfffdfdfd)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width*0.04),
            child: Row(children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: color
                ),
                child: Center(
                  child: Icon(icon,color: Colors.white,),
                ),
              ),
              SizedBox(width: size.width*0.1,),
              Text(
                name,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )
            ],),
          ),
        )
      ],
    );
  }
}
