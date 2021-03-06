import Flutter
import UIKit
import CoreBluetooth


public class SwiftScanBlePlugin: NSObject, FlutterPlugin, FlutterStreamHandler, CBCentralManagerDelegate {
    
    // MARK: - Private properties
    private var centralManager: CBCentralManager?
    private var cbuuids: Array<CBUUID>?
    private var eventSink: FlutterEventSink?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftScanBlePlugin()
        let methodChannel = FlutterMethodChannel(name: "roktok.immu.dev/bluetoothScanner",
                                                  binaryMessenger: registrar.messenger())
        let eventChannel = FlutterEventChannel(name: "roktok.immu.dev/bluetoothScannerResponse",
                                               binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(instance)
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
    }
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch (call.method) {
            case "startScanning":
                startScan(call, result)
            case "stopScanning":
                stopScan(call, result)
            default:
                result(FlutterMethodNotImplemented)
      }
  }

    public func onListen(withArguments arguments: Any?,
                         eventSink: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = eventSink
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
    func stopScan(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        print("XCODE : STOP SCAN CALLED");
        centralManager?.stopScan()
        result(nil)
    }

    func startScan(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        print("XCODE start scan called")
        let uuids = call.arguments as! Array<String>
        self.cbuuids = uuids.map({ (uuid) -> CBUUID in
            return CBUUID(string: uuid);
        })
        // turn scanning on
        centralManager = CBCentralManager(delegate: self, queue: nil,
                                          options:[CBCentralManagerOptionRestoreIdentifierKey: "roktok.immu.dev"])
        result(nil)
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("XCODE : SOMETHING DETECTED");

        // put all discoverd peripherals in a dictioniary with identifier as key, defined in Bluetooth Manager
        peripherals[peripheral.identifier] = peripheral
    }
    public func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        
    }

    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("XCODE centralManagerDidUpdateState")
        if central.state == .poweredOn {
            central.scanForPeripherals(withServices: cbuuids)
        } else {
            // Error handlling
        }
    }
    
    private(set) var peripherals = Dictionary<UUID, CBPeripheral>() {
        didSet {
            print("XCODE PERIPHERALS SET")
            if (self.eventSink != nil) {
                self.eventSink!(peripherals)
            }
        }
    }
 
}
