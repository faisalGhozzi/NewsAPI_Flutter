import 'package:hive/hive.dart';

part 'source.g.dart';

@HiveType(typeId: 1)
class Source extends HiveObject{
    @HiveField(0)
    String id;
    @HiveField(1)
    String name;

    Source({
        required this.id,
        required this.name,
    });

    factory Source.fromJson(Map<String, dynamic> json) => Source(
        id: json["id"] ?? "null",
        name: json["name"] ?? "null",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}