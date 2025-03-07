import 'package:flutter/material.dart';
import 'login_screen_masuk.dart';
import 'loan.dart';

class HomePage extends StatelessWidget {
  final Map<String, dynamic> userData;

  HomePage({required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20, top: 40, right: 20, bottom: 100),
                width: double.infinity,
                color: Color(0xFF1357A6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('assets/images/merchantlogo.png', height: 150, width: 250,),
                    IconButton(
                      icon: Icon(Icons.logout, color: Colors.white),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreenMasuk()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 80),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoanPage( userData: userData,)),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Ekspansi bisnismu dengan dengan livin’ modal merchant.",
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFF1357A6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Pendapatan Hari Ini, 7 Mar 2025",
                          style: TextStyle(color: Colors.white, fontSize: 14)),
                      SizedBox(height: 5),
                      Text("Rp271.000.000.000",
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text("271 Transaksi", style: TextStyle(color: Colors.white, fontSize: 12)),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Lihat Semua",
                          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 250,
            left: 20,
            right: 20,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(userData['business_name'],
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("Anda sebagai: Pemilik", style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Poin Kasir", style: TextStyle(fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Icon(Icons.circle, size: 10, color: Colors.grey),
                            SizedBox(width: 5),
                            Text("${userData['point']}", style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Katalog"),
          BottomNavigationBarItem(icon: Icon(Icons.point_of_sale), label: "Kasir"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: "Pesanan"),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: "Transaksi"),
        ],
      ),
    );
  }
}