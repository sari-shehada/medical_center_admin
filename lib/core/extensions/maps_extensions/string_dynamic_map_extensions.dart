part of 'map_extensions.dart';

extension StringDynamicMapExtensions on Map<String, dynamic> {
  Map<String, String> toStringStringMap() {
    return map(
      (key, value) => MapEntry(
        key,
        value.toString(),
      ),
    );
  }
}
