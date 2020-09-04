import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_weather_app/SearchWeather.dart';
import 'WeatherModel.dart';


class Home extends StatefulWidget
{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>
{

  List<WeatherModel> weatherList = [];
  List<String> cities = ['Lahore','Islamabad','Quetta','Peshawar','Karachi','Gwadar','Gilgit'];

  Future<WeatherModel> getWeather(String city) async
  {
    final result = await http.Client().get("https://api.openweathermap.org/data/2.5/weather?q=$city&APPID=43ea6baaad7663dc17637e22ee6f78f2");

    if(result.statusCode != 200)
    {
      throw Exception();
    }

    return parsedJson(result.body,city);
  }

  WeatherModel parsedJson(final response,String cityName)
  {
    final jsonDecoded = json.decode(response);
    final jsonWeather = jsonDecoded["main"];
    final jsonWindSpeed = jsonDecoded["wind"];
    final jsonClouds = jsonDecoded["clouds"];

    return WeatherModel.fromJson(cityName,jsonWeather,jsonWindSpeed,jsonClouds);
  }

  Future<WeatherModel> getCitiesWeather(String cityName) async
  {

    for(var city in cities)
      {
        WeatherModel model = await getWeather(city);

        bool exists = false;

        for(int i=0; i < weatherList.length; i++)
          {
            if(weatherList.contains(model))
              {
                exists = true;
              }
          }


        if(exists == false)
          {
            print('Hash Code of Object --- >' + model.hashCode.toString());
            weatherList.add(model);
            print('Total Cities : '+weatherList.length.toString());
          }
        else
          {
            print('Already Exists');
          }
      }

  }


  @override
  Widget build(BuildContext context)
  {
    return Scaffold(

      appBar: AppBar(
        title: Text('Pakistan Weather',style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        child: Icon(Icons.search),
        onPressed: ()
        {
          Navigator.push(context, MaterialPageRoute(builder: (_) => SearchPage()));
        },
      ),

      body: FutureBuilder(
        future: getCitiesWeather('Lahore'),
        builder: (context,snapshot)
        {
          if(snapshot.connectionState == ConnectionState.waiting)
            {
              return Center(child: CircularProgressIndicator());
            }
             return ListView.builder(
               itemBuilder: (context,index)
               {
                 return Container(
                  padding: EdgeInsets.only(top: 10,left: 10,right: 10),
                  child: Container(
                   padding: EdgeInsets.only(left: 22,right: 22,top: 10,bottom: 10),
                   decoration: BoxDecoration(
                     color: Colors.indigo,
                     borderRadius: BorderRadius.all(Radius.circular(15))
                   ),
                    child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: <Widget>[

                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            Text(weatherList[index].cityName,
                              style: TextStyle(fontSize: 20,color: Colors.cyanAccent,fontWeight: FontWeight.bold),),

                            SizedBox(height: 8,),

                            Row(
                              children: <Widget>[

                                Image.asset('assets/temp.png',width: 24,height: 19,color: Colors.yellowAccent,fit: BoxFit.fill,),

                                Text(weatherList[index].getTemp.round().toString()+' C',
                                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.yellowAccent,fontSize: 18),),
                              ],
                            )

                          ],
                        ),
                      ),

                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.only(left: 13),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              Row(
                                children: <Widget>[

                                  Image.asset('assets/raining.png',width: 20,height: 20,color: Colors.yellowAccent,fit: BoxFit.fill,),
                                  SizedBox(width: 10,),
                                  Text(weatherList[index].humidity.toString()+' F',
                                    style: TextStyle(fontSize: 16,color: Colors.tealAccent,fontWeight: FontWeight.bold),),
                                ],
                              ),

                              SizedBox(height: 8,),

                              Row(
                                children: <Widget>[

                                  Image.asset('assets/pressure.png',width: 20,height: 20,color: Colors.yellowAccent,fit: BoxFit.fill,),
                                  SizedBox(width: 10,),
                                  Text(weatherList[index].pressure.toString()+' P',
                                    style: TextStyle(fontSize: 16,color: Colors.tealAccent,fontWeight: FontWeight.bold),),
                                ],
                              ),

                            ],
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.only(left: 17),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>
                            [

                              Row(
                                children: <Widget>[

                                  Image.asset('assets/cloud.png',width: 23,height: 18,color: Colors.yellowAccent,fit: BoxFit.fill,),

                                  SizedBox(width: 10,),

                                  Text(weatherList[index].clouds.round().toString()+' %',
                                    style: TextStyle(fontSize: 16,color: Colors.yellowAccent,fontWeight: FontWeight.bold),),
                                ],
                              ),

                              SizedBox(height: 5,),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[

                                  Image.asset('assets/wind.png',width: 18,height: 18,color: Colors.yellowAccent,fit: BoxFit.fill,),

                                  SizedBox(width: 15,),

                                  Text(weatherList[index].windSpeed.round().toString()+' km/h',
                                    style: TextStyle(fontSize:16,color: Colors.yellowAccent,fontWeight: FontWeight.bold),),
                                ],
                              )

                            ],
                          ),
                        ),
                      ),

                    ],
                   ),
                  ),
                 );
               },
               itemCount: weatherList.length,
             );
        },

      ),

    );
  }
}
