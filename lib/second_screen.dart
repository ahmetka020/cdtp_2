import 'dart:async';
import 'dart:convert';
import 'package:cdtp_client/SeraModel.dart';
import 'package:cdtp_client/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'ConnectionModel.dart';



Future<SeraModel> postSeraModel(SeraModel _seraModel, ConnectionModel connectionModel) async {
  print("post -> ${connectionModel.address}${connectionModel.port}setTemperature");
  final http.Response response = await http.post(
    connectionModel.address + connectionModel.port + "setTemperature",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'seraId' : _seraModel.seraId,
      'temperature': _seraModel.temperature,
    }),
  );
  if (response.statusCode <= 400) {
    Map<String, dynamic> result = jsonDecode(response.body);
    var sera = SeraModel();
    sera.result = result["message"].toString();
    return sera;
  } else {
    print(response.statusCode.toString());
    throw Exception('Failed.');
  }

}

Future<SeraModel> getTemperature(String seraId,ConnectionModel connectionModel) async {
  String lastAddress = connectionModel.address + connectionModel.port + "getTemperature?seraId=" + seraId;
  print('get -> $lastAddress');
  final response = await http.get(lastAddress);
  if (response.statusCode == 200) {
    Map<String, dynamic> result = jsonDecode(response.body);
    var sera = SeraModel();
    var str = result["message"].toString().split('.')[0];
    sera.result = str;
    return sera;
  } else {
    print(response.statusCode.toString());
    throw Exception('Failed to get temperature.');
  }
}



class MyAppSecondPage extends StatefulWidget {
  final ConnectionModel connectionModel;
  MyAppSecondPage({Key key, this.connectionModel}) : super(key: key);
  @override
  _MyAppState createState() {
    return _MyAppState(connectionModel);
  }
}

class _MyAppState extends State<MyAppSecondPage> {
  final ConnectionModel connectionModel;
  final TextEditingController _controller = TextEditingController();
  Future<SeraModel> _futureSeraModel;

  _MyAppState(this.connectionModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child:      Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Connection Address : ${connectionModel.address}"),
              Container(height: 5,),
              Text("Port : ${connectionModel.port}"),
              Container(height: 5,),
              Text("Sera ID : ${connectionModel.SERA_ID}"),

              Container(height: 15,),
              Padding(
                padding: EdgeInsets.all(15),
                child: Widgets.textField(_controller, "Enter temperature",TextInputType.number)
              ),
              Row(
                children: [
                  Widgets.buttonWidget("Send temperature", setTemperatureF),
                  Spacer(),
                  Widgets.buttonWidget("Get Temperature", getTemperatureF),
                  Spacer(),

                ],
              ),
              Container(
                height: 20,
              ),
              FutureBuilder<SeraModel>(
                future: _futureSeraModel,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data.result.toString());
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return Container();
                },
              ),
            ],
          )

        ),
      // ),
    );
  }

  void getTemperatureF(){
    SeraModel seraModel = new SeraModel();
    seraModel.seraId = connectionModel.SERA_ID;
    setState(() {
      _futureSeraModel = getTemperature(seraModel.seraId.toString(),connectionModel);
    });
  }
  
  void setTemperatureF(){
    SeraModel seraModel = new SeraModel();
    seraModel.seraId = connectionModel.SERA_ID;
    seraModel.temperature = _controller.text == "" ? null : int.parse(_controller.text);
    setState(() {
      _futureSeraModel = postSeraModel(seraModel,connectionModel);
    });
  }
}