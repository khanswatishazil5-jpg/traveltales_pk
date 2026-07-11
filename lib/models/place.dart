/// A single nature destination shown on the Home page's
/// "Curated Collections" grid.
///
/// Using a class instead of a `Map<String, String>` gives us
/// compile-time safety (typos in a key like `'titel'` used to fail
/// silently at runtime; now they fail at compile time) and makes the
/// data self-documenting.
class Place {
  final String image;
  final String title;
  final String desc;

  const Place({
    required this.image,
    required this.title,
    required this.desc,
  });
}
