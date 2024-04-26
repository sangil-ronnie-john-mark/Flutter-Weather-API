import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Homepage(),));
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Map<String,dynamic> weatherData = {};
  double kelvin = 273.15;

  // data to be print
  String? status;
  String? feels;
  String? temp;
  String? humidity;
  String? country;
  String? name;
  TextEditingController _location = TextEditingController();
  Future<void> getData(String city) async {
    String  uri = "https://api.openweathermap.org/data/2.5/weather?q="+ city +"&appid=7437153e4bf6ba0c4781b64f27f225a6";
      try {
        final response = await http.get(Uri.parse(uri));
        print(response.body);
        setState(() {
          weatherData = jsonDecode(response.body);

          if (weatherData["cod"] == 200) {
            status = weatherData["weather"][0]["main"];
            feels = (weatherData["main"]["feels_like"] - kelvin).toStringAsFixed(1);
            temp = (weatherData["main"]["temp"] - kelvin).toStringAsFixed(1);
            humidity = weatherData["main"]["humidity"].toString();
            country = weatherData["sys"]["country"];
            name = weatherData["name"];
          } else {
            showDialog(context: context, builder: (context){
              return AlertDialog(
                title: Text("Error"),
                content: Text("Invalid City"),
              );
            });
          }

        });
      } catch (e) {
        showDialog(context: context, builder: (context){
          return AlertDialog(
            title: Text("Error"),
            content: Text("Connection Error"),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
                getData(_location.text);
              }, child: Text("Retry"))
            ],
          );
        });
      }

  }

  @override
  void initState() {
    getData("Arayat");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Weather App"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: _location,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Location',
                  suffixIcon: IconButton(onPressed: (){
                    getData(_location.text);
                  }, icon: Icon(Icons.search_outlined))
                ),
              ),
                Text("$temp °C", style:  TextStyle( fontSize: 70),),
                Text("$name", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              Text("☁️", style: TextStyle(fontSize: 100),),
              Container(

                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Feels Like: $feels°C"),
                        Text("Humidity: $humidity%"),
                      ],

                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Country: $country"),
                        Text("Status: $status"),
                      ],

                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
