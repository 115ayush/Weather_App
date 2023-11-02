// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/Additional_info_item.dart';
import 'package:weather_app/Hourly_forecast_item.dart';
import 'package:http/http.dart' as http;

//import 'package:weather_app/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String,dynamic>> weather;
  //  double temp=0.0;

@override
  // void initState() {
    
  //   super.initState();
  //   getCurrentWeather();

  // }

Future<Map<String,dynamic>> getCurrentWeather() async{
  try{
  //String cityName = 'London';
      final res = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=London,uk&APPID=bc939bbf8eb08839ab3e09a056e1be0c'));
      final data=jsonDecode(res.body);
      if(data['cod']!='200'){
        throw "an unexpected error occured";

      }
      // setState(() {
      //    temp=data['list'][0]['main']['temp'];
      // });
     return data;
     // print(res);
      
      }

      catch(e){
        throw e.toString();
      }
      //final data =jsonDecode(res.body);
}
@override
void initState() {
    // TODO: implement initState
    super.initState();
    weather=getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(



  appBar: AppBar(
    title: const Text('Weather App',style: TextStyle(
      fontWeight: FontWeight.bold
      )
      ,),
      centerTitle: true,
      actions: [
        IconButton(onPressed:(){
          setState(() {
            weather=getCurrentWeather();
          });

        },icon: const Icon(Icons.refresh))
      ],
  ),


body:  FutureBuilder(
  future: weather,
  builder:(context,snapshot) {
    //print(snapshot);
   if(snapshot.connectionState==ConnectionState.waiting){
    return const Center(child:  CircularProgressIndicator.adaptive());
   }
   if(snapshot.hasError){
    return Center(child: Text(snapshot.hasError.toString()));
   }
   final data=snapshot.data!;
   final currentTemp=data['list'][0]['main']['temp'];
   final currentSky=data['list'][0]['weather'][0]['main'];
   final currentPressure=data['list'][0]['main']['pressure'];
   final currentWind=data['list'][0]['wind']['speed'];
   final currentHumidity=data['list'][0]['main']['humidity'];

    return Padding(
    padding: const EdgeInsets.all(16.0),
    child:   Column(
      children: [
        //main card
        SizedBox(
          width: double.infinity,
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child:ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 10,
                  sigmaY: 10,
                ),
                child:   Padding(
                  padding:   const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text('$currentTemp k',style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        
                      ),),
                      const SizedBox(height: 16,),
                
                      Icon( 
                      currentSky=='Clouds' || currentSky=="Rain" ? Icons.cloud:Icons.sunny,
                      size: 64,),
                     const SizedBox(height: 16,),
                      
                       Text('$currentSky ',style:const  TextStyle(fontSize:20 ),),
                    ]
                    ),
                ),
              ),
            ),
          ),
        ),
    
    
        const SizedBox(height: 20,),
    
     const Align(
        alignment: Alignment.centerLeft,
         child:  Text(
          'Hourly Forecast',
          style: TextStyle(
            fontSize: 24,
             fontWeight: FontWeight.bold,
          ),
         ),
       ),
       const SizedBox(
               height: 10,
              
       ),
      //  SingleChildScrollView(
      //   scrollDirection: Axis.horizontal,
      //    child: Row(
      //           children: [
      //             for(int i=0;i<5;i++)
      //               HourlyForecast(
      //                 icon:data['list'][i+1]['weather'][0]['main']=="Clouds"|| data['list'][i+1]['weather'][0]['main']=='Rain'?Icons.cloud_rounded:Icons.sunny,
      //                 temperature: data['list'][i+1]['main']['temp'].toString(),time: data['list'][i+1]['dt'].toString(),),
                   
      //           ],
      //    ),
      //  ),
        //whether forecast card
       
    SizedBox(
      height: 140,
      child: ListView.builder(
        itemCount: 5,
        scrollDirection: Axis.horizontal,
        itemBuilder:(context,index){
    
    
    
    
           final hourlyForecast=data['list'][index+1];
            final hourlyTemp =hourlyForecast['main']['temp'].toString();
    
           final hourlySky=data['list'][index+1]['weather'][0]['main'];
           final time=DateTime.parse(hourlyForecast['dt_txt']);
          return HourlyForecast(
                         icon:hourlySky=="Clouds"|| hourlySky=='Rain'?Icons.cloud_rounded:Icons.sunny,
                         temperature: hourlyTemp,time: DateFormat.j().format(time),);
    
    
    
    
        },
        ),
    ),
         const SizedBox(height: 20,),
    
    const Align(
        alignment: Alignment.centerLeft,
         child:  Text(
          'Additional Information ',
          style: TextStyle(
            fontSize: 24,
             fontWeight: FontWeight.bold,
          ),
         ),
       ),
       const SizedBox(height: 8,),
        Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
               AdditionalInfoItem(
                icon:Icons.water_drop,
                label:"Humidity",
                value:"$currentHumidity".toString(),
               ),
               AdditionalInfoItem(icon:Icons.air,
                label:"Wind Speed",
                value:'$currentWind'.toString(),),
               AdditionalInfoItem(icon:Icons.beach_access,
                label:"Pressure",
                value:'$currentPressure'.toString(),)
              
            ],
           ),
    
    
        
      ]
      ),
  );
  },
),

    );
  }
}



