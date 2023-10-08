import 'package:flutter/material.dart';

class ReceiptApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Receipt App',
      theme: ThemeData(
        primaryColor: Color.fromARGB(213, 116, 203, 224),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ReceiptPage(),
    );
  }
}

class ReceiptPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Receipt"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Receipt', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Table(
              border: TableBorder.all(),
              children: [
                _buildTableRow(["Item Name", "Quantity", "Price", "Currency"]),
                _buildTableRow(["travel package", "1", "1500", "USD"]),
                _buildTableRow(["insurance", "1", "200", "USD"]),
                _buildTableRow(["Subtotal", "", "1700", "USD"]),
                _buildTableRow(["Shipping", "", "0", "USD"]),
                _buildTableRow(["Shipping Discount", "", "0", "USD"]),
                _buildTableRow(["Total", "", "1700", "USD"]),
              ],
            ),
            SizedBox(height: 20),
            Text('Description: payment for the travel package.'),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(List<String> items) {
    return TableRow(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(item, style: TextStyle(fontSize: 16)),
        );
      }).toList(),
    );
  }
}
