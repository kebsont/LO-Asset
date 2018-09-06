//
//  AppPreferences.swift
//  Lo Asset
//
//  Created by Moustapha Kebe on 06/09/2018.
//  Copyright © 2018 Orange. All rights reserved.
//

import Foundation

class AppPreferences{
    var API_KEY : String = "apiKey"
    var AUTO_RECONNECT : Bool = false
    var MQTT_SERVER:String = "mqttServer"
    var MQTT_PROTOCOL:String = "mqttProtocol"
    var ASSET_RESSOURCE_PREFIX:String = "assetResource."
    var ASSET_NAMESPACE: String = "IPHONE"
    var assetId: String = ""
    
    func getUsernameDeviceMode() -> String {
        return "json+device"
    }
    
    func getStreamId() -> String {
        return ASSET_NAMESPACE + "\(assetId)"
    }
    
    func getShortClientId() -> String {
        return ASSET_NAMESPACE + ":\(assetId)"
    }
    func getClientId() -> String {
        return "urn:lo:nsid:\(getShortClientId)"
    }
    func getAutoReconnectStatus() -> Bool {
        return AUTO_RECONNECT == true
    }
}
