#import <Cordova/CDVPlugin.h>

@interface NativeHandoff : CDVPlugin
- (void)set:(CDVInvokedUrlCommand*)command;
- (void)remove:(CDVInvokedUrlCommand*)command;
- (void)get:(CDVInvokedUrlCommand*)command;
@end

@implementation NativeHandoff

- (void)set:(CDVInvokedUrlCommand*)command {
    NSString* key = [command.arguments objectAtIndex:0];
    NSString* value = [command.arguments objectAtIndex:1];
    if (!key || !value) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                   messageAsString:@"Invalid arguments: key and value must be strings"];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)remove:(CDVInvokedUrlCommand*)command {
    NSString* key = [command.arguments objectAtIndex:0];
    if (!key) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                   messageAsString:@"Invalid arguments: key must be a string"];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)get:(CDVInvokedUrlCommand*)command {
    NSString* key = [command.arguments objectAtIndex:0];
    if (!key) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                   messageAsString:@"Invalid arguments: key must be a string"];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }
    NSString* value = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:value];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

@end
