import 'dart:ffi';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:weather/Screens/Weather.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  Map<String, dynamic> data = {};
  String bg = '';
  String loading='false';
  String icon='';
  String desc='';
  String temp='';

  @override
  void initState() {
    // TODO: implement initState
   fetchData();
    super.initState();
  }
  Future<void> fetchData() async {
    try {
      setState(() {
        this.loading='true';
      });
      final fetchedData = await getWeather(); // Replace with your getWeather() function

      if (fetchedData != null) {
        setState(() {
          loading='false';
          data = fetchedData;
          desc=data['weather'][0]['description'];
          temp=(data['main']['temp']- 273.15).toStringAsFixed(2);
          icon=getIcon();
          print(data['weather'][0]['main']);
          if (data['weather'][0]['main'] == "Clear") {
            this.bg = "clearsky.jpg";
          }else if (data['weather'][0]['main'] == "Clouds") {
            this.bg = "cloudy.jpg";
          }else if (data['weather'][0]['main'] == "Rain") {
            this.bg = "rain.jpg";
          }else if (data['weather'][0]['main'] == "Atmosphere") {
            this.bg = "atmosphere.jpg";
          }else if (data['weather'][0]['main'] == "Thunderstorm") {
            this.bg = "thundersttorm.jpg";
          }
        });
      }
    } catch (e) {
      print('Error fetching weather data: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      loading=='true'? Center(child:

      Container(
          height: 200,
          child: Lottie.asset('assets/Animation/loading.json')),)
          :
      SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/$bg') ,// Replace with your image path
              fit: BoxFit.cover, // Adjust this property as needed
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 50,right: 50,top: 50,bottom: 20),
                child:

               Lottie.asset('assets/Animation/$icon',height: 200,fit:BoxFit.fill,repeat: false )


              ),
              Container(

                    child: Column(
                      children: [
                        Container(
                          padding:EdgeInsets.only(bottom:5),
                          child: Text(desc,style: GoogleFonts.outfit(
                          fontSize: 30,color: Colors.white
                          ),),
                        ),
                        Text('$temp °C',style: GoogleFonts.outfit(
                            fontSize: 40,color: Colors.white
                        ),),
                      ],
                    )

                ,),


              SizedBox(
                height: 400,
              ),
              GestureDetector(
                  onTap: (){
                    print(bg);
                  },
                  child: Divider()),

            ],
          ),
        ),
      ),
    );
  }

  String getIcon() {
    if (data['weather'][0]['main'] == "Clear") {
      return 'sun_anim.json';
    }else if (data['weather'][0]['main'] == "Clouds") {
      return 'cloud_anim.json';
    }else if (data['weather'][0]['main'] == "Rain") {
      return 'rain_anim.json';
    }else if (data['weather'][0]['main'] == "Atmosphere") {
      return 'sun_anim.json';
    }else if (data['weather'][0]['main'] == "Thunderstorm") {
      return 'thunder_anim.json';
    }
    else
      return 'sun_anim.json';
  }
}
