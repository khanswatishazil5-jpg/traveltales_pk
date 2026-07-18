/// Curated northern-Pakistan destinations for the location picker.
///
/// The app is Pakistan-focused, and a live places API for the northern
/// areas isn't wired up yet — this static list stands in for that until
/// it is, grouped the way travelers actually think about the region.
class PakistanLocation {
  final String name;
  final String region;

  const PakistanLocation({required this.name, required this.region});

  String get displayName => '$name, $region';
}

class PakistanLocations {
  static const List<PakistanLocation> all = [
    // Gilgit-Baltistan
    PakistanLocation(name: 'Hunza Valley', region: 'Gilgit-Baltistan'),
    PakistanLocation(name: 'Skardu', region: 'Gilgit-Baltistan'),
    PakistanLocation(name: 'Fairy Meadows', region: 'Gilgit-Baltistan'),
    PakistanLocation(name: 'Deosai National Park', region: 'Gilgit-Baltistan'),
    PakistanLocation(name: 'Khunjerab Pass', region: 'Gilgit-Baltistan'),
    PakistanLocation(name: 'Attabad Lake', region: 'Gilgit-Baltistan'),
    PakistanLocation(name: 'Gilgit City', region: 'Gilgit-Baltistan'),
    PakistanLocation(name: 'Shigar Valley', region: 'Gilgit-Baltistan'),
    PakistanLocation(name: 'Passu Cones', region: 'Gilgit-Baltistan'),
    PakistanLocation(name: 'Rakaposhi View Point', region: 'Gilgit-Baltistan'),
    // Khyber Pakhtunkhwa
    PakistanLocation(name: 'Swat Valley', region: 'Khyber Pakhtunkhwa'),
    PakistanLocation(name: 'Kalam', region: 'Khyber Pakhtunkhwa'),
    PakistanLocation(name: 'Naran', region: 'Khyber Pakhtunkhwa'),
    PakistanLocation(name: 'Kaghan Valley', region: 'Khyber Pakhtunkhwa'),
    PakistanLocation(name: 'Saif-ul-Malook Lake', region: 'Khyber Pakhtunkhwa'),
    PakistanLocation(name: 'Chitral', region: 'Khyber Pakhtunkhwa'),
    PakistanLocation(name: 'Kumrat Valley', region: 'Khyber Pakhtunkhwa'),
    PakistanLocation(name: 'Malam Jabba', region: 'Khyber Pakhtunkhwa'),
    // Azad Kashmir
    PakistanLocation(name: 'Neelum Valley', region: 'Azad Kashmir'),
    PakistanLocation(name: 'Arang Kel', region: 'Azad Kashmir'),
    PakistanLocation(name: 'Ratti Gali Lake', region: 'Azad Kashmir'),
    // Punjab hill stations
    PakistanLocation(name: 'Murree', region: 'Punjab'),
    PakistanLocation(name: 'Patriata (New Murree)', region: 'Punjab'),
    // Major cities (for posts not in the northern areas)
    PakistanLocation(name: 'Islamabad', region: 'Islamabad Capital Territory'),
    PakistanLocation(name: 'Lahore', region: 'Punjab'),
    PakistanLocation(name: 'Karachi', region: 'Sindh'),
    PakistanLocation(name: 'Peshawar', region: 'Khyber Pakhtunkhwa'),
  ];

  static List<PakistanLocation> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return all;
    return all
        .where((l) => l.name.toLowerCase().contains(q) || l.region.toLowerCase().contains(q))
        .toList();
  }
}
