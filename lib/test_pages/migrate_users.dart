import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

class UserMigrationService {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> migrateUsersToFirebaseAuth() async {
    final users = await _firestoreService.getAllUsers();
    int successCount = 0;
    int skippedCount = 0;
    int failedCount = 0;

    for (UserModel user in users) {
      try {
        // Skip invalid emails
        if (!user.email.contains('@') || !user.email.contains('.')) {
          print('⚠️ Skipping invalid email: ${user.email}');
          skippedCount++;
          continue;
        }

        // Try to create the user
        await _auth.createUserWithEmailAndPassword(
          email: user.email,
          password: user.password,
        );

        print('✅ Migrated: ${user.email}');
        successCount++;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          print('⚠️ Skipped (already exists): ${user.email}');
          skippedCount++;
        } else {
          print('❌ Firebase error migrating ${user.email}: ${e.message}');
          failedCount++;
        }
      } catch (e) {
        print('❌ Unknown error migrating ${user.email}: $e');
        failedCount++;
      }
    }

    print('\n📊 Migration Complete:');
    print('➡️ Success: $successCount');
    print('⚠️ Skipped: $skippedCount (already exists or invalid)');
    print('❌ Failed: $failedCount');
  }
}
