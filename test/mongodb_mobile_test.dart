import 'package:bson/bson.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:mongodb_flutter/mongodb_flutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('mongodb_flutter');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    //expect(await MongodbMobile., '42');

    Map<String, dynamic> map = {"_id": "test", "value": 1};

    final message = MongoInsertMessage("test", [map]);

    final byteArray = message.serialize().byteList;

    print(byteArray);

    final de = BsonBinary.from(byteArray);
    print(de.value);
    print(de.typeByte);

    final ddd = MongoMessage().deserialize(de);

    print(ddd.opcode);
    if ( ddd.opcode == MongoMessage.Insert) {
      final MongoInsertMessage insertMessage = ddd;
      print(insertMessage.);

    }
  });
}
