import 'package:daily_wisdom_flutter/utils/text_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('keepWordsTogether only allows breaks at spaces', () {
    final result = keepWordsTogether('깊이 사랑받으면 힘을');
    expect(result.split(' ').length, 3);
    expect(result.replaceAll('⁠', ''), '깊이 사랑받으면 힘을');
    expect(result.split(' ').first, '깊⁠이');
  });
}
