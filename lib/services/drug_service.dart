import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/drug_model.dart';

class DrugService {
  final CollectionReference drugsRef = FirebaseFirestore.instance.collection('drugs');

  Future<void> addDrug(DrugModel drug) async {
    try {
      await drugsRef.doc(drug.drugId).set(drug.toMap());
    } catch (e) {
      print('Error adding drug: $e');
    }
  }

  Future<DrugModel?> getDrugById(String drugId) async {
    try {
      DocumentSnapshot doc = await drugsRef.doc(drugId).get();
      if (doc.exists) {
        return DrugModel.fromMap(doc.data() as Map<String, dynamic>, drugId: doc.id);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching drug: $e');
      return null;
    }
  }

  Future<DrugModel?> findMatchingDrug(String genericName, String type, String category) async {
    try {
      QuerySnapshot snapshot = await drugsRef
          .where('genericName', isEqualTo: genericName)
          .where('type', isEqualTo: type)
          .where('therapeuticCategory', isEqualTo: category)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        return DrugModel.fromMap(doc.data() as Map<String, dynamic>, drugId: doc.id);
      }
    } catch (e) {
      print('Error searching for drug: $e');
    }
    return null;
  }

  // ✅ NEW METHOD: Fetch all drugs in the catalog
  Future<List<DrugModel>> getAllDrugs() async {
    try {
      QuerySnapshot snapshot = await drugsRef.get();

      return snapshot.docs.map((doc) {
        return DrugModel.fromMap(doc.data() as Map<String, dynamic>, drugId: doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching all drugs: $e');
      return [];
    }
  }
}
