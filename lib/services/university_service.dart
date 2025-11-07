import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/university.dart';

class UniversityService {
  // Lazily access the collection so this class can be instantiated before
  // Firebase.initializeApp() has completed during hot-reload or tests.
  CollectionReference<Map<String, dynamic>> get _col =>
      FirebaseFirestore.instance.collection('universidades');

  Stream<List<University>> streamUniversities() {
    // If Firebase is not initialized, return an empty list stream so the UI
    // can run without crashing. The user can configure Firebase later to
    // enable the real-time list.
    if (Firebase.apps.isEmpty) {
      return Stream.value(<University>[]);
    }

    return _col.snapshots().map((snap) {
      return snap.docs.map((d) => University.fromMap(d.id, d.data())).toList();
    });
  }

  Future<void> addUniversity(University u) async {
    if (Firebase.apps.isEmpty) throw StateError('Firebase no inicializado');
    await _col.add(u.toMap());
  }

  /// Get a single university by document id. Throws if not found.
  Future<University> getUniversityById(String id) async {
    if (Firebase.apps.isEmpty) throw StateError('Firebase no inicializado');
    final doc = await _col.doc(id).get();
    if (!doc.exists) throw StateError('Documento no encontrado');
    return University.fromMap(doc.id, doc.data()!);
  }

  Future<void> updateUniversity(University u) async {
    if (Firebase.apps.isEmpty) throw StateError('Firebase no inicializado');
    await _col.doc(u.id).update(u.toMap());
  }

  Future<void> deleteUniversity(String id) async {
    if (Firebase.apps.isEmpty) throw StateError('Firebase no inicializado');
    await _col.doc(id).delete();
  }
}
