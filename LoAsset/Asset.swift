//
//  Asset.swift
//  Lo Asset
//
//  Created by Moustapha Kebe on 06/09/2018.
//  Copyright © 2018 Orange. All rights reserved.
//

import Foundation
//import LoAsset
import CSV
//import utils
class Asset {
    let ASSET_CONFIG_REFRESH : String = "updateRate"
    let ASSET_CONFIG_LOG : String = "logLevel"
    let ASSET_COMMAND_BUZZER : String = "buzzer"
    let ASSET_RESOURCE_SPLASH_ID : String = "demo_splash_screen"
    var currentHumid: Int = 0
    var currentRpm: Int = 0
    var currentCo: Int = 0
    var currentTemp: Int = 0
    var currentPression: Int = 0
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
    
     var config: DeviceConfig?
    private var telemetry : DeviceDataTelemetry?
    private var telemetryOld : DeviceDataTelemetry?
    private var location: [Double]
    private var locationOld: Double = 0.0
    private var resources: DeviceResources?
    lazy var telemetryModeAuto: Bool = false
    lazy var locationModeAuto: Bool = false
    let TEMPERATURE_MIN_PROGESS: Int = -20
    let TEMPERATURE_MAX_PROGESS:Int = 120
    

    private var gpsTrackCurrendIdx: Int = 0
    private var gpsTrack: [Double] = []
    public var deviceStatus: DeviceStatus?
    var simul = SimulerTableViewController()
    var constant = ApplicationConstants()
    init(model: String, version: String) {
        telemetry = DeviceDataTelemetry()
        location = [0.0,0.0]
        telemetryModeAuto = true
        locationModeAuto = true
        
        self.loadGpsTrackSimulator()
        
        // Create the Current Device Status (Info)
        self.deviceStatus = DeviceStatus(version: version)
        
        // Get the stored config of the device
        let defaultCfgRate = DeviceConfigElement(key: ASSET_CONFIG_REFRESH, value: TypeValue.int(IntTypeValue(t: Type.i32, v: Int32(constant.DEFAULT_UPDATE_RATE))))
        let defaultCFGLog = DeviceConfigElement(key: ASSET_CONFIG_LOG, value: TypeValue.string(StringTypeValue(t: Type.str, v: constant.DEFAULT_LOG_LEVEL)))
        config = DeviceConfig(elements: [defaultCfgRate, defaultCFGLog])
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


    func createDataDevice(value: DeviceDataTelemetry, loc: [Double]) -> DataDevice{
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let preferences = AppPreferences()
        let constant = ApplicationConstants()
        var newData = DataDevice()

        newData.s = preferences.getStreamId()
        newData.loc = loc
        newData.m = constant.PUBLISHED_MODEL
        newData.v.cO2 = value.getCo2()
        newData.v.hydrometry = value.getHydrometrie()
        newData.v.doorOpen = value.getDoorOpen()
        newData.v.temperature = value.getTemperature()
        newData.v.revmin = value.getRevmin()
        newData.v.pressure = value.getPressure()
        return newData
    }
    
    func getNextGpsFixSimulator() -> [Double] {
        self.location = [gpsTrack[gpsTrackCurrendIdx],gpsTrack[gpsTrackCurrendIdx+1]]
        gpsTrackCurrendIdx += 1
        if (gpsTrackCurrendIdx >= gpsTrack.count) {
            gpsTrackCurrendIdx = 0
        }

        return location
    }
    func getNextLocation() -> [Double]{
        if (self.locationModeAuto == true){
            location = self.getNextGpsFixSimulator()
            //notifyDeviceLocationChange
        }
        return location
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
        let srandInt = Int.random(in: -REVMIN_CHANGE_STEP/2...REVMIN_CHANGE_STEP)
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
            lastPressure += Int.random(in: -PRESSURE_CHANGE_STEP/2...PRESSURE_CHANGE_STEP)
//            lastPressure += Int(arc4random_uniform(UInt32(-(PRESSURE_CHANGE_STEP/2)) - UInt32( PRESSURE_CHANGE_STEP)) + 1)
         }
            else{
            lastPressure -= Int.random(in: -PRESSURE_CHANGE_STEP/2...PRESSURE_CHANGE_STEP)
//                lastPressure -= Int(arc4random_uniform(UInt32(-(PRESSURE_CHANGE_STEP/2)) - UInt32( PRESSURE_CHANGE_STEP)) + 1)
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
    func getNexTelemetry() -> DeviceDataTelemetry{
        if self.simul.MonSwitch {
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
   
extension Int
{
    static func random(range: Range<Int> ) -> Int
    {
        var offset = 0
        
        if range.startIndex < 0   // allow negative ranges
        {
            offset = abs(range.startIndex)
        }
        
        let mini = UInt32(range.startIndex + offset)
        let maxi = UInt32(range.endIndex   + offset)
        
        return Int(mini + arc4random_uniform(maxi - mini)) - offset
    }
}
