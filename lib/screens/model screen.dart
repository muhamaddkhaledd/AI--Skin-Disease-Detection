import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModelScreen extends StatelessWidget {
  final String imagePath;

  ModelScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
          padding: EdgeInsetsDirectional.only(top: 30),
          child: Align(
            alignment: Alignment.topRight,
            child: MaterialButton(
              shape: CircleBorder(),
              color: Color.fromRGBO(169, 169, 167, 0.1),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.clear, color: Colors.grey),
            ),
          ),
        ),
          Container(
            width: 300,
            height: 300,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.file(
                File(imagePath),
                fit: BoxFit.none,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15)),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Clear Image',
                        style: TextStyle(color: Colors.black, fontSize: 25),
                      ),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Colors.green,
                        onPressed: () {
                          // Process image here
                        },
                        child: Text('Process To Model'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}