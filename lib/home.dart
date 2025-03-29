import 'package:ai_powered_skin_disease_detection_application/screens/camera.dart';
import 'package:ai_powered_skin_disease_detection_application/screens/homepage.dart';
import 'package:ai_powered_skin_disease_detection_application/shared/components/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class home extends StatefulWidget {
  @override
  final int initialIndex;
  State<home> createState() => _homeState(index: initialIndex);
  home({this.initialIndex = 0});
}

class _homeState extends State<home> {
  int index;
  _homeState({this.index = 0});
  List<Widget>screens=
  [
    homepage(),
    CameraScreen(),
  ];
  @override

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        if(index==0) {
          setState(() {
            SystemNavigator.pop();
          });

        }
        else{
          setState(() {
            navigateTo(context, home(initialIndex: 0,));
          });

        }
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              index=value;
            });
          },
          items:
          [
            BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home page'),
            BottomNavigationBarItem(icon: Icon(Icons.camera),label: 'Camera'),
          ],
          selectedItemColor: Colors.blue,
          currentIndex: index,
          type: BottomNavigationBarType.fixed,

        ),
        body: screens[index],
      ),
    );
  }
}
