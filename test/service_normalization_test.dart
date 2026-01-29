import 'package:flutter_test/flutter_test.dart';
import 'package:garasifyy_mobile/services/firestore_service.dart';

void main() {
  group('FirestoreService Normalization', () {
    test('Should normalize admin web data correctly', () {
      final input = {
        'name': 'Admin Service',
        'category': 'Performance',
        'basePrice': 1000000,
        'includes': ['Feature A', 'Feature B'],
        'duration': '2 Jam',
        // Missing icons/colors/packages explicitly
      };

      final output = FirestoreService.normalizeServiceData(input);

      // Check title mapping
      expect(output['title'], 'Admin Service');
      
      // Check default icon/color mapping
      expect(output['iconCode'], isNotNull);
      expect(output['colorValue'], isNotNull);
      
      // Check package generation
      expect(output['packages'], isA<List>());
      final packages = output['packages'] as List;
      expect(packages.length, 1);
      expect(packages[0]['name'], 'Layanan Standar');
      expect(packages[0]['price'], 'Rp 1.000.000');
      expect((packages[0]['features'] as List).length, 2);
    });

    test('Should respect existing mobile app data', () {
      final input = {
        'title': 'Existing Service',
        'iconCode': 12345,
        'colorValue': 0xFF000000,
        'packages': [
          {'name': 'Custom', 'price': 'Rp 500rb', 'features': []}
        ]
      };

      final output = FirestoreService.normalizeServiceData(input);

      expect(output['title'], 'Existing Service');
      expect(output['iconCode'], 12345);
      expect((output['packages'] as List).length, 1);
    });
  });
}
