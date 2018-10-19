//
//  AppPreferences.swift
//  Lo Asset
//
//  Created by Moustapha Kebe on 06/09/2018.
//  Copyright © 2018 Orange. All rights reserved.
//

import Foundation
import UIKit
class AppPreferences{
    var API_KEY : String = "apiKey"
    var AUTO_RECONNECT : Bool = false
    var MQTT_SERVER:String = "mqttServer"
    var MQTT_PROTOCOL:String = "mqttProtocol"
    var ASSET_RESSOURCE_PREFIX:String = "assetResource."
    var ASSET_NAMESPACE: String = UIDevice.current.modelName
    var assetId: String = ""
    func getUsernameDeviceMode() -> String {
        return "json+device"
    }
    
    func getStreamId() -> String {
        let userDefaults = UserDefaults.standard
        let idClientVal = userDefaults.string(forKey: "idClientValue")
//        return ASSET_NAMESPACE + "\(assetId)"
        return idClientVal ?? ASSET_NAMESPACE + "\(assetId)"
    }
    
    func getShortClientId() -> String {
        return ASSET_NAMESPACE + ":\(assetId)"
    }
    func getClientId() -> String {
        let userDefaults = UserDefaults.standard
        let idClientValForStream = userDefaults.string(forKey: "idClientValueForStream")
        return "urn:lo:nsid:\(String(describing: idClientValForStream))" ?? "urn:lo:nsid:\( getShortClientId())"
    }
    func getAutoReconnectStatus() -> Bool {
        return AUTO_RECONNECT == true
    }
    
//    public func setCfgParameter(cfgKey: String, cfgParameter: DeviceConfig){
//        switch <#value#> {
//        case <#pattern#>:
//            <#code#>
//        default:
//            <#code#>
//        }
//    }
    
}
