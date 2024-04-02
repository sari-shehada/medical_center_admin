part of 'map_extensions.dart';

extension StringStringMapExtensions on Map<String, String> {
  getEntriesAsUrlQuery({
    bool withQuestionMark = false,
  }) {
    String result = withQuestionMark ? '?' : '';
    List<String> combinedKeyValue = [];
    forEach((key, value) {
      combinedKeyValue.add('$key=$value');
    });
    result += combinedKeyValue.join('&&');
    return result;
  }
}
