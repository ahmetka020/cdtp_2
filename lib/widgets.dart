import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Widgets{
  static   Widget textField(TextEditingController controller, String text,TextInputType textInputType){
    return TextField(
      textAlign: TextAlign.left,
      controller: controller,
      obscureText: false,
      keyboardType: textInputType,
      decoration: InputDecoration(
        // prefixIcon: Icon(Icons.port),
        border: new OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(20.0),
          ),
        ),
        labelText:text,
      ),
    );
  }

  static  Widget buttonWidget(String text, Function function){
    return  RaisedButton(
      color: Colors.red,
      textColor: Colors.white,
      disabledColor: Colors.grey,
      disabledTextColor: Colors.black,
      splashColor: Colors.redAccent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(color: Colors.red)),
      child: Padding(
        padding: EdgeInsets.only(left: 10,right: 10,),
        child: Text(text, style: TextStyle(fontSize: 15),),),
      onPressed: (){
        function();
      },
    );
  }
}