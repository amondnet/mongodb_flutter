class MongoMessage {}

class MongoInsertOneMessage {
  final Map<String, dynamic> document;

  MongoInsertOneMessage(this.document);
}
