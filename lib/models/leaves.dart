


class Leaves {
  // Document Metadata (from ArangoDB/database)
  final String? key;
  final String? id;
  final String? rev;

  // Core Fields
  final String userKey;
  final int totalLeaves;
  final int availableLeaves;
  final int pendingLeaves;
  final int rejectedLeaves;

  // Constructor
  Leaves({
    this.key,
    this.id,
    this.rev,
    required this.userKey,
    required this.totalLeaves,
    required this.availableLeaves,
    required this.pendingLeaves,
    required this.rejectedLeaves,
  });

  // fromJson() Method
  factory Leaves.fromJson(Map<String, dynamic> json) {
    return Leaves(
      key: json['_key'] as String?,
      id: json['_id'] as String?,
      rev: json['_rev'] as String?,
      userKey: json['userKey'] as String,
      // Cast number types robustly, often API returns int/double
      totalLeaves: (json['totalLeaves'] as num).toInt(),
      availableLeaves: (json['availableLeaves'] as num).toInt(),
      pendingLeaves: (json['pendingLeaves'] as num).toInt(),
      rejectedLeaves: (json['rejectedLeaves'] as num).toInt(),
    );
  }

  // toJson() Method
  Map<String, dynamic> toJson() {
    return {
      "userKey": userKey,
      "totalLeaves": totalLeaves,
      "availableLeaves": availableLeaves,
      "pendingLeaves": pendingLeaves,
      "rejectedLeaves": rejectedLeaves,

      // Include metadata if needed for database updates/debugging
      if (key != null) "_key": key,
      if (id != null) "_id": id,
      if (rev != null) "_rev": rev,
    };
  }
}