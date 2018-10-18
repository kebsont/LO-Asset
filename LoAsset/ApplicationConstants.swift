//
//  ApplicationConstants.swift
//  LoAsset
//
//  Created by Moustapha Kebe on 18/10/2018.
//  Copyright © 2018 Orange. All rights reserved.
//

import Foundation
class ApplicationConstants {

let ConnectionStatusProperty: String = "connectionStatus";
let TelemetryProperty: String = "telemetry";
let LocationProperty: String = "location";
let ConfigurationProperty : String = "configuration";
let ResourceNewVersionProperty : String = "ResourceNewVersionProperty";

let PUBLISHED_MODEL: String = "demo";
let DEFAULT_DEVICE_NAME : String = "123456789012345";

let TEMPERATURE_MIN_PROGESS: Int = -20;
let TEMPERATURE_MAX_PROGESS: Int = 120;

// The minimum distance to change Updates in meters
let MIN_DISTANCE_CHANGE_FOR_UPDATES: CLong = 0;

// The minimum time between updates in milliseconds
let MIN_TIME_BW_UPDATES: CLong = 1000;

let DEFAULT_UPDATE_RATE: Int = 4;
let DEFAULT_LOG_LEVEL : String = "Info";


let MQTT_KEEP_ALIVE_INTERVAL: Int = 20;
let MQTT_CONNECTION_TIMEOUT: Int = 30;

// Mqtt topics
let MQTT_TOPIC_PUBLISH_STATUS : String = "dev/info";
let MQTT_TOPIC_PUBLISH_DATA : String = "dev/data";

let MQTT_TOPIC_PUBLISH_RESOURCE : String = "dev/rsc";
let MQTT_TOPIC_SUBSCRIBE_RESOURCE : String = "dev/rsc/upd";
let MQTT_TOPIC_RESPONSE_RESOURCE : String = "dev/rsc/upd/res";

let MQTT_TOPIC_SUBSCRIBE_COMMAND : String = "dev/cmd";
let MQTT_TOPIC_RESPONSE_COMMAND : String = "dev/cmd/res";

let MQTT_TOPIC_PUBLISH_CONFIG : String = "dev/cfg";
let MQTT_TOPIC_SUBSCRIBE_CONFIG : String = "dev/cfg/upd";
let MQTT_TOPIC_RESPONSE_CONFIG : String = "dev/cfg"; //"dev/cfg/upd/res";
}
