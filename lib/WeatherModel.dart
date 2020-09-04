
class WeatherModel
{
  String cityName;
  final temp;
  final pressure;
  final  humidity;
  final temp_max;
  final  temp_min;
  final windSpeed;
  final clouds;

  double get getTemp => temp-272.5;
  double get getMaxTemp => temp_max-272.5;
  double get getMinTemp=> temp_min -272.5;

  WeatherModel(this.cityName,this.temp, this.pressure, this.humidity, this.temp_max, this.temp_min,this.windSpeed,this.clouds);

  factory WeatherModel.fromJson(String city,Map<String,dynamic> json, Map<String,dynamic> windjson, Map<String,dynamic> cloudjson)
  {
    return WeatherModel(
      city,
      json['temp'],
      json['pressure'],
      json["humidity"],
      json["temp_max"],
      json["temp_min"],
      windjson["speed"],
      cloudjson["all"]
    );
  }

}