import 'package:flutter/material.dart';
import 'package:my_weather_app/home.dart';


void main()=>runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  title: 'Weather App',
  home: Home(),
  theme: ThemeData(
    primaryColor: Colors.indigo
  ),
));