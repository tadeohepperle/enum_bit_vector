import 'package:enum_bit_vector/enum_bit_vector.dart';

enum SuperPowers { invisibility, speed, flying, immortality, resistance, psychic }

void main(List<String> arguments) {
  EnumBitVector.registerEnum(SuperPowers.values);
  final enumSet = {
    SuperPowers.flying,
    SuperPowers.resistance,
    SuperPowers.psychic,
  };
  print('enumSet: $enumSet');
  final enumBitVector = EnumBitVector.fromSet(enumSet);
  print('enumBitVector: $enumBitVector');
  print('enumBitVector to int: ${enumBitVector.toInt()}');
  print('enumBitVector to set: ${enumBitVector.toSet()}');
  print('enumBitVector to list: ${enumBitVector.toList()}');
}
