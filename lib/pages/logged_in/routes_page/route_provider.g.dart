// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$routeHash() => r'461f11b7b55c0dae9ecdd8ab662c2379de957036';

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
    int distance,
  ) {
    return RouteProvider(
      seed,
      distance,
    );
  }

  @override
  RouteProvider getProviderOverride(
    covariant RouteProvider provider,
  ) {
    return call(
      provider.seed,
      provider.distance,
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
    int distance,
  ) : this._internal(
          (ref) => route(
            ref as RouteRef,
            seed,
            distance,
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
          distance: distance,
        );

  RouteProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.seed,
    required this.distance,
  }) : super.internal();

  final int seed;
  final int distance;

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
        distance: distance,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Set<Object>> createElement() {
    return _RouteProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RouteProvider &&
        other.seed == seed &&
        other.distance == distance;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, seed.hashCode);
    hash = _SystemHash.combine(hash, distance.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin RouteRef on AutoDisposeFutureProviderRef<Set<Object>> {
  /// The parameter `seed` of this provider.
  int get seed;

  /// The parameter `distance` of this provider.
  int get distance;
}

class _RouteProviderElement
    extends AutoDisposeFutureProviderElement<Set<Object>> with RouteRef {
  _RouteProviderElement(super.provider);

  @override
  int get seed => (origin as RouteProvider).seed;
  @override
  int get distance => (origin as RouteProvider).distance;
}

String _$pointsRouteHash() => r'03845c5636d0323ac0cb2f31b6f7d189266eafa2';

/// See also [pointsRoute].
@ProviderFor(pointsRoute)
const pointsRouteProvider = PointsRouteFamily();

/// See also [pointsRoute].
class PointsRouteFamily extends Family<AsyncValue<List<LatLng>>> {
  /// See also [pointsRoute].
  const PointsRouteFamily();

  /// See also [pointsRoute].
  PointsRouteProvider call(
    Set<Marker> markers,
  ) {
    return PointsRouteProvider(
      markers,
    );
  }

  @override
  PointsRouteProvider getProviderOverride(
    covariant PointsRouteProvider provider,
  ) {
    return call(
      provider.markers,
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
  String? get name => r'pointsRouteProvider';
}

/// See also [pointsRoute].
class PointsRouteProvider extends AutoDisposeFutureProvider<List<LatLng>> {
  /// See also [pointsRoute].
  PointsRouteProvider(
    Set<Marker> markers,
  ) : this._internal(
          (ref) => pointsRoute(
            ref as PointsRouteRef,
            markers,
          ),
          from: pointsRouteProvider,
          name: r'pointsRouteProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$pointsRouteHash,
          dependencies: PointsRouteFamily._dependencies,
          allTransitiveDependencies:
              PointsRouteFamily._allTransitiveDependencies,
          markers: markers,
        );

  PointsRouteProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.markers,
  }) : super.internal();

  final Set<Marker> markers;

  @override
  Override overrideWith(
    FutureOr<List<LatLng>> Function(PointsRouteRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PointsRouteProvider._internal(
        (ref) => create(ref as PointsRouteRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        markers: markers,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<LatLng>> createElement() {
    return _PointsRouteProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PointsRouteProvider && other.markers == markers;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, markers.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PointsRouteRef on AutoDisposeFutureProviderRef<List<LatLng>> {
  /// The parameter `markers` of this provider.
  Set<Marker> get markers;
}

class _PointsRouteProviderElement
    extends AutoDisposeFutureProviderElement<List<LatLng>> with PointsRouteRef {
  _PointsRouteProviderElement(super.provider);

  @override
  Set<Marker> get markers => (origin as PointsRouteProvider).markers;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
