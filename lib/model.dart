class User {
  User({
    this.error,
    this.cards,
  });

  bool error;
  List<Cardss> cards;

  factory User.fromJson(Map<String, dynamic> json) => User(
    error: json["error"],
    cards: List<Cardss>.from(json["cardss"].map((x) => Cardss.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "cards": List<dynamic>.from(cards.map((x) => x.toJson())),
  };
}

class Cardss {
  Cardss({
    this.id,
    this.codeCard,
    this.nameCard,
  });

  int id;
  String codeCard;
  String nameCard;

  factory Cardss.fromJson(Map<String, dynamic> json) => Cardss(
    id: json["id"],
    codeCard: json["code_card"],
    nameCard: json["name_card"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code_card": codeCard,
    "name_card": nameCard,
  };
}
