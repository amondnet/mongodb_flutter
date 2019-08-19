package kr.dietfriends.mongodb

import com.mongodb.MongoException
import com.mongodb.client.MongoClient
import com.mongodb.client.MongoCollection
import com.mongodb.client.MongoDatabase
import com.mongodb.stitch.android.core.Stitch
import com.mongodb.stitch.android.core.StitchAppClient
import com.mongodb.stitch.android.services.mongodb.local.LocalMongoDbService
import com.mongodb.stitch.android.services.mongodb.remote.RemoteMongoClient
import com.mongodb.stitch.android.services.mongodb.remote.RemoteMongoCollection
import com.mongodb.stitch.android.services.mongodb.remote.RemoteMongoDatabase
import com.mongodb.stitch.core.services.mongodb.local.internal.LocalMongoClientFactory
import io.flutter.plugin.common.FlutterException
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import org.bson.Document

class MongodbMobilePlugin : MethodCallHandler {

  var client: StitchAppClient? = null
  var remoteClient : RemoteMongoClient? = null
  var localClient: MongoClient? = null
  var database: MongoDatabase? = null

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "mongodb_flutter")
      channel.setMethodCallHandler(MongodbMobilePlugin())
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {

    when (call.method) {
      "Stitch#initializeDefaultAppClient" -> {

      }
      "StitchAppClient#getServiceClient" -> {
        val arguments = call.arguments as Map<String, Any>


      }
    }

    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if (call.method == "insertOne") {
      val arguments = call.arguments as Map<String, Any>
      val type = arguments["type"] as String
      val doc = arguments["document"] as Map<String, Any>
      val document = Document(doc)
      try {
      if ( type == "local") {
        getRemoteCollection(arguments).insertOne(document)
      } else {
        getLocalCollection(arguments).insertOne(document)
      }
      result.success(null)
      } catch (e: MongoException) {
        result.error("${e.code}", e.message, e.stackTrace)
      }
    } else {
      result.notImplemented()
    }
  }

  private fun getClient(arguments: Map<String, Any>): StitchAppClient {
    val appId = arguments["appId"] as String
    if ( client == null) {
      client =  Stitch.initializeAppClient(appId)
    }
    return client!!
  }

  private fun getRemoteMongo(arguments: Map<String, Any>) : RemoteMongoClient {
    return getClient(arguments).getServiceClient(RemoteMongoClient.factory, "mongodb-atlas")
  }

  private fun getLocalMongo(arguments: Map<String, Any>) : MongoClient {
    return getClient(arguments).getServiceClient(LocalMongoDbService.clientFactory)
  }

  private fun getRemoteDB(arguments: Map<String, Any>): RemoteMongoDatabase {
    val db = arguments["db"] as String
    return getRemoteMongo(arguments).getDatabase(db)
  }

  private fun getLocalDB(arguments: Map<String, Any>): MongoDatabase {
    val db = arguments["db"] as String
    return getLocalMongo(arguments).getDatabase(db)
  }

  private fun getLocalCollection(arguments: Map<String, Any> ): MongoCollection<Document> {
    val collection = arguments["collection"] as String
    return getLocalDB(arguments).getCollection(collection);
  }

  private fun getRemoteCollection(arguments: Map<String, Any> ): RemoteMongoCollection<Document> {
    val collection = arguments["collection"] as String
    return getRemoteDB(arguments).getCollection(collection);
  }

  private fun authorize( email: String, password: String ) {

  }
}
