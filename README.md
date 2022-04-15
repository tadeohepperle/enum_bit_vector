# EnumBitVector - Datatype storing a set of enum values as a 64-bit integer.
## Motivation:
Often we want to store a set of flags/labels. For examples which super powers a super hero has, what permissions a user has, or what labels a food item posesses.
All those use cases can be represented by a set of enums:
```dart
enum SuperPowers { flying, speed, resistance, psychic, wealth}
batman.superPowers = {SuperPowers.wealth, SuperPowers.flying };

enum Permissions { deleteFiles, inviteOthers, createMeetings}
user1.permissions = { Permissions.inviteOthers };

enum FoodLabels {vegan, vegetarian, containsNuts, ketoFriendly}
carrotLabels = {FoodLabels.vegan, FoodLabels.vegetarian, FoodLabels.ketoFriendly};
```
If we store large quantities of data it could be inefficient to store these values as a List of Strings or even a Map of Strings to Booleans in json like this:

```json
{
  "title": "carrot",
  "foodLabels": {
    "FoodLabels.vegan": true,
    "FoodLabels.vegetarian": true,
    "FoodLabels.containsNuts": false,
    "FoodLabels.ketoFriendly": true
  }
}
```
Instead, in Dart we could use a 64-bit integer to represent up to 64 boolean values: As long as our enum contains at most 64 values we can fit them all into one int, which can be represented as a hexadecimal string in just 8 characters.
## How to use:
1. Register the Enum Type you want to create `EnumBitVectors` for. This has to happen only once during the runtime of the program, but **before** you first use the data type anywhere.
```dart
EnumBitVector.registerEnum(SuperPowers.values);
```
2. Create an `EnumBitVector` from a set or list of enums, an int or a hexString:
```dart
enumBitVector = EnumBitVector.fromSet({SuperPowers.flying, SuperPowers.resistance, SuperPowers.psychic});
enumBitVector = EnumBitVector.fromList([SuperPowers.flying, SuperPowers.resistance, SuperPowers.psychic]);
enumBitVector = EnumBitVector.fromInt(13); 
enumBitVector = EnumBitVector.fromHexString('0000000d');
```
### Access values:
you can easily convert an `EnumBitVector` to a set or list of enums, to an int or a hexString again, whenever needed:
```dart
enumBitVector.toSet() // => {SuperPowers.flying, SuperPowers.resistance, SuperPowers.psychic}
enumBitVector.enumSet // => {SuperPowers.flying, SuperPowers.resistance, SuperPowers.psychic}
enumBitVector.toList() // => [SuperPowers.flying, SuperPowers.resistance, SuperPowers.psychic]
enumBitVector.toInt() // => 13
enumBitVector.value // => 13
enumBitVector.toBinarytring()  // => '0000000000000000000000000000000000000000000000000000000001101';
enumBitVector.toHexString()  // => '0000000d';
```
### JSON-conversion:
```dart
final json = enumBitVector.toJson();
// json will be {'v': 13}
final bitVector = EnumBitVector<SuperPowers>.fromJson({'v': 13});
// will create a bitvector with int-value 13.
```
### Print an EnumBitVector<T>

```dart
enumBitVector = EnumBitVector.fromSet({SuperPowers.flying, SuperPowers.resistance, SuperPowers.psychic});
print(enumBitVector);
// prints: EnumBitVector<SuperPowers>(0000000000000000000000000000000000000000000000000000000000001101 = {SuperPowers.flying, SuperPowers.resistance, SuperPowers.psychic})
```
