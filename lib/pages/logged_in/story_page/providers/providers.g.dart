// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$questProgressHash() => r'2bb64333693bd88a67792925711e2a8c52d0e439';

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

/// See also [questProgress].
@ProviderFor(questProgress)
const questProgressProvider = QuestProgressFamily();

/// See also [questProgress].
class QuestProgressFamily extends Family<AsyncValue<QuestProgressModel>> {
  /// See also [questProgress].
  const QuestProgressFamily();

  /// See also [questProgress].
  QuestProgressProvider call(
    String storyId,
    Repository repository,
  ) {
    return QuestProgressProvider(
      storyId,
      repository,
    );
  }

  @override
  QuestProgressProvider getProviderOverride(
    covariant QuestProgressProvider provider,
  ) {
    return call(
      provider.storyId,
      provider.repository,
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
  String? get name => r'questProgressProvider';
}

/// See also [questProgress].
class QuestProgressProvider
    extends AutoDisposeFutureProvider<QuestProgressModel> {
  /// See also [questProgress].
  QuestProgressProvider(
    String storyId,
    Repository repository,
  ) : this._internal(
          (ref) => questProgress(
            ref as QuestProgressRef,
            storyId,
            repository,
          ),
          from: questProgressProvider,
          name: r'questProgressProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$questProgressHash,
          dependencies: QuestProgressFamily._dependencies,
          allTransitiveDependencies:
              QuestProgressFamily._allTransitiveDependencies,
          storyId: storyId,
          repository: repository,
        );

  QuestProgressProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.storyId,
    required this.repository,
  }) : super.internal();

  final String storyId;
  final Repository repository;

  @override
  Override overrideWith(
    FutureOr<QuestProgressModel> Function(QuestProgressRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: QuestProgressProvider._internal(
        (ref) => create(ref as QuestProgressRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        storyId: storyId,
        repository: repository,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<QuestProgressModel> createElement() {
    return _QuestProgressProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QuestProgressProvider &&
        other.storyId == storyId &&
        other.repository == repository;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, storyId.hashCode);
    hash = _SystemHash.combine(hash, repository.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin QuestProgressRef on AutoDisposeFutureProviderRef<QuestProgressModel> {
  /// The parameter `storyId` of this provider.
  String get storyId;

  /// The parameter `repository` of this provider.
  Repository get repository;
}

class _QuestProgressProviderElement
    extends AutoDisposeFutureProviderElement<QuestProgressModel>
    with QuestProgressRef {
  _QuestProgressProviderElement(super.provider);

  @override
  String get storyId => (origin as QuestProgressProvider).storyId;
  @override
  Repository get repository => (origin as QuestProgressProvider).repository;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
