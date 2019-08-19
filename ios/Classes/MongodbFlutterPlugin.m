#import "MongodbFlutterPlugin.h"
#import <mongodb_mobile/mongodb_mobile-Swift.h>

@implementation MongodbFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMongodbMobilePlugin registerWithRegistrar:registrar];
}
@end
