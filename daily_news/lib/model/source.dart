class Source {
    String id;
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