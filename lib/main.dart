import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Prices',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CryptoListScreen(),
    );
  }
}

class CryptoListScreen extends StatefulWidget {
  @override
  _CryptoListScreenState createState() => _CryptoListScreenState();
}

class _CryptoListScreenState extends State<CryptoListScreen> {
  late List<dynamic> _cryptoData = [];

  @override
  void initState() {
    super.initState();
    _loadCryptoData();
  }

  Future<void> _loadCryptoData() async {
    try {
      var response =
          await http.get(Uri.parse('https://api.coinlore.net/api/tickers/'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          _cryptoData = data['data'];
        });
      } else {
        throw Exception('Failed to load crypto data');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to load crypto data: $e'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crypto Prices'),
        backgroundColor: Colors.blue,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _loadCryptoData();
            },
          ),
        ],
      ),
      body: _cryptoData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: _cryptoData.length,
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemBuilder: (BuildContext context, int index) {
                var crypto = _cryptoData[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(crypto['symbol']),
                  ),
                  title: Text(crypto['name']),
                  subtitle: Text('\$${crypto['price_usd']}'),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    // Implement onTap functionality if needed
                  },
                );
              },
            ),
    );
  }
}
