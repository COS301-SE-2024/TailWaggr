import 'package:flutter_test/flutter_test.dart';
import '.cos301_capstone/test_function.dart';

void main() {
    test('Test add function', () {
        // Arrange
        var a = 5;
        var b = 7;
        var expected = 12;

        // Act
        var result = add(a, b); // Call the function you want to test

        // Assert
        expect(result, expected);
    });
}