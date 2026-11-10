import 'package:demo1/features/resources/presentation/resource_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fromName finds each type', () {
    expect(ResourceType.fromName('water'), ResourceType.water);
    expect(ResourceType.fromName('fertilizer'), ResourceType.fertilizer);
  });

  test('unknown or null name falls back to energy', () {
    expect(ResourceType.fromName('banana'), ResourceType.energy);
    expect(ResourceType.fromName(null), ResourceType.energy);
  });

  test('enum order matches the tab labels', () {
    expect(ResourceType.values.map((t) => t.name).toList(), [
      'energy',
      'water',
      'fertilizer',
    ]);
  });
}
