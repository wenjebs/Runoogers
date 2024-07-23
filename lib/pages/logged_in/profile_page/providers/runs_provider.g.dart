// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'runs_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getRunsHash() => r'3cc44c5954c285640920856e4955c12931dc3e4a';

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

/// See also [getRuns].
@ProviderFor(getRuns)
const getRunsProvider = GetRunsFamily();

/// See also [getRuns].
class GetRunsFamily extends Family<AsyncValue<QuerySnapshot>> {
  /// See also [getRuns].
  const GetRunsFamily();

  /// See also [getRuns].
  GetRunsProvider call(
    String userId,
  ) {
    return GetRunsProvider(
      userId,
    );
  }

  @override
  GetRunsProvider getProviderOverride(
    covariant GetRunsProvider provider,
  ) {
    return call(
      provider.userId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getRunsProvider';
}

/// See also [getRuns].
class GetRunsProvider extends AutoDisposeFutureProvider<QuerySnapshot> {
  /// See also [getRuns].
  GetRunsProvider(
    String userId,
  ) : this._internal(
          (ref) => getRuns(
            ref as GetRunsRef,
            userId,
          ),
          from: getRunsProvider,
          name: r'getRunsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getRunsHash,
          dependencies: GetRunsFamily._dependencies,
          allTransitiveDependencies: GetRunsFamily._allTransitiveDependencies,
          userId: userId,
        );

  GetRunsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    FutureOr<QuerySnapshot> Function(GetRunsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetRunsProvider._internal(
        (ref) => create(ref as GetRunsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<QuerySnapshot> createElement() {
    return _GetRunsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetRunsProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetRunsRef on AutoDisposeFutureProviderRef<QuerySnapshot> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _GetRunsProviderElement
    extends AutoDisposeFutureProviderElement<QuerySnapshot> with GetRunsRef {
  _GetRunsProviderElement(super.provider);

  @override
  String get userId => (origin as GetRunsProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
