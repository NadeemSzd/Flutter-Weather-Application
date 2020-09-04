import 'dart:convert';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'WeatherModel.dart';


class SearchPage extends StatefulWidget
{

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
{

  final key = GlobalKey<FormState>();

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

  WeatherModel model;

  Future<WeatherModel> searchWeather(String cityName) async
  {
    WeatherModel weatherModel = await getWeather(cityName);
    setState(()
    {
      model = weatherModel;
    });
  }

  @override
  Widget build(BuildContext context)
  {

    var cityController = TextEditingController();


    return Scaffold(

      appBar: AppBar(
        title: Text('Search City',style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>
          [

            Center(
                child: Container(
                  child: FlareActor("assets/WorldSpin.flr", fit: BoxFit.contain, animation: "roll",),
                  height: 300,
                  width: 300,
                )
            ),

            Container(
              padding: EdgeInsets.only(left: 15, right: 15,),
              child: Form(
                key: key,
                child: Column(
                  children: <Widget>[

                    Text("Search Weather", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500, color: Colors.pinkAccent),),
                    Text("Instanly", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w200, color: Colors.pinkAccent),),

                    SizedBox(height: 24,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[

                        Expanded(
                          child: TextFormField(
                            style: TextStyle(color: Colors.white,fontSize: 17,decoration: TextDecoration.none),
                            controller: cityController,
                            validator: (value)
                            {
                              return value.isEmpty ? 'Enter city name... !' : null;
                            },
                            decoration: InputDecoration(
                                fillColor: Colors.black12,
                                filled: true,
                                hintText: 'Search City',
                                hintStyle: TextStyle(color: Colors.black),
                                contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 18),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: BorderSide(color: Colors.pink,width: 1)
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7),
                                )
                            ),
                            autofocus: false,
                          ),
                        ),

                        SizedBox(width: 5,),

                        Container(
                          height: 55,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(width: 0.8,color: Colors.black)
                          ),
                          child: IconButton(icon: Icon(Icons.search,size: 30,color: Colors.black,),
                            onPressed: ()
                            {
                              if(cityController.text.isNotEmpty)
                              {
                                searchWeather(cityController.text);
                              }
                            },
                          ),
                        )
                      ],
                    ),

                  ],
                ),
              ),
            ),

            model == null
            ? Container(height: 200,margin: EdgeInsets.only(left: 15,right: 15,top: 10),
                 decoration: BoxDecoration(
                   color: Colors.indigo,
                   borderRadius: BorderRadius.all(Radius.circular(10)),
                 ),child: Text('No City Search',style: TextStyle(color: Colors.white70)), alignment: Alignment.center,)
            : Container(
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              height: 200,
              margin: EdgeInsets.only(left: 15,right: 15,top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>
                [

                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>
                      [
                        Text(model.cityName,style: TextStyle(color: Colors.cyanAccent,fontSize: 35,fontWeight: FontWeight.bold),),
                        Row(
                          children: <Widget>
                          [
                            Image.asset('assets/temp.png',width: 28,height: 25,color: Colors.yellowAccent,fit: BoxFit.fill,),

                            Text(model.getTemp.round().toString()+' C',style: TextStyle(color: Colors.yellowAccent,fontSize: 30,fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ],
                    ),
                    padding: EdgeInsets.only(top: 20,left: 20,right: 20),
                  ),

                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>
                      [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>
                              [
                                Image.asset('assets/pressure.png',width: 26,height: 26,color: Colors.yellowAccent,fit: BoxFit.fill,),
                                SizedBox(width: 10,),
                                Text(model.pressure.toString()+' P',style: TextStyle(color: Colors.cyanAccent,fontSize: 20,fontWeight: FontWeight.bold),),
                              ],
                            ),

                            SizedBox(height: 10,),

                            Row(
                              children: <Widget>
                              [
                                Image.asset('assets/raining.png',width: 26,height: 26,color: Colors.yellowAccent,fit: BoxFit.fill,),
                                SizedBox(width: 15,),
                                Text(model.humidity.toString()+' F',style: TextStyle(color: Colors.cyanAccent,fontSize: 20,fontWeight: FontWeight.bold),),
                              ],
                            ),
                          ],
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>
                              [
                                Image.asset('assets/cloud.png',width: 28,height: 22,color: Colors.yellowAccent,fit: BoxFit.fill,),
                                SizedBox(width: 12,),
                                Text( model.clouds.round().toString()+' %',style: TextStyle(color: Colors.yellowAccent,fontSize: 20,fontWeight: FontWeight.bold),),
                              ],
                            ),

                            SizedBox(height: 10,),

                            Row(
                              children: <Widget>
                              [
                                Image.asset('assets/wind.png',width: 28,height: 22,color: Colors.yellowAccent,fit: BoxFit.fill,),
                                SizedBox(width: 12,),
                                Text(model.windSpeed.round().toString()+' km/h',style: TextStyle(color: Colors.yellowAccent,fontSize: 20,fontWeight: FontWeight.bold),),
                              ],
                            ),
                          ],
                        ),

                      ],
                    ),
                    padding: EdgeInsets.only(bottom: 30,left: 20,right: 20),
                  ),

                ],
              ),
            ),

          ],
        ),
      ),

    );

  }
}

/*class ShowWeather extends StatelessWidget
{
  WeatherModel weather;
  final city;

  ShowWeather(this.weather, this.city);

  @override
  Widget build(BuildContext context)
  {
    return Container(
        padding: EdgeInsets.only(right: 32, left: 32, top: 10),
        child: Column(
          children: <Widget>[
            Text(city,style: TextStyle(color: Colors.white70, fontSize: 30, fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),

            Text(weather.getTemp.round().toString()+"C",style: TextStyle(color: Colors.white70, fontSize: 50),),
            Text("Temprature",style: TextStyle(color: Colors.white70, fontSize: 14),),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(weather.getMinTemp.round().toString()+"C",style: TextStyle(color: Colors.white70, fontSize: 30),),
                    Text("Min Temprature",style: TextStyle(color: Colors.white70, fontSize: 14),),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(weather.getMaxTemp.round().toString()+"C",style: TextStyle(color: Colors.white70, fontSize: 30),),
                    Text("Max Temprature",style: TextStyle(color: Colors.white70, fontSize: 14),),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),

            Container(
              width: double.infinity,
              height: 50,
              child: FlatButton(
                shape: new RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                onPressed: ()
                {

                },
                color: Colors.lightBlue,
                child: Text("Search", style: TextStyle(color: Colors.white70, fontSize: 16),),

              ),
            )
          ],
        )
    );
  }
}*/