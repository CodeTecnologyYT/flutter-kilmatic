import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import "../util/utils.dart" as util;

class Kilmatic extends StatefulWidget {
  @override
  _KilmaticState createState() => new _KilmaticState();
}

class _KilmaticState extends State<Kilmatic> {

  String _cityEntered;

  Future _goToNextScreen(BuildContext context) async{
    Map results= await Navigator.of(context).push(
      new MaterialPageRoute<Map>(builder: (BuildContext context){
         return new ChangeCity();
      })
    );
    if(results != null && results.containsKey('enter')){
      _cityEntered= results['enter'];
    }
  }

  void showStuff() async{
    Map data=await getWeather(util.appId, util.defaultCity);
    print(data.toString());
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Kilmatic"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
              new IconButton(
                  icon: new Icon(Icons.menu),
                  onPressed:(){_goToNextScreen(context);} )
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset('images/umbrella.png',
            width: 490.0,
            height: 1200.0,
            fit: BoxFit.fill,),

          ),
          new Container(
            alignment: Alignment.topRight,
            margin:  const EdgeInsets.fromLTRB(0.0,10.9, 20.9, 0.0),
            child: new Text('${_cityEntered==null ? util.defaultCity : _cityEntered}',
            style: cityStyle(),),
          ),
          new Container(
            alignment: Alignment.center,
            child:  new Image.asset("images/light_rain.png"),
          ),
          updateTempWidget(_cityEntered)

        ],
      )
    );
  }
  Future<Map> getWeather(String appId, String city)async{
    String apiUrl='http://samples.openweathermap.org/data/2.5/weather?q=$city&appid=${util.appId}';
    print(apiUrl);
    http.Response response= await http.get(apiUrl);
    return JSON.decode(response.body);
  }
  Widget updateTempWidget(String city){
    return new FutureBuilder(
        future: getWeather(util.appId, city == null ? util.defaultCity : city ),
        builder: (BuildContext context,AsyncSnapshot<Map> snapshot){
            if(snapshot.hasData){
              Map content = snapshot.data;
              return new Container(
                margin: const EdgeInsets.fromLTRB(30.0, 250.0, 0.0, 0.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new ListTile(
                      title: new Text(content['main']['temp'].toString()+" F",
                      style: new TextStyle(
                        fontSize: 49.9,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        color: Colors.white
                      ),),
                      subtitle: new ListTile(
                        title: new Text(
                          "Humidity: ${content['main']['humidity'].toString()}\n"
                              "Min ${content['main']['temp_min'].toString()}\n"
                              "${content['main']['temp_max'].toString()}",
                          style: extraData(),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }else{
              return new Container();
            }
        });
  }
}

class ChangeCity extends StatelessWidget {
  var _cityFieldController= new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.red,
        title: new Text('Change City'),
        centerTitle: true,
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset("images/white_snow.png",
              width: 490.0 ,
              height: 1200.0,
              fit: BoxFit.fill,),
          ),
          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  decoration: new InputDecoration(
                    hintText: 'Enter City'
                  ),
                  controller: _cityFieldController,
                  keyboardType:  TextInputType.text,
                ),
              ),
              new ListTile(
                title: new FlatButton(
                    onPressed: (){
                      Navigator.pop(context,{
                        'enter': _cityFieldController.text
                      });
                    },
                    textColor: Colors.white70,
                    color: Colors.red,
                    child: new Text("Get Weather")),
              )
            ],
          )
        ],
      ),
    );
  }
}


TextStyle tempStyle(){
  return new TextStyle(
      color: Colors.white,
      fontSize: 49.9,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500
  );
}

TextStyle extraData(){
  return new TextStyle(
      color: Colors.white70,
      fontSize: 17.0,
      fontStyle: FontStyle.normal
  );
}

TextStyle cityStyle(){
  return new TextStyle(
    color: Colors.white,
    fontSize: 22.0,
    fontStyle: FontStyle.italic
  );
}