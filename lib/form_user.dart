import 'package:flutter/material.dart';
import 'package:flutter_sqlite/utils/connection.dart';
// import 'package:sqflite/sqflite.dart';

class FormUser extends StatefulWidget {
  @override
  _FormUserState createState() => _FormUserState();
}

class _FormUserState extends State<FormUser> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _formData = {
    'enabled': false
  };

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> _formData = {};

    return Card(
      child: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nome'
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Este campo é obrigatório';
                  }
                },
                onSaved: (value) {
                  _formData['name'] = value;
                }
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email'
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Este campo é obrigatório';
                  }
                },
                onSaved: (value) {
                  _formData['email'] = value;
                }
              ),
              Switch(
                value: false,
                onChanged: (value) {
                  _formData['enabled'] = value;
                },
              ),
              RaisedButton(
                color: Colors.blue,
                child: Text('Cadastrar', style: TextStyle(color: Colors.white),),
                onPressed: () {
                  if (_formKey.currentState.validate()){
                    _formKey.currentState.save();
                    _insertData();
                    _formKey.currentState.reset();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _insertData() async {
    var data = [
      _formData['name'],
      _formData['email'],
      _formData['enabled']
    ];

    var database = await SqliteDB.connect();
    database.transaction((txn) async {
      int id = await txn.rawInsert(
        "INSERT INTO users (name, email, enabled) VALUES (?,?,?)",
        data
      );
    });
  }
}