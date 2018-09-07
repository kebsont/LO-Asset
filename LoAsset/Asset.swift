//
//  Asset.swift
//  Lo Asset
//
//  Created by Moustapha Kebe on 06/09/2018.
//  Copyright © 2018 Orange. All rights reserved.
//

import Foundation
import LoAsset
import CSV
//import utils
class Asset {
    let ASSET_CONFIG_REFRESH : String = "updateRate"
    let ASSET_CONFIG_LOG : String = "logLevel"
    let ASSET_COMMAND_BUZZER : String = "buzzer"
    let ASSET_RESOURCE_SPLASH_ID : String = "demo_splash_screen"
    
    // Data Simulation
    private var NUMBER_BEFORE_OPEN_DOOR = 10000;
    lazy var countBeforeOpenDoor : Int = NUMBER_BEFORE_OPEN_DOOR
    private var NUMBER_BEFORE_CHECK_REVMIN_THRESHOLD: Int = 10
    lazy var countBeforeCheckRevminThreshold : Int = NUMBER_BEFORE_CHECK_REVMIN_THRESHOLD;
    private var  NUMBER_BEFORE_CHECK_PRESSURE_THRESHOLD: Int = 10;
    lazy  var countBeforeCheckPressureThreshold: Int = NUMBER_BEFORE_CHECK_PRESSURE_THRESHOLD;
    private  var MAX_REVMIN: Int = 10000;
    private  var  REVMIN_START: Int = 5000;
    private var   REVMIN_CHANGE_STEP: Int = 500;
    lazy  var lastRevmin: Int = REVMIN_START;
    private  var  CO2_START: Int = 400;
    private  var  MAX_CO2: Int = 2000;
    private  var  CO2_CHANGE_STEP: Int = 20;
    lazy  var lastCO2: Int = CO2_START;
    private  var  MAX_PRESSURE: Int = 4000;
    private   var MIN_PRESSURE: Int = 500;
    private  var  PRESSURE_START: Int = 1000;
    private   var PRESSURE_CHANGE_STEP: Int = 50;
    lazy   var lastPressure: Int = PRESSURE_START;
    private  var lastTemperature: Int = 0;
    private  var lastHygrometry: Int = 0;
    private  var revminIncrease: Bool = true;
    private  var pressureIncrease: Bool = true;
    private  var  CHANGE_REVMIN_THRESHOLD_CHANCE: Int = 2; // 1/x chance to switch from increase to decrease
    private  var CHANGE_PRESSURE_THRESHOLD_CHANCE: Int = 2; // 1/x chance to switch from increase to decrease
    
    private var telemetry : DeviceDataTelemetry?
    private var telemetryOld : DeviceDataTelemetry?
    private var location: [Double] = [0.0]
    private var locationOld: Double = 0.0
//    private var config: DeviceConfig?
    private var resources: DeviceResources?
    lazy var telemetryModeAuto: Bool = false
    lazy var locationModeAuto: Bool = false
    let TEMPERATURE_MIN_PROGESS: Int = -20
    let TEMPERATURE_MAX_PROGESS:Int = 120

    private var gpsTrackCurrendIdx: Int = 0
    private var gpsTrack = Array(repeating: 0.0, count: 2)
    public var deviceStatus: DeviceStatus?
//    private var mLocationManager: LocationManager
    var simul = SimulerTableViewController()
    init(model: String, version: String) {
        telemetry = DeviceDataTelemetry()
//        config = DeviceConfig()
        location = [0.0, 0.0]
//        simul.telemetrieSwitch.isOn = true
        locationModeAuto = true
        //load the GPS simulator
        //deviceStatus = DeviceStatus(modell: model, version: version)
        
    }
    func loadGpsTrackSimulator()
    {
        var lat: Double
        var lon: Double        
        let csvString = LoadFileAsString()
        let csv = try! CSVReader(string: csvString)
        while let row = csv.next() {
            lat = ((row[1]) as NSString).doubleValue
            lon = ((row[2]) as NSString).doubleValue
            gpsTrack.append(lat)
            gpsTrack.append(lon)
        }
    }

    
    func createDeviceData(value: DeviceDataTelemetry, loc: [DeviceData]) -> DeviceData {
        var newData = DeviceData()
        print("streamID")
        print(newData?.streamId)
        newData?.streamId = (newData?.streamId)!
        newData?.value = value as DeviceDataTelemetry
        newData?.location.lat = (newData?.location.lat)!
        newData?.location.lon = (newData?.location.lon)!
        newData?.model = "demo"
        return newData!
    }
     func setRevminIncrease() -> Bool{
        if (countBeforeCheckRevminThreshold-1 > 0){
            return revminIncrease
        }else{
             return false
        }
       
    }
    
