import 'package:flutter/widgets.dart';

/// Word joiner (U+2060): an invisible character that forbids a line break.
const String _wordJoiner = '⁠';

/// Makes Korean (and other CJK) text wrap only at spaces, like CSS
/// `word-break: keep-all`. Flutter otherwise breaks Hangul between any two
/// syllables, splitting words mid-way ("사랑하 / 면").
///
/// Only use for display; the result contains invisible characters.
String keepWordsTogether(String text) {
  return text
      .split(' ')
      .map((word) => word.characters.join(_wordJoiner))
      .join(' ');
}
