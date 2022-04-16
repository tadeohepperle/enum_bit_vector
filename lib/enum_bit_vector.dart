/// represents a set of enum values for the memory cost of an int (64 bit)
/// supports enums with up to 64 unique values.
class EnumBitVector<T extends Enum> {
  static final Map<Type, List<Enum>> _valueMap = {};

  /// Call this method for the [EnumType] want to create EnumBitVectors for.
  /// Call it **before** you create an EnumBitVector of said type.
  /// Otherwise exceptions will be thrown, when handling the BitVector.
  /// This method has to be called only once for each enum type you want to store.
  /// However, calling it multiple times does not do any harm.
  static void registerEnum<F extends Enum>(List<F> values) {
    _valueMap[F] = values;
  }

  static void unregisterAllEnums() {
    _valueMap.clear();
  }

  int _v;
  EnumBitVector._(
    this._v,
  );

  /// Constructs an EnumBitVector from an int.
  /// Make sure to call EnumBitVector.registerEnum<EnumType>(EnumType.values) before this operation!
  factory EnumBitVector.fromInt(int i) => EnumBitVector._(i);

  /// Constructs an EnumBitVector from a hex String, for example: '3b4700d9'
  /// Make sure to call EnumBitVector.registerEnum<EnumType>(EnumType.values) before this operation!
  factory EnumBitVector.fromHexString(String hexString) => EnumBitVector.fromInt(int.parse(hexString, radix: 16));

  /// Constructs an EnumBitVector from a set of enum values.
  /// Make sure to call EnumBitVector.registerEnum<EnumType>(EnumType.values) before this operation!
  factory EnumBitVector.fromSet(Set<T> set) => EnumBitVector.fromInt(_enumSetToInt(set));

  /// Constructs an EnumBitVector from a list of enum values.
  /// Make sure to call EnumBitVector.registerEnum<EnumType>(EnumType.values) before this operation!
  factory EnumBitVector.fromList(List<T> list) => EnumBitVector.fromSet(list.toSet());

  /// returns the set of enum values stored in the EnumBitVector
  Set<T> toSet() => _intToEnumSet(_v);

  /// returns the set of enum values stored in the EnumBitVector
  Set<T> get enumSet => toSet();

  /// returns the set of enum values stored in the EnumBitVector as a list
  List<T> toList() => toSet().toList();

  /// returns the int value stored in the EnumBitVector to represent a set of enum values.
  int toInt() => _v;
  int get value => _v;

  /// union of both enum sets
  EnumBitVector<T> operator +(EnumBitVector<T> other) => EnumBitVector._(_v | other.toInt());

  /// union of both enum sets
  EnumBitVector<T> union(EnumBitVector<T> other) => this + other;

  /// union of both enum sets
  EnumBitVector<T> operator |(EnumBitVector<T> other) => this + other;

  /// enum set substraction: returns bitvector with all elements from this except all elements from the other.
  EnumBitVector<T> operator -(EnumBitVector<T> other) => EnumBitVector._(_v & ~other.toInt());

  /// enum set substraction: returns bitvector with all elements from this except all elements from the other.
  EnumBitVector<T> substract(EnumBitVector<T> other) => this - other;

  /// intersection of both enum sets
  EnumBitVector<T> operator &(EnumBitVector<T> other) => EnumBitVector._(_v & other.toInt());

  /// intersection of both enum sets
  EnumBitVector<T> intersection(EnumBitVector<T> other) => this & other;

  @override
  bool operator ==(dynamic other) => other is EnumBitVector<T> && other.value == _v;

  @override
  int get hashCode => _v.hashCode;

  @override
  String toString() => 'EnumBitVector<$T>(${toBinaryString()} = ${toSet()})';

  String toBinaryString() => _v.toRadixString(2).padLeft(64, '0');

  String toHexString() => _v.toRadixString(16).padLeft(8, '0');

  /// add an element to the set the EnumBitVector represents
  void add(T element) {
    _v |= 1 << element.index;
  }

  /// add multiple elements to the set the EnumBitVector represents
  void addAll(Iterable<T> elements) {
    for (var e in elements) {
      add(e);
    }
  }

  /// remove an element to the set the EnumBitVector represents
  void remove(T element) {
    _v &= ~(1 << element.index);
  }

  /// remove multiple elements to the set the EnumBitVector represents
  void removeAll(Iterable<T> elements) {
    for (var e in elements) {
      remove(e);
    }
  }

  /// Constructs an EnumBitVector from a json Map<String,dynamic> like this: {"v": 2647}
  factory EnumBitVector.fromJson(Map<String, dynamic> json) => EnumBitVector.fromInt(json['v'] as int);

  // Converts an EnumBitVector to a json Map<String,dynamic> like this: {"v": 2647}
  Map<String, dynamic> toJson() => {'v': _v};

  /// conversion logic enum set --> int
  static int _enumSetToInt<F extends Enum>(Set<F> enumSet) {
    final values = _valueMap[F];
    if (values == null) _throwUnregisteredException<F>();
    int val = 0;
    for (var i = 0; i < values!.length; i++) {
      val |= (enumSet.contains(values[i]) ? 1 << i : 0);
    }
    return val;
  }

  /// conversion logic int --> enum set
  static Set<F> _intToEnumSet<F extends Enum>(int value) {
    final values = _valueMap[F];
    if (values == null) _throwUnregisteredException<F>();
    Set<F> enumSet = {};
    for (var i = 0; i < values!.length; i++) {
      if ((value & (1 << i)) != 0) {
        enumSet.add(values[i] as F);
      }
    }
    return enumSet;
  }

  static _throwUnregisteredException<F extends Enum>() =>
      throw Exception('Enum Type $F not registered! Please register Enum Values with EnumBitVector.registerEnum<$F>($F.values)');
}
