import 'dart:convert';

import 'package:enum_bit_vector/enum_bit_vector.dart';
import 'package:test/test.dart';

enum SuperPowers { invisibility, speed, flying, immortality, resistance, psychic }

Future<void> main() async {
  final enumSet = {
    SuperPowers.invisibility,
    SuperPowers.flying,
    SuperPowers.immortality,
  };

  test(
    'should throw exception when enum type not registered',
    () async {
      // act
      EnumBitVector.unregisterAllEnums();
      void buildBitVectorIllegally() {
        EnumBitVector.fromSet({SuperPowers.speed});
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

      // act
      final enumBitVector = EnumBitVector.fromSet(enumSet);
      // assert
      expect(enumBitVector.toSet(), enumSet);
      expect(enumBitVector.toInt(), 0 + 0 + 0 + 0 + 8 + 4 + 0 + 1); // = 13
      expect(enumBitVector.toBinarytring().endsWith("00001101"), true);
      expect(enumBitVector.toHexString(), "0000000d"); // d is 13 in hex
    },
  );

  test(
    'should convert to and from json correctly',
    () async {
      // arrange
      EnumBitVector.registerEnum(SuperPowers.values);
      final enumBitVector = EnumBitVector.fromSet(enumSet);
      // act
      final enumBitVector2Json = enumBitVector.toJson();
      final enumBitVector2JsonString = jsonEncode(enumBitVector2Json);
      final enumBitVector2 = EnumBitVector<SuperPowers>.fromJson(jsonDecode(enumBitVector2JsonString));
      // assert
      expect(enumBitVector2Json, {'v': 13});
      expect(enumBitVector2JsonString, '{"v":13}');
      expect(enumBitVector2, enumBitVector);
    },
  );

  group('set operations', () {
    EnumBitVector.registerEnum(SuperPowers.values);
    // arrange
    final bv1 = EnumBitVector.fromSet({SuperPowers.flying, SuperPowers.immortality});
    final bv2 = EnumBitVector.fromSet({SuperPowers.flying, SuperPowers.resistance, SuperPowers.psychic});
    test(
      'should do substraction',
      () async {
        // assert
        expect(bv1 - bv2, EnumBitVector.fromSet({SuperPowers.immortality}));
        expect(bv1 - bv2, bv1.substract(bv2));
        expect((bv1 - bv1).value, 0);
      },
    );

    test(
      'should do union',
      () async {
        // arrange
        final union = EnumBitVector.fromSet({SuperPowers.flying, SuperPowers.resistance, SuperPowers.psychic, SuperPowers.immortality});
        // assert
        expect(bv1 + bv2, union);
        expect(bv1 + bv2, bv2 + bv1);
        expect(bv1 | bv2, union);
        expect(bv1 | bv2, bv2 | bv1);
        expect(bv1.union(bv2), union);
        expect(bv1.union(bv2), bv2.union(bv1));
      },
    );

    test(
      'should do intersection',
      () async {
        // arrange
        final intersection = EnumBitVector.fromSet({SuperPowers.flying});
        // assert
        expect(bv1 & bv2, intersection);
        expect(bv1 & bv2, bv2 & bv1);
        expect(bv1.intersection(bv2), intersection);
        expect(bv1.intersection(bv2), bv2.intersection(bv1));
      },
    );
  });

  test('should apply add and remove operations', () {
    EnumBitVector.registerEnum(SuperPowers.values);
    // arrange
    final bv1 = EnumBitVector.fromSet({SuperPowers.flying, SuperPowers.immortality});
    final bv2 = EnumBitVector.fromSet({SuperPowers.flying, SuperPowers.resistance, SuperPowers.psychic});
    // act
    bv1.remove(SuperPowers.immortality);
    expect(bv1, EnumBitVector.fromSet({SuperPowers.flying}));
    bv1.addAll([SuperPowers.resistance, SuperPowers.psychic]);
    expect(bv1, bv2);
  });
}
