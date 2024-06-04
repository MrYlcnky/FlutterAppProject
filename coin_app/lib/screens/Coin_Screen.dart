import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class CoinScreen extends StatefulWidget {
  final dynamic coin;

  CoinScreen({required this.coin});

  @override
  _CoinScreenState createState() => _CoinScreenState();
}

class _CoinScreenState extends State<CoinScreen> {
  String? currencySymbol;

  @override
  void initState() {
    super.initState();
    fetchCurrencySymbol();
  }

  // Coin'un currency symbolünü getiren fonksiyon
  Future<void> fetchCurrencySymbol() async {
    try {
      Response response = await Dio().get('https://api.coincap.io/v2/rates/${widget.coin['id']}');
      setState(() {
        currencySymbol = response.data['data']['currencySymbol'];
      });
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${widget.coin['name']} ', // Coin ismi
              style: TextStyle(
                color: Color.fromARGB(255, 8, 204, 14),
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            Text(
              '(${widget.coin['symbol']})', // Coin simgesi
              style: TextStyle(
                color: Color.fromARGB(255, 8, 204, 14),
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 48, 46, 46),
        iconTheme: IconThemeData(color: Color.fromARGB(255, 8, 204, 14)),
      ),
      backgroundColor: Color.fromARGB(255, 48, 46, 46),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Satırların ortalandığını belirtir
            children: [
              Row( // Symbol ve Currency Symbol'ü içeren satır
                mainAxisAlignment: MainAxisAlignment.center, // Widget'ların ortalandığını belirtir
                children: [
                  _buildSymbolText('${widget.coin['symbol']}'), // Symbolü içeren widget'ı ekler
                  SizedBox(width: 10), // Boşluk ekler
                  Text( // Currency Symbol'ü içeren widget'ı ekler
                    currencySymbol ?? '', // Eğer currencySymbol null ise boş string gösterir
                    style: TextStyle(
                      fontSize: 48,
                      color: Color.fromARGB(255, 8, 204, 14),
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30), // Boşluk ekler
              Table(
                border: TableBorder.all(color: Colors.white), // Tablo çizgileri belirginleştirilir
                defaultVerticalAlignment: TableCellVerticalAlignment.middle, // Hücreler arası boşluk ayarlanır
                columnWidths: {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(2),
                },
                children: [
                  _buildTableRow('Price USD:', '\$${widget.coin['priceUsd']}'), // USD fiyatı
                  _buildTableRow('Market Cap USD:', '\$${widget.coin['marketCapUsd']}'), // Piyasa değeri
                  _buildTableRow('Volume USD 24Hr:', '\$${widget.coin['volumeUsd24Hr']}'), // 24 saatlik hacim
                  _buildTableRow('Change Percent 24Hr:', '${widget.coin['changePercent24Hr']}%'), // 24 saatlik değişim yüzdesi
                  _buildTableRow('Supply:', '${widget.coin['supply']}'), // Arz
                  _buildTableRow('Explorer:', widget.coin['explorer'] ?? ''), // Explorer
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Coin simgesini ve Currency Symbol'ü oluşturan widget
  Widget _buildSymbolText(String symbol) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        symbol, // Symbol
        style: TextStyle(
          fontSize: 48,
          color: Color.fromARGB(255, 8, 204, 14),
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  // Tablo satırını oluşturan widget
  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              label,
              style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 8, 204, 14), fontWeight: FontWeight.bold),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              value,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
