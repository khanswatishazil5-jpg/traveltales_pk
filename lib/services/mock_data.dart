import '../models/post_model.dart';
import '../models/user_model.dart';

/// Placeholder content so every screen renders before the backend is live.
/// Swap out for real ApiService results once /travel_tales_backend is deployed.
class MockData {
  static final List<PostModel> posts = [
    PostModel(
      id: '1',
      username: 'maya.wanders',
      avatarInitials: 'MW',
      location: 'Hunza Valley, Pakistan',
      imageUrl:
          'https://images.unsplash.com/photo-1601921004897-b7d6f5b6f5b3?w=800&q=80&auto=format&fit=crop',
      caption:
          "Woke up to this view over the valley — three days here still weren't enough.",
      likes: 482,
      qa: {
        'Cost': 'Roughly \$25–35/day including a guesthouse stay, meals, and local transport.',
        'Best time': 'April–June or September–October, before/after peak summer crowds.',
        'Tips': "Book the guesthouse ahead in shoulder season — rooms fill fast on weekends.",
        'Story': 'A local family invited me in for tea mid-hike and we ended up talking for two hours.',
      },
    ),
    PostModel(
      id: '2',
      username: 'theo.trailmap',
      avatarInitials: 'TT',
      location: 'Lisbon, Portugal',
      imageUrl:
          'https://images.unsplash.com/photo-1585208798174-6cedd86e019a?w=800&q=80&auto=format&fit=crop',
      caption: 'Tram 28 at golden hour is a cliché for a reason.',
      likes: 311,
      qa: {
        'Cost': 'About €60/day for a mid-range trip.',
        'Best time': 'May or late September — warm but not the August crush.',
        'Tips': "Get the Lisboa Card if you're museum-hopping.",
        'Story': 'Missed my tram stop twice trying to get the perfect photo.',
      },
    ),
    PostModel(
      id: '3',
      username: 'amara.ok',
      avatarInitials: 'AO',
      location: 'Zanzibar, Tanzania',
      imageUrl:
          'https://images.unsplash.com/photo-1544644181-1484b3fdfc62?w=800&q=80&auto=format&fit=crop',
      caption: 'Spice tour in the morning, this water by noon.',
      likes: 640,
      qa: {
        'Cost': 'Around \$40/day for guesthouse + street food.',
        'Best time': 'June–October for the dry season and calmest seas.',
        'Tips': 'Negotiate spice-tour prices upfront.',
        'Story': 'A fisherman let me help pull in the morning catch.',
      },
    ),
  ];

  static final List<PlaceModel> places = [
    PlaceModel(placeId: 'p1', name: 'Skardu, Pakistan', subtitle: 'Mountain base town · 214 travel tales'),
    PlaceModel(placeId: 'p2', name: 'Reykjavik, Iceland', subtitle: 'City · 189 travel tales'),
    PlaceModel(placeId: 'p3', name: 'Ubud, Bali', subtitle: 'Town · 401 travel tales'),
  ];

  static final List<UserModel> people = [
    UserModel(id: 'u1', username: 'maya.wanders', avatarInitials: 'MW', bio: '38 countries · Hunza Valley now'),
    UserModel(id: 'u2', username: 'theo.trailmap', avatarInitials: 'TT', bio: 'Slow travel, mostly Europe'),
  ];
}
