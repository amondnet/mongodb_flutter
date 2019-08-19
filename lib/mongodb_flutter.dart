import 'dart:async';

import 'package:bson/bson.dart';
import 'package:flutter/services.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:mongo_dart_query/mongo_dart_query.dart';

class MongodbMobile {
  static const MethodChannel _channel =
      const MethodChannel('amond.dev/mongodb_flutter');

  static Future<String> setAppId(dynamic config) async {
    final res = await _channel.invokeMethod('setAppId', config);
    return res;
  }

  static DbCollection getCollection(String db, String collection) {
    return DbCollection(_channel, db, collection);
  }
}

class DbCollection {
  String db;
  String collectionName;
  MethodChannel _channel;

  DbCollection(this._channel, this.db, this.collectionName);

  String fullName() => "$db.$collectionName";

  Future<void> save(Map<String, dynamic> document,
      {WriteConcern writeConcern}) {
    var id;
    bool createId = false;
    if (document.containsKey("_id")) {
      id = document["_id"];
      if (id == null) {
        createId = true;
      }
    }
    if (id != null) {
      return update({"_id": id}, document,
          upsert: true, writeConcern: writeConcern);
    } else {
      if (createId) {
        document["_id"] = ObjectId();
      }
      return insert(document, writeConcern: writeConcern);
    }
  }

  Future<Map<String, dynamic>> update(selector, document,
      {bool upsert = false,
      bool multiUpdate = false,
      WriteConcern writeConcern}) {
    return Future.sync(() {
      int flags = 0;
      if (upsert) {
        flags |= 0x1;
      }
      if (multiUpdate) {
        flags |= 0x2;
      }
      MongoUpdateMessage message = MongoUpdateMessage(
          fullName(), _selectorBuilder2Map(selector), document, flags);

      return _channel.invokeMethod('update', writeConcern);
    });
  }

  Future<Map<String, dynamic>> insertAll(List<Map<String, dynamic>> documents,
      {WriteConcern writeConcern}) {
    return Future.sync(() {
      MongoInsertMessage insertMessage =
          MongoInsertMessage(fullName(), documents);
      // ByteArraty insertMessage.serialize().byteArray
      return _channel.invokeMethod('insertAll', insertMessage);
    });
  }

  Future<void> insertOne(Map<String, dynamic> document,
      {WriteConcern writeConcern}) async {
    return await _channel.invokeMethod('insert', document);
  }

  Map<String, dynamic> _selectorBuilder2Map(selector) {
    if (selector == null) {
      return <String, dynamic>{};
    }
    if (selector is SelectorBuilder) {
      return selector.map['\$query'] as Map<String, dynamic>;
    }
    return selector as Map<String, dynamic>;
  }
}