    func setPressureIncrease() -> Bool{
        if (countBeforeCheckPressureThreshold-1 > 0){
            return pressureIncrease
        }else{
            countBeforeCheckPressureThreshold = NUMBER_BEFORE_CHECK_PRESSURE_THRESHOLD
            let randInt = Int(arc4random_uniform(101))
            return  randInt>(100/CHANGE_PRESSURE_THRESHOLD_CHANCE)
        }
    }
    func getNextTelemetrySimulator() -> DeviceDataTelemetry{
        if(countBeforeOpenDoor-1 > 0){
            telemetry?.doorOpen = false
        }else{
            telemetry?.doorOpen = true
            countBeforeOpenDoor = NUMBER_BEFORE_OPEN_DOOR
            lastRevmin = REVMIN_START
            lastCO2 = CO2_START
            lastPressure = PRESSURE_START
            revminIncrease = true
            pressureIncrease = true
        }
        revminIncrease = setRevminIncrease()
        let srandInt = Int(arc4random_uniform(UInt32(-(REVMIN_CHANGE_STEP/2)) - UInt32( REVMIN_CHANGE_STEP)) + 1)
        if revminIncrease {
            lastRevmin += srandInt
        }else{
            lastRevmin -= srandInt
        }
        if(lastRevmin > MAX_REVMIN) {
            revminIncrease = false
        }
        if(lastRevmin < 0 ) {
            revminIncrease = true
        }
        telemetry?.revmin = Swift.min(Swift.max(lastRevmin, 0), MAX_REVMIN)
        lastHygrometry = Swift.min(lastRevmin/100 + Int(arc4random_uniform(11)), 100)
        telemetry?.hydrometry = lastHygrometry
        lastTemperature = (lastRevmin * TEMPERATURE_MAX_PROGESS) / (MAX_REVMIN - TEMPERATURE_MIN_PROGESS)
        telemetry?.temperature = lastTemperature
        pressureIncrease = setPressureIncrease()
        if pressureIncrease {
            lastPressure += Int(arc4random_uniform(UInt32(-(PRESSURE_CHANGE_STEP/2)) - UInt32( PRESSURE_CHANGE_STEP)) + 1)
         }
            else{
                lastPressure -= Int(arc4random_uniform(UInt32(-(PRESSURE_CHANGE_STEP/2)) - UInt32( PRESSURE_CHANGE_STEP)) + 1)
            }
        if(lastPressure > MAX_PRESSURE){
            pressureIncrease = false
        }
        if(lastPressure < MIN_PRESSURE){
            pressureIncrease = true
        }
        telemetry?.pressure = Swift.min(Swift.max(MIN_PRESSURE, lastPressure), MAX_PRESSURE)
       lastCO2 = lastPressure * MAX_CO2/MAX_PRESSURE
        telemetry?.CO2 = Swift.min(Swift.max(0, lastCO2), MAX_CO2)
        return telemetry!
    }
    var Simuler = SimulerTableViewController()
    func getNexTelemetry() -> DeviceDataTelemetry{
        if (Simuler.telemetrieSwitch.isOn) {
            telemetry = self.getNextTelemetrySimulator()
        }
        return telemetry!
    }
    
}
    //Read the csv file
func LoadFileAsString() -> String
    {
        var contentAsString: String = ""
        if let path = Bundle.main.path(forResource: "Garden_Lille", ofType: "csv")
        {
            let fm = FileManager()
            let exists = fm.fileExists(atPath: path)
            if(exists){
                let content = fm.contents(atPath: path)
                contentAsString = String(data: content!, encoding: String.Encoding.utf8)!
               
            }
        }
         return contentAsString
    }
   
    



