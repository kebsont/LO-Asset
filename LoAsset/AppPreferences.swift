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
    var AppVersion: String = "v1.0.0"
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
    func getApiKey() -> String {
        return API_KEY
    }
    func setApiKey(apiKey: String)  {
        let userDefaults = UserDefaults.standard
        userDefaults.set(apiKey, forKey: "apikeyValue")
        userDefaults.synchronize()
    }
    func clearPreferences(){
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }
    
<<<<<<< HEAD:LoAsset/AppPreferences.swift
//    func setCfgParameter(cfgKey: String, cfgP: DeviceConfig.CfgParameter ) {
//        let userDefaults = UserDefaults.standard
//        switch (cfgP.getType()) {
//        case "bin":
//            userDefaults.set(cfgKey, forKey: cfgP.getValue() as! String)
//            break
//        case "str":
//            userDefaults.set(cfgKey, forKey: cfgP.getValue() as! String)
//            break;
//       
//        default:
//            break;
//        }
//    }
=======
    
    
    
    
//    public func setCfgParameter(cfgKey: String, cfgParameter: DeviceConfig){
//        switch <#value#> {
//        case <#pattern#>:
//            <#code#>
//        default:
//            <#code#>
//        }
//    }
    
>>>>>>> home:utils/AppPreferences.swift
}
