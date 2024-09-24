import 'package:cloud_firestore/cloud_firestore.dart';

class ConfigService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> fetchUrl() async {
    final doc = await _firestore.collection('config').doc('settings').get();
    if (doc.exists) {
      return doc.data()?['url'] ?? 'http://localhost:3040';
    } else {
      throw Exception("Document not found");
    }
  }
}
