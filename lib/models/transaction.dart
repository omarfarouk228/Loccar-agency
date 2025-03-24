class ModelTransaction {
  late int id, ownerState;
  late String marque, model, plaque, nomConducteur, dateTransaction, source;
  late int type, cardId;
  late double montant;

  ModelTransaction(
      {required this.id,
      required this.marque,
      required this.model,
      required this.plaque,
      required this.cardId,
      required this.nomConducteur,
      required this.dateTransaction,
      required this.source,
      required this.montant,
      required this.ownerState,
      required this.type});
}
