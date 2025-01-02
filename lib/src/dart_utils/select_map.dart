extension SelectFields on Map<String, dynamic> {
  /// Selects values in a map, if any match the given [paths].
  ///
  /// [paths] needs to be a list of strings with a . delimiter. The delimiter
  /// can be changed, if the keys also contain the delimiter.
  ///
  /// Selecting a child value from an inner map will automatically include the
  /// property that contains the full map, but only the inner map.
  ///
  /// Even for lists, you can select the objects internally if those objects
  /// are included. If the selector results in an empty list or empty map, it
  /// will automatically remove those from the returned value.
  ///
  Map<String, dynamic> select(
    List<String> paths, {
    String delimiter = ".",
    Map<String, List<String>>? preCalculatedSeperated,
  }) {
    Map<String, List<String>> seperateCurrent(List<String> paths) {
      final splitPaths = paths.map((item) => item.split(delimiter));
      return splitPaths.fold(<String, List<String>>{}, (map, split) {
        if (split.isEmpty) return map;
        final current = split.first;

        final remaining = split.sublist(1).join(delimiter);
        final currentMap = map[current] ??= [];
        if (remaining.isNotEmpty) {
          currentMap.add(remaining);
        }
        return map;
      });
    }

    final propertyJoinedPaths =
        preCalculatedSeperated ?? seperateCurrent(paths);

    dynamic handleChildren(String key, List<String> remainingPaths) {
      final value = this[key];

      if (remainingPaths.isEmpty) {
        return value;
      }

      if (value is Map<String, dynamic>) {
        final selected = value.select(
          remainingPaths,
        );
        if (selected.isEmpty) {
          return null;
        }

        return selected;
      }

      if (value is List) {
        final preCalculatedSeperated = seperateCurrent(remainingPaths);
        return value
            .whereType<Map<String, dynamic>>()
            .map(
              (item) => item.select(
                remainingPaths,
                preCalculatedSeperated: preCalculatedSeperated,
              ),
            )
            .where((item) => item.isNotEmpty)
            .toList();
      }

      return value;
    }

    final createdMap = {
      for (final entry in propertyJoinedPaths.entries)
        if (this[entry.key] != null)
          entry.key: handleChildren(entry.key, entry.value),
    };

    return createdMap;
  }
}

extension OmitFields on Map<String, dynamic> {
  Map<String, dynamic> omit(
    List<String> paths, {
    String delimiter = ".",
    Map<String, List<String>>? preCalculatedSeperated,
  }) {
    Map<String, List<String>> seperateCurrent(List<String> paths) {
      final splitPaths = paths.map((item) => item.split(delimiter));
      return splitPaths.fold(<String, List<String>>{}, (map, split) {
        if (split.isEmpty) return map;
        final current = split.first;

        final remaining = split.sublist(1).join(delimiter);
        final currentMap = map[current] ??= [];
        if (remaining.isNotEmpty) {
          currentMap.add(remaining);
        }
        return map;
      });
    }

    final separated = preCalculatedSeperated ?? seperateCurrent(paths);

    bool isOmitted(MapEntry<String, dynamic> entry) {
      final paths = separated[entry.key];

      if (paths == null) return false;
      if (paths.isNotEmpty) return false;
      return true;
    }

    dynamic handleChildren(MapEntry<String, dynamic> entry) {
      final paths = separated[entry.key];
      final value = entry.value;

      if (paths == null || paths.isEmpty) {
        return entry.value;
      }

      if (value is Map<String, dynamic>) {
        return value.omit(paths);
      }

      if (value is List) {
        final preCalculatedSeperated = seperateCurrent(paths);
        return value
            .whereType<Map<String, dynamic>>()
            .map(
              (item) => item.omit(
                paths,
                preCalculatedSeperated: preCalculatedSeperated,
              ),
            )
            .where((item) => item.isNotEmpty)
            .toList();
      }
      return value;
    }

    return {
      for (final entry in entries)
        if (!isOmitted(entry)) entry.key: handleChildren(entry),
    };
  }
}
