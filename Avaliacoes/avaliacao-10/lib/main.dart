import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulário',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.blue, fontSize: 18),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
      home: FormValidationScreen(),
    );
  }
}

class FormValidationScreen extends StatefulWidget {
  @override
  _FormValidationScreenState createState() => _FormValidationScreenState();
}

class _FormValidationScreenState extends State<FormValidationScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) return 'Por favor, insira uma data.';
    try {
      DateFormat("dd-MM-yyyy").parseStrict(value);
    } catch (e) {
      return 'Por favor, insira uma data válida no formato dd-mm-aaaa.';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Por favor, insira um email.';
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(value)) return 'Por favor, insira um email válido.';
    return null;
  }

  String? _validateCPF(String? value) {
    if (value == null || value.isEmpty) return 'Por favor, insira um CPF.';

    // Remove pontuações para validação
    String unmaskedValue = value.replaceAll(RegExp(r'[^\d]'), '');
    if (unmaskedValue.length != 11) return 'O CPF deve ter 11 dígitos.';

    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += int.parse(unmaskedValue[i]) * (10 - i);
    }
    int digit1 = (sum * 10) % 11;
    if (digit1 == 10) digit1 = 0;
    if (digit1 != int.parse(unmaskedValue[9])) return 'CPF inválido.';

    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += int.parse(unmaskedValue[i]) * (11 - i);
    }
    int digit2 = (sum * 10) % 11;
    if (digit2 == 10) digit2 = 0;
    if (digit2 != int.parse(unmaskedValue[10])) return 'CPF inválido.';

    return null;
  }

  String? _validateValue(String? value) {
    if (value == null || value.isEmpty) return 'Por favor, insira um valor.';
    try {
      double.parse(value);
    } catch (e) {
      return 'Por favor, insira um valor numérico válido.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário',
         textAlign: TextAlign.center,
        ),
         centerTitle: true,
        backgroundColor: Color.fromARGB(255, 56, 79, 211),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Data (dd-mm-aaaa)'),
                keyboardType: TextInputType.datetime,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
                ],
                validator: _validateDate,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'CPF'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  MaskedInputFormatter('000.000.000-00'), // Máscara para CPF
                ],
                validator: _validateCPF,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Valor'),
                keyboardType: TextInputType.number,
                validator: _validateValue,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Formulário válido!')),
                    );
                  }
                },
                child: Text('Enviar'),
                 style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 56, 79, 211),
                  foregroundColor: Colors.white,// Cor de fundo do botão
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
