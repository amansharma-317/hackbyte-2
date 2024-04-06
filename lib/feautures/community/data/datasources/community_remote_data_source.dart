import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hackbyte2/feautures/community/domain/entities/post_entity.dart';
import '../../domain/entities/comment_entity.dart';

class CommunityRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<PostEntity>> getPostsBySection(String section) async {
    try {
      List<PostEntity> posts = [];
      if(section == "All"){
        final querySnapshot = await _firestore.collection('posts').orderBy('timestamp', descending: true).get();
        for (DocumentSnapshot doc in querySnapshot.docs) {
          // Map data directly to a PostEntity object
          final dataMap = doc.data() as Map<String, dynamic>;
          final post = PostEntity.fromMap(dataMap);
          posts.add(post);
        }
      } else {
        final querySnapshot = await _firestore.collection('posts').where(
            'section', isEqualTo: section).orderBy('timestamp', descending: true).get();
        for (DocumentSnapshot doc in querySnapshot.docs) {
          // Map data directly to a PostEntity object
          final dataMap = doc.data() as Map<String, dynamic>;
          final post = PostEntity.fromMap(dataMap);
          posts.add(post);
        }

      }
     // posts.add(PostEntity.fromMap(querySnapshot.docs.first.data() as Map<String, dynamic>));

      return posts;
    } catch (e) {

      print('Error fetching posts: $e');
      throw e;
    }
  }

  Future<DocumentReference> addPost(PostEntity post) async {
    try {
      // Add post to Firestore without postId, generating a new document ID
      final docRef = await _firestore.collection('posts').add(post.toMap());
      // Update the Firestore document with the postId
      await docRef.update({'postId': docRef.id});

      return docRef;
    } catch (e) {
      print('Error adding post: $e');
      throw FirebaseException(plugin: 'firebase_core', message: 'Error adding post');
    }
  }

  Future<void> likePost(String postId, String userId) async {
    try {
      final postRef = _firestore.collection('posts').doc(postId);

      final postDoc = await postRef.get();
      if (postDoc.exists) {
        final likes = List<String>.from(postDoc.data()?['likes'] ?? []);
        print('before if');
        if (likes.contains(userId)) {
          // User already liked, remove like
          print('contains userid');
          likes.remove(userId);
        } else {
          // User not liked, add like
          print('does not contain');
          likes.add(userId);
        }
        print('outside if');
        await postRef.update({'likes': likes});
      }
    } catch (e) {
      print('Error liking post: $e');
      throw Exception('Error liking post');
    }
  }

  Future<void> likeComment(String commentId, String userId,String postId) async {
    try {
      final postRef = _firestore.collection('posts').doc(postId).collection('comments').doc(commentId);

      final postDoc = await postRef.get();
      if (postDoc.exists) {
        final likes = List<String>.from(postDoc.data()?['likes'] ?? []);
        print('before if');
        if (likes.contains(userId)) {
          // User already liked, remove like
          print('contains userid');
          likes.remove(userId);
        } else {
          // User not liked, add like
          print('does not contain');
          likes.add(userId);
        }
        print('outside if');
        await postRef.update({'likes': likes});
      }
    } catch (e) {
      print('Error liking post: $e');
      throw Exception('Error liking post');
    }
  }

  Stream<List<CommentEntity>> streamCommentsForPost(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => CommentEntity.fromMap(doc.data() as Map<String, dynamic>))
        .toList());
  }

  Future<void> addComment(String postId, CommentEntity comment) async{
    try {
      final doc = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .add(comment.toMap());
      await doc.update({'commentId': doc.id});
    } catch (e) {
      print('Error adding comment: $e');
      throw Exception('Error adding comment');
    }
  }

  Future<bool> checkLikeStatusForPost(String postId) async{
    try {
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;
      final doc = await FirebaseFirestore.instance.collection('posts').doc(postId).get();
      final likes = doc.data()?['likes'] ?? [];
      return likes.contains(currentUserId);
    } catch (e) {
      print('Error adding comment: $e');
      throw Exception('Error adding comment');
    }
  }

  Future<bool> checkLikeStatusForComment(String postId, String commentId) async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;
      
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .where('commentId', isEqualTo: commentId)
          .get();
      
      if (querySnapshot.docs.isNotEmpty) {
        final likes = (querySnapshot.docs.first.data() as Map<String, dynamic>)['likes'] ?? [];
        return likes.contains(currentUserId);
      } else {
        return false;
      }
    } catch (e) {
      print('Error checking like status for comment: $e');
      throw Exception('Error checking like status for comment');
    }
  }

  Future<int> getLikeCountForPost(String postId) async{
    try {
      final doc = await FirebaseFirestore.instance.collection('posts').doc(postId).get();
      final List likes = doc.data()?['likes'] ?? [];
      return likes.length;
    } catch (e) {
      print('Error adding comment: $e');
      throw Exception('Error adding comment');
    }
  }

  Future<int> getLikeCountForComment(String commentId, String postId) async {
    try {
      final DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .get();

      final List likes = (doc.data() as Map<String, dynamic>)['likes'] ?? [];
      print('list of likes is ' + likes.length.toString() + likes.toString());
      return likes.length;

    } catch (e) {
      print('Error getting like count for comment: $e');
      throw Exception('Error getting like count for comment');
    }
  }


  Future<int> getCommentsCount(String postId) async{
    try {
      final comments = await FirebaseFirestore.instance.collection('posts').doc(postId).collection('comments').get();
      final numberOfComments = comments.size;
      return numberOfComments;
    } catch (e) {
      print('Error adding comment: $e');
      throw Exception('Error adding comment');
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
      final postDocumentSnapshot = await postRef.get();
      if (postDocumentSnapshot.exists) {
        await postRef.delete();
        print('Post deleted successfully.');
      } else {
        print('Post not found or does not belong to the user.');
      }
    } catch (error) {
      print('Error deleting post: $error');
    }
  }
}

