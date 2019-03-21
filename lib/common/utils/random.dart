import 'dart:math';

class RandomUtil {
  static int next(int min, int max) {
    final _random = new Random();
    return min + _random.nextInt(max - min);
  }
}
