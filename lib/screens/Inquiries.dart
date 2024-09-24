import 'package:admin_panel/Utils/Constants.dart';
import 'package:admin_panel/models/inquiry.dart';
import 'package:flutter/material.dart';
import 'package:admin_panel/myDio.dart';

class InquiryScreen extends StatefulWidget {
  const InquiryScreen({super.key});

  @override
  _InquiryScreenState createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen> {
  List<Inquiry> inquiries = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchInquiries();
  }

  Future<void> fetchInquiries() async {
    try {
      final response = await MyDio().get('${Server.url}/api/inquiries');
      final List<dynamic> data = response.data;
      setState(() {
        inquiries = data.map((json) => Inquiry.fromJson(json)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load inquiries.';
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inquiries')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : DataTable(
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Phone')),
                    DataColumn(label: Text('Product Info')),
                    DataColumn(label: Text('Status')),
                  ],
                  rows: inquiries.map((inquiry) {
                    return DataRow(
                      cells: [
                        DataCell(Text(inquiry.id)),
                        DataCell(Text(inquiry.name)),
                        DataCell(Text(inquiry.email)),
                        DataCell(Text(inquiry.phone)),
                        DataCell(Text(inquiry.productInfo)),
                        DataCell(Text(inquiry.status)),
                      ],
                      onSelectChanged: (bool? selected) {
                        if (selected ?? false) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InquiryDetailPage(inquiry: inquiry),
                            ),
                          );
                        }
                      },
                    );
                  }).toList(),
                ),
    );
  }
}

class InquiryDetailPage extends StatelessWidget {
  final Inquiry inquiry;

  const InquiryDetailPage({Key? key, required this.inquiry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inquiry Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${inquiry.id}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Name: ${inquiry.name}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Email: ${inquiry.email}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Phone: ${inquiry.phone}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Message: ${inquiry.message}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Product Info: ${inquiry.productInfo}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Status: ${inquiry.status}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Created At: ${inquiry.createdAt}', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
