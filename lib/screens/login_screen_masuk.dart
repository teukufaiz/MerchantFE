import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'homepage.dart';

class LoginScreenMasuk extends StatefulWidget {
  @override
  _LoginScreenMasukState createState() => _LoginScreenMasukState();
}

class _LoginScreenMasukState extends State<LoginScreenMasuk> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool obscureText = true;
  String errorMessage = "";

  Future<void> login() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    var response = await http.post(
      Uri.parse('http://127.0.0.1:8000/auth/login'),  // Emulator Android
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "phone_number": phoneController.text,
        "password": passwordController.text,
      }),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['response'];
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(userData: data)),
      );
    } else {
      setState(() {
        errorMessage = "Nomor handphone atau password salah";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Colors.white,
        elevation: 0, // Hilangkan shadow di AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // Ikon kembali
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/login2.png', width: 350),
              SizedBox(height: 20),
              Text(
                "Hai, Apa Kabar Hari Ini? 👋",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "Yuk, masuk dan mulai kerja cuan lagi!",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(height: 20),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: "No. Handphone",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: obscureText,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text("Lupa Password?", style: TextStyle(color: Colors.blue)),
                ),
              ),
              if (errorMessage.isNotEmpty)
                Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: isLoading ? null : login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1357A6),
                  minimumSize: Size(300, 50),
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Masuk", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
