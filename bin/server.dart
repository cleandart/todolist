import 'package:clean_sync/server.dart';
import 'package:clean_backend/clean_backend.dart';
import 'dart:async';
import 'package:clean_ajax/server.dart';
import 'package:crypto/crypto.dart';
import 'package:clean_router/common.dart';
import 'package:logging/logging.dart';


void main() {
  /**
   * Mongo daemon has to be running at its default port.
   * No authentification is used (/etc/mongodb.conf contains auth=false, which
   * is default value).
   * If authentification would be used:
   * url = 'mongodb://clean:clean@127.0.0.1:27017/clean';
   */

  hierarchicalLoggingEnabled = true;
  Logger.root.level = Level.WARNING;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.loggerName} ${rec.message} ${rec.error} ${rec.stackTrace}');
  });

  MongoDatabase mongodb = new MongoDatabase('mongodb://127.0.0.1:27017/clean');
//  mongodb.create_collection('item');
  Future.wait(mongodb.init).then((_) {

    publish('item', (_) {
      return mongodb.collection("item");
    });

    publish('order', (_) {
      return mongodb.collection("order");
    });

    runZoned((){
      Backend.bind('127.0.0.1', 8080, 'top-secret').then((backend) {
        backend.router.addRoute("static", new Route('/static/*'));
        backend.router.addRoute("resources", new Route('/resources/'));
        MultiRequestHandler requestHandler = new MultiRequestHandler();
        requestHandler.registerDefaultHandler(handleSyncRequest);
        backend.addStaticView('static', '../web');
        backend.addView('resources', requestHandler.handleHttpRequest);
      });
    }, onError: (e, s){
      Logger.root.shout('error', e, s);
    });
  });
}
