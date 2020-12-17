import 'dart:async';
import 'dart:convert';
import 'package:cdtp_client/SeraModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String address = "https://192.168.0.55";
String port = ":8000/";
int SERA_ID = 4;

Future<SeraModel> postSeraModel(SeraModel _seraModel) async {
  final http.Response response = await http.post(
    address + port + "setTemperature",
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'seraId' : _seraModel.seraId,
      'temperature': _seraModel.temperature,
    }),
  );
  print("post -> ${address}${port}setTemperature");
  if (response.statusCode == 201) {
    return SeraModel.fromJson(jsonDecode(response.body));
  } else {
    print(response.statusCode.toString());
    throw Exception('Failed.');
  }

}

Future<SeraModel> getTemperature(String seraId) async {
  String lastAddress = address + port + "getTemperature?seraId=" + seraId;
  print('get -> $lastAddress');
  final response = await http.get(lastAddress);
  if (response.statusCode == 200) {
    return SeraModel.fromJson(jsonDecode(response.body));
  } else {
    print(response.statusCode.toString());
    throw Exception('Failed to get temperature.');
  }
}


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _controller = TextEditingController();
  Future<SeraModel> _futureSeraModel;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child:      Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(15),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _controller,
                  decoration: InputDecoration(hintText: 'Enter temperature'),
                ),
              ),
              Row(
                children: [
                  ElevatedButton(
                    child: Text('Send Temperature'),
                    onPressed: () {
                      SeraModel seraModel = new SeraModel();
                      seraModel.seraId = SERA_ID;
                      seraModel.temperature = int.parse(_controller.text);
                      setState(() {
                        _futureSeraModel = postSeraModel(seraModel);
                      });
                    },
                  ),
                  Spacer(),
                  ElevatedButton(
                    child: Text('Get Temperature'),
                    onPressed: () {
                      SeraModel seraModel = new SeraModel();
                      seraModel.seraId = SERA_ID;
                      setState(() {
                        _futureSeraModel = getTemperature(seraModel.seraId.toString());
                      });
                    },
                  ),
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
                    return Text(snapshot.data.temperature.toString());
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return Container();
                },
              ),
            ],
          )

        ),
      ),
    );
  }
}