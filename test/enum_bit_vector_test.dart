import 'package:enum_bit_vector/enum_bit_vector.dart';
import 'package:test/test.dart';

enum SuperPowers { invisibility, speed, flying, immortality, resistance, psychic }

Future<void> main() async {
  test(
    'should throw exception when enum type not registered',
    () async {
      // act
      void buildBitVectorIllegally() {
        final enumBitVector = EnumBitVector.fromSet({SuperPowers.speed});
      }

      // assert
      expect(buildBitVectorIllegally, throwsA(isA<Exception>()));
    },
  );

  test(
    'should construct bitvector correctly',
    () async {
      // arrange
      EnumBitVector.registerEnum(SuperPowers.values);
      final enumSet = {
        SuperPowers.invisibility,
        SuperPowers.flying,
        SuperPowers.immortality,
      };
      // act
      final enumBitVector = EnumBitVector.fromSet(enumSet);
      // assert
      expect(enumBitVector.toSet(), enumSet);
      expect(enumBitVector.toInt(), 0 + 0 + 0 + 0 + 8 + 4 + 0 + 1);
      expect(enumBitVector.toRadixString().endsWith("00001101"), true);
    },
  );
}
