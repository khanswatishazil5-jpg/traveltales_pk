# Travel Tales — Firebase Handoff

This app is fully built on the frontend, running today on **local, on-device
storage** (`SharedPreferences`) standing in for a real backend. Every piece
of data — accounts, posts, comments, follows, profile pictures — lives only
on the one device it was created on. Your job is to swap that local storage
for real Firebase services **without changing any screen UI** — every
repository/service class below was written so screens only call its public
methods, never touch storage directly.

## 1. What to add to the Firebase project

Enable these in the Firebase console:
- **Authentication** → Email/Password provider
- **Cloud Firestore** (not Realtime Database — the code below assumes Firestore)
- **Cloud Storage** (for post photos and profile pictures — the app currently
  stores images as base64 strings locally, which will NOT scale; move these
  to real files in Storage and store the download URL instead)

## 2. Packages to add to `pubspec.yaml`

```yaml
firebase_core: ^3.6.0
firebase_auth: ^5.3.1
cloud_firestore: ^5.4.4
firebase_storage: ^12.3.4
```

Then run:
```
flutterfire configure
```
(requires the FlutterFire CLI — `dart pub global activate flutterfire_cli` —
and a Firebase project already created in console.firebase.google.com)

Initialize in `lib/main.dart`, before `runApp`:
```dart
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
```

## 3. Firestore schema

```
users/{uid}
  - username: string
  - email: string
  - bio: string
  - avatarUrl: string | null      // Storage download URL, not base64
  - createdAt: timestamp

posts/{postId}
  - authorUid: string            // references users/{uid}
  - username: string             // denormalized for easy display
  - avatarInitials: string
  - location: string
  - imageUrl: string             // Storage download URL
  - caption: string
  - likes: number
  - likedByUids: array<string>   // so "did I like this" is a simple contains-check
  - savedByUids: array<string>
  - qa: map<string, string>
  - createdAt: timestamp

comments/{commentId}
  - postId: string
  - authorUid: string
  - username: string
  - text: string
  - createdAt: timestamp

follows/{uid}
  - followingUids: array<string>  // who this user follows
```

Suggested Firestore indexes: `posts` ordered by `createdAt desc`;
`comments` filtered by `postId` ordered by `createdAt asc`.

## 4. Exact files to change (in order)

### `lib/services/auth_service.dart`
Currently: signup/login/logout against `SharedPreferences`, password hashed
with `crypto`'s SHA-256, no real session.

Replace with `firebase_auth`:
- `signUp()` -> `FirebaseAuth.instance.createUserWithEmailAndPassword(...)`,
  then write the `users/{uid}` document in Firestore (username, bio, etc.)
- `logIn()` -> `FirebaseAuth.instance.signInWithEmailAndPassword(...)`
- `logOut()` -> `FirebaseAuth.instance.signOut()`
- `isLoggedIn()` -> `FirebaseAuth.instance.currentUser != null`
- `getProfile()` -> read `users/{uid}` from Firestore where
  `uid = FirebaseAuth.instance.currentUser!.uid`
- `updateBio()` / `updateAvatarImage()` -> update the Firestore doc.
  For avatar: upload the picked image bytes to Firebase Storage first
  (`users/{uid}/avatar.jpg`), then save the resulting download URL as
  `avatarUrl` in Firestore -- don't store base64 in Firestore.

**Keep the method names and return types identical** -- `ProfileModel` can
stay as-is (just populate `avatarImageBase64` differently, or better,
rename it to `avatarUrl` and update the ~3 places that read it in
`profile_screen.dart`).

### `lib/services/post_repository.dart`
Currently: local JSON list in `SharedPreferences`.

Replace with Firestore:
- `getLocalPosts()` -> query `posts` collection ordered by `createdAt desc`
  (rename to `getPosts()` if you like -- update the one caller in
  `api_service.dart`)
- `addPost()` -> upload the image bytes to Storage
  (`posts/{postId}.jpg`), then write the Firestore doc with the resulting URL
- `deletePost()` -> delete the Firestore doc (and the Storage file)
- `updatePost()` -> update the Firestore doc

### `lib/services/comment_repository.dart`
- `getCommentsFor(postId)` -> Firestore query `comments` where
  `postId == postId`, ordered by `createdAt asc`
- `addComment()` -> add a Firestore doc

### `lib/services/follow_repository.dart`
- Read/write the `follows/{uid}` document's `followingUids` array
  (`FieldValue.arrayUnion([username])` / `arrayRemove`)
- For a real "Followers" count (currently hardcoded to 0 in
  `profile_screen.dart` since there's no cross-device data), you'd query
  how many other `follows` documents contain this user's uid in their
  `followingUids` array -- either via a Cloud Function that maintains a
  counter, or a client-side `array-contains` query if scale allows it.

### `lib/services/api_service.dart`
Already structured as the single seam between screens and data -- once the
repositories above talk to Firestore, this file barely needs to change.
Just remove the `MockData.posts` merge once there's enough real seed data,
or keep merging mock + real posts if you want sample content to remain.

### `lib/widgets/post_image.dart`
No change needed -- it already branches on whether `source` is a `data:`
URI or a normal URL. Firestore/Storage download URLs are normal URLs, so
this keeps working unchanged.

## 5. Firestore security rules (starting point -- tighten before shipping)

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{uid} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == uid;
    }
    match /posts/{postId} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null
        && request.auth.uid == resource.data.authorUid;
    }
    match /comments/{commentId} {
      allow read: if true;
      allow create: if request.auth != null;
    }
    match /follows/{uid} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == uid;
    }
  }
}
```

## 6. What NOT to change

- `PostModel`, `CommentModel`, `ProfileModel` shapes are already close to
  final -- extend them (e.g. add `authorUid`) rather than restructuring.
- Every screen (`feed_screen.dart`, `profile_screen.dart`,
  `create_post_screen.dart`, `comments_screen.dart`, `explore_tiles.dart`)
  calls only the repository/service classes above -- you should not need to
  touch screen files at all if the method signatures stay the same.

## 7. Local dev data

There's no migration path for whatever's currently saved in
`SharedPreferences` on testers' devices -- that's expected and fine, it was
always meant to be throwaway local data for the frontend-only phase.
