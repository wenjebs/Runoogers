// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$routeHash() => r'837fecc967cba4c2122b430e84e9f09cbf9dccf0';

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

/// See also [route].
@ProviderFor(route)
const routeProvider = RouteFamily();

/// See also [route].
class RouteFamily extends Family<AsyncValue<Set<Object>>> {
  /// See also [route].
  const RouteFamily();

  /// See also [route].
  RouteProvider call(
    int seed,
  ) {
    return RouteProvider(
      seed,
    );
  }

  @override
  RouteProvider getProviderOverride(
    covariant RouteProvider provider,
  ) {
    return call(
      provider.seed,
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
  String? get name => r'routeProvider';
}

/// See also [route].
class RouteProvider extends AutoDisposeFutureProvider<Set<Object>> {
  /// See also [route].
  RouteProvider(
    int seed,
  ) : this._internal(
          (ref) => route(
            ref as RouteRef,
            seed,
          ),
          from: routeProvider,
          name: r'routeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$routeHash,
          dependencies: RouteFamily._dependencies,
          allTransitiveDependencies: RouteFamily._allTransitiveDependencies,
          seed: seed,
        );

  RouteProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.seed,
  }) : super.internal();

  final int seed;

  @override
  Override overrideWith(
    FutureOr<Set<Object>> Function(RouteRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RouteProvider._internal(
        (ref) => create(ref as RouteRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        seed: seed,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Set<Object>> createElement() {
    return _RouteProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RouteProvider && other.seed == seed;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, seed.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RouteRef on AutoDisposeFutureProviderRef<Set<Object>> {
  /// The parameter `seed` of this provider.
  int get seed;
}

class _RouteProviderElement
    extends AutoDisposeFutureProviderElement<Set<Object>> with RouteRef {
  _RouteProviderElement(super.provider);

  @override
  int get seed => (origin as RouteProvider).seed;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
