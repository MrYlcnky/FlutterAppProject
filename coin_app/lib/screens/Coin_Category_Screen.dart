import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Coin_Screen.dart'; // Coin Screen dosyasını import ediyoruz

class CoinCategoryScreen extends StatefulWidget {
  @override
  _CoinCategoryScreenState createState() => _CoinCategoryScreenState();
}

class _CoinCategoryScreenState extends State<CoinCategoryScreen> {
  List<dynamic>? coins;
  List<dynamic>? filteredCoins;
  TextEditingController searchController = TextEditingController();

  // Kripto paraları almak için API'den veri çeken metot
  Future<List<dynamic>> fetchCoins() async {
    final response = await http.get(Uri.parse('https://api.coincap.io/v2/assets'));
    final data = jsonDecode(response.body);
    return data['data'];
  }

  @override
  void initState() {
    super.initState();
    // initState() metodu çalıştığında kripto paraları getiriyoruz ve state'i güncelliyoruz
    fetchCoins().then((value) {
      setState(() {
        coins = value;
        filteredCoins = value;
      });
    });

    // Arama kontrollerini dinlemek için listener ekliyoruz
    searchController.addListener(() {
      filterCoins();
    });
  }

  // Kripto paraları filtreleyen metot
  void filterCoins() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredCoins = coins!.where((coin) {
        final name = coin['name'].toLowerCase();
        final symbol = coin['symbol'].toLowerCase();
        return name.contains(query) || symbol.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    // Sayfa kapatıldığında arama controller'ını temizliyoruz
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 48, 46, 46), // Sayfa arkaplan rengi
      appBar: AppBar(
        title: Text(
          'Coins', // AppBar başlığı
          style: TextStyle(
            color: const Color.fromARGB(255, 8, 204, 14), // Başlık rengi
            fontWeight: FontWeight.bold, // Kalın font ağırlığı
            fontStyle: FontStyle.italic, // İtalik font stili
          ),
        ),
        backgroundColor: Color.fromARGB(255, 48, 46, 46), // AppBar arkaplan rengi
        centerTitle: true, // AppBar başlığını ortala
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search', // Arama kutusu etiketi
                labelStyle: TextStyle(color: Color.fromARGB(255, 8, 204, 14)), // Arama kutusu etiket rengi
                hintStyle: TextStyle(color: Color.fromARGB(255, 8, 204, 14)), // Arama kutusu içerisindeki metin rengi
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              style: TextStyle(color: Color.fromARGB(255, 8, 204, 14)), // Arama kutusu metin rengi
            ),
          ),
          Expanded(
            child: filteredCoins == null // Filtrelenmiş coin listesi null ise
                ? Center(child: CircularProgressIndicator()) // Yükleme işareti göster
                : ListView.builder(
                    itemCount: filteredCoins!.length ~/ 2, // Her satırda iki öğe olduğu için öğe sayısını ikiye böl
                    itemBuilder: (BuildContext context, int index) {
                      final firstCoin = filteredCoins![index * 2]; // İlk sıradaki coin
                      final secondCoinIndex = index * 2 + 1;
                      final secondCoin = secondCoinIndex < filteredCoins!.length // İkinci sıradaki coin
                          ? filteredCoins![secondCoinIndex]
                          : null; // İkinci sıradaki coin null ise

                      // Satırın arka plan rengini belirle
                      Color firstBackgroundColor = index.isEven ? Color.fromARGB(255, 8, 204, 14) : Color.fromARGB(255, 104, 102, 102);
                      Color secondBackgroundColor = index.isEven ? Color.fromARGB(255, 104, 102, 102) : Color.fromARGB(255, 8, 204, 14);

                      return Row(
                        children: [
                          Expanded(
                            child: _buildCoinItem(firstCoin, firstBackgroundColor),
                          ),
                          SizedBox(width: 10), // Boşluk ekleyici
                          Expanded(
                            child: secondCoin != null ? _buildCoinItem(secondCoin, secondBackgroundColor) : Container(), // İkinci coin null değilse görüntüle
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Coin öğesini oluşturan metot
  Widget _buildCoinItem(dynamic coin, Color backgroundColor) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 500),
            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
              return CoinScreen(coin: coin); // Coin Screen'e geçiş yap
            },
            transitionsBuilder: (BuildContext context
, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        );
      },
      child: Container(
        color: backgroundColor, // Arka plan rengi
        padding: EdgeInsets.all(8), // Kenar boşlukları
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${coin['name']}', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)), // Coin adı
            SizedBox(height: 5),
            Text('${coin['symbol']}', style: TextStyle(fontSize: 18, color: Colors.white)), // Coin simgesi
            SizedBox(height: 5),
            Text('\$${coin['priceUsd']}', style: TextStyle(fontSize: 16, color: Colors.white)), // Coin fiyatı
          ],
        ),
      ),
    );
  }
}
