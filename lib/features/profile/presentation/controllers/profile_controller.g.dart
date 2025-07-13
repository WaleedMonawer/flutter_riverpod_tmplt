// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$loadProfileActionHash() => r'da25ba27b844713e093d2f9b393b349290828666';

/// See also [loadProfileAction].
@ProviderFor(loadProfileAction)
final loadProfileActionProvider = AutoDisposeFutureProvider<void>.internal(
  loadProfileAction,
  name: r'loadProfileActionProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$loadProfileActionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LoadProfileActionRef = AutoDisposeFutureProviderRef<void>;
String _$updateProfileActionHash() =>
    r'e821c5821f39c6910909294b413d18292130de26';

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

/// See also [updateProfileAction].
@ProviderFor(updateProfileAction)
const updateProfileActionProvider = UpdateProfileActionFamily();

/// See also [updateProfileAction].
class UpdateProfileActionFamily extends Family<AsyncValue<void>> {
  /// See also [updateProfileAction].
  const UpdateProfileActionFamily();

  /// See also [updateProfileAction].
  UpdateProfileActionProvider call({
    required String u_name,
    required String email,
  }) {
    return UpdateProfileActionProvider(u_name: u_name, email: email);
  }

  @override
  UpdateProfileActionProvider getProviderOverride(
    covariant UpdateProfileActionProvider provider,
  ) {
    return call(u_name: provider.u_name, email: provider.email);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'updateProfileActionProvider';
}

/// See also [updateProfileAction].
class UpdateProfileActionProvider extends AutoDisposeFutureProvider<void> {
  /// See also [updateProfileAction].
  UpdateProfileActionProvider({required String u_name, required String email})
    : this._internal(
        (ref) => updateProfileAction(
          ref as UpdateProfileActionRef,
          u_name: u_name,
          email: email,
        ),
        from: updateProfileActionProvider,
        name: r'updateProfileActionProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$updateProfileActionHash,
        dependencies: UpdateProfileActionFamily._dependencies,
        allTransitiveDependencies:
            UpdateProfileActionFamily._allTransitiveDependencies,
        u_name: u_name,
        email: email,
      );

  UpdateProfileActionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.u_name,
    required this.email,
  }) : super.internal();

  final String u_name;
  final String email;

  @override
  Override overrideWith(
    FutureOr<void> Function(UpdateProfileActionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateProfileActionProvider._internal(
        (ref) => create(ref as UpdateProfileActionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        u_name: u_name,
        email: email,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _UpdateProfileActionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateProfileActionProvider &&
        other.u_name == u_name &&
        other.email == email;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, u_name.hashCode);
    hash = _SystemHash.combine(hash, email.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UpdateProfileActionRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `u_name` of this provider.
  String get u_name;

  /// The parameter `email` of this provider.
  String get email;
}

class _UpdateProfileActionProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with UpdateProfileActionRef {
  _UpdateProfileActionProviderElement(super.provider);

  @override
  String get u_name => (origin as UpdateProfileActionProvider).u_name;
  @override
  String get email => (origin as UpdateProfileActionProvider).email;
}

String _$profileControllerHash() => r'5457afbdc2bc2b965ad6ca81c6132175f40fc9eb';

/// See also [ProfileController].
@ProviderFor(ProfileController)
final profileControllerProvider =
    AutoDisposeNotifierProvider<ProfileController, ProfileState>.internal(
      ProfileController.new,
      name: r'profileControllerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$profileControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ProfileController = AutoDisposeNotifier<ProfileState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
