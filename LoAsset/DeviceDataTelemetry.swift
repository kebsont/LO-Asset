//
//  DeviceDataTelemetry.swift
//  Lo Asset
//
//  Created by Moustapha Kebe on 06/09/2018.
//  Copyright © 2018 Orange. All rights reserved.
//

import Foundation
public class DeviceDataTelemetry {
    
    public var temperature: Int
    public var hydrometry: Int
    public var revmin: Int
    public var CO2: Int
    public var pressure: Int
    public var doorOpen: Bool
    
    //Functions
    func getTemperature() -> Int{
        return temperature
    }
    public func setTemperature(newTemp: Int) {
        temperature = newTemp
    }
    
    func getHydrometrie() -> Int{
        return hydrometry
    }
    public func setHydrometrie(newHydro: Int) {
        hydrometry = newHydro
    }
    
    func getRevmin() -> Int{
        return revmin
    }
    
    public func setRevmin(newRevmin: Int) {
        revmin = newRevmin
    }
    
    func getCo2() -> Int{
        return CO2
    }
    public func setCo2(newCo2: Int) {
        CO2 = newCo2
    }
    func getPressure() -> Int{
        return pressure
    }
    public func setPressure(newPressure: Int) {
        pressure = newPressure
    }
    
    func getDoorOpen() -> Bool{
        return false
    }
    public func setDoorOpen(newDO: Bool) {
        doorOpen = newDO
    }
    
    init() {
        temperature = 0;
        hydrometry = 0;
        revmin = 0;
        CO2 = 400;
        pressure = 1000;
        doorOpen = false;
    }
//    init(value: DeviceDataTelemetry) {
    public func clone(value: DeviceDataTelemetry) -> DeviceDataTelemetry{
        var clone: DeviceDataTelemetry = DeviceDataTelemetry()
        
        clone.temperature = value.temperature;
        clone.hydrometry = value.hydrometry;
        clone.revmin = value.revmin;
        clone.CO2 = value.CO2;
        clone.pressure = value.pressure;
        clone.doorOpen = value.doorOpen;
        return clone
    }
}


extension DeviceDataTelemetry: Encodable {
//    public required convenience init(from decoder: Decoder) throws {
//        <#code#>
//    }
}
