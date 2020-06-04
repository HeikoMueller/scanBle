#import "ScanBlePlugin.h"
#if __has_include(<scanBle/scanBle-Swift.h>)
#import <scanBle/scanBle-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "scanBle-Swift.h"
#endif

@implementation ScanBlePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftScanBlePlugin registerWithRegistrar:registrar];
}
@end
