import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:merchantfe/screens/create_loan.dart';

class LoanPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  LoanPage({required this.userData});

  @override
  _LoanPageState createState() => _LoanPageState();
}

class _LoanPageState extends State<LoanPage> {
  double totalApprovedLoans = 0;
  List<dynamic> loans = [];

  @override
  void initState() {
    super.initState();
    fetchLoans();
    fetchTotalApprovedLoans();
  }

  String formatCurrency(double amount) {
    return "Rp. " + amount.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }

  Future<void> fetchLoans() async {
    final userId = widget.userData['id'];
    final url = 'http://127.0.0.1:8000/loan/get_loans/$userId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          loans = data['loans'];
        });
      }
    } catch (e) {
      print("Error fetching loans: $e");
    }
  }

  Future<void> fetchTotalApprovedLoans() async {
    final userId = widget.userData['id'];
    final url = 'http://127.0.0.1:8000/loan/total_approved_loans/$userId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          totalApprovedLoans = data['total_approved_loans'];
        });
      }
    } catch (e) {
      print("Error fetching total approved loans: $e");
    }
  }

  void showCancelDialog(int loanId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Apakah kamu ingin membatalkan peminjaman?", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text("Jika Anda membatalkan pengajuan ini, proses pinjaman tidak akan dilanjutkan. Tindakan ini tidak dapat dibatalkan. Apakah Anda yakin ingin melanjutkan?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Tidak, Kembali", style: TextStyle(color: Colors.blue)),
            ),
            TextButton(
              onPressed: () async {
                await cancelLoan(loanId);
                Navigator.pop(context);
                fetchLoans();
              },
              child: Text("Ya, Batalkan", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> cancelLoan(int loanId) async {
    final url = 'http://127.0.0.1:8000/loan/delete_loan/$loanId';
    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        print("Loan canceled successfully");
      } else {
        print("Failed to cancel loan");
      }
    } catch (e) {
      print("Error canceling loan: $e");
    }
  }

  Widget getStatusWidget(String status) {
    switch (status) {
      case "Diterima":
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 16),
            SizedBox(width: 5),
            Text("Diterima", style: TextStyle(color: Colors.green)),
          ],
        );
      case "Ditolak":
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cancel, color: Colors.red, size: 16),
            SizedBox(width: 5),
            Text("Ditolak", style: TextStyle(color: Colors.red)),
          ],
        );
      default:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.hourglass_empty, color: Colors.orange, size: 16),
            SizedBox(width: 5),
            Text("Diproses", style: TextStyle(color: Colors.orange)),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Livin' Modal Merchant"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Limit Tersedia: Rp10.000.000", style: TextStyle(color: Colors.white, fontSize: 14)),
                  SizedBox(height: 5),
                  Text(
                    formatCurrency(totalApprovedLoans),
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Pengajuan Pinjaman", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () {},
                  child: Text("Lihat Semua", style: TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: loans.length,
                itemBuilder: (context, index) {
                  final loan = loans[index];
                  return GestureDetector(
                    onTap: loan['status'] == "Diproses" ? () => showCancelDialog(loan['loan_id']) : null,
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text("Pinjaman ${formatCurrency(loan['amount'])}"),
                        subtitle: getStatusWidget(loan['status']),
                        trailing: Text(loan['created_at']),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  bool? isLoanCreated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateLoanPage(userData: widget.userData),
                    ),
                  );

                  if (isLoanCreated == true) {
                    // Fetch ulang daftar pinjaman jika ada pinjaman baru
                    fetchLoans();
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: Text("Ajukan Peminjaman"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
