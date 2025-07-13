// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$asyncCounterHash() => r'e8741d827376693db2c5567e037ec4dd29e0e311';

/// See also [asyncCounter].
@ProviderFor(asyncCounter)
final asyncCounterProvider = AutoDisposeFutureProvider<int>.internal(
  asyncCounter,
  name: r'asyncCounterProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$asyncCounterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AsyncCounterRef = AutoDisposeFutureProviderRef<int>;
String _$counterWithOffsetHash() => r'f688dbe8b332eb8512eb0c8917ce7594ad15ead7';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [counterWithOffset].
@ProviderFor(counterWithOffset)
const counterWithOffsetProvider = CounterWithOffsetFamily();

/// See also [counterWithOffset].
class CounterWithOffsetFamily extends Family<int> {
  /// See also [counterWithOffset].
  const CounterWithOffsetFamily();

  /// See also [counterWithOffset].
  CounterWithOffsetProvider call(int offset) {
    return CounterWithOffsetProvider(offset);
  }

  @override
  CounterWithOffsetProvider getProviderOverride(
    covariant CounterWithOffsetProvider provider,
  ) {
    return call(provider.offset);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'counterWithOffsetProvider';
}

/// See also [counterWithOffset].
class CounterWithOffsetProvider extends AutoDisposeProvider<int> {
  /// See also [counterWithOffset].
  CounterWithOffsetProvider(int offset)
    : this._internal(
        (ref) => counterWithOffset(ref as CounterWithOffsetRef, offset),
        from: counterWithOffsetProvider,
        name: r'counterWithOffsetProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$counterWithOffsetHash,
        dependencies: CounterWithOffsetFamily._dependencies,
        allTransitiveDependencies:
            CounterWithOffsetFamily._allTransitiveDependencies,
        offset: offset,
      );

  CounterWithOffsetProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.offset,
  }) : super.internal();

  final int offset;

  @override
  Override overrideWith(int Function(CounterWithOffsetRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: CounterWithOffsetProvider._internal(
        (ref) => create(ref as CounterWithOffsetRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        offset: offset,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<int> createElement() {
    return _CounterWithOffsetProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CounterWithOffsetProvider && other.offset == offset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, offset.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CounterWithOffsetRef on AutoDisposeProviderRef<int> {
  /// The parameter `offset` of this provider.
  int get offset;
}

class _CounterWithOffsetProviderElement extends AutoDisposeProviderElement<int>
    with CounterWithOffsetRef {
  _CounterWithOffsetProviderElement(super.provider);

  @override
  int get offset => (origin as CounterWithOffsetProvider).offset;
}

String _$counterTextHash() => r'fc7aee80256731857b2aac54f58e456ad8f2b1f2';

/// See also [counterText].
@ProviderFor(counterText)
final counterTextProvider = AutoDisposeProvider<String>.internal(
  counterText,
  name: r'counterTextProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$counterTextHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CounterTextRef = AutoDisposeProviderRef<String>;
String _$counterControllerHash() => r'0a3d6890575cccd7565bcfb31a569bfb75f206cd';

/// See also [CounterController].
@ProviderFor(CounterController)
final counterControllerProvider =
    AutoDisposeNotifierProvider<CounterController, int>.internal(
      CounterController.new,
      name: r'counterControllerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$counterControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CounterController = AutoDisposeNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
