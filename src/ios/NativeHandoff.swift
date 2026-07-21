import Foundation

@objc(NativeHandoff)
class NativeHandoff: CDVPlugin {

    @objc(set:)
    func set(_ command: CDVInvokedUrlCommand) {
        guard let key = command.argument(at: 0) as? String,
              let value = command.argument(at: 1) as? String else {
            commandDelegate.send(
                CDVPluginResult(status: .error, messageAs: "Invalid arguments: key and value must be strings"),
                callbackId: command.callbackId
            )
            return
        }
        UserDefaults.standard.set(value, forKey: key)
        commandDelegate.send(CDVPluginResult(status: .ok), callbackId: command.callbackId)
    }

    @objc(remove:)
    func remove(_ command: CDVInvokedUrlCommand) {
        guard let key = command.argument(at: 0) as? String else {
            commandDelegate.send(
                CDVPluginResult(status: .error, messageAs: "Invalid arguments: key must be a string"),
                callbackId: command.callbackId
            )
            return
        }
        UserDefaults.standard.removeObject(forKey: key)
        commandDelegate.send(CDVPluginResult(status: .ok), callbackId: command.callbackId)
    }
}
