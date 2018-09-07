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
    
    public func setRevmin(newRevmin: Int) {
        revmin = newRevmin
    }
    
    func getCo2() -> Int{
        return CO2
    }
    public func setCo2(newCo2: Int) {
        CO2 = newCo2
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
    init(value: DeviceDataTelemetry) {
        temperature = value.temperature;
        hydrometry = value.hydrometry;
        revmin = value.revmin;
        CO2 = value.CO2;
        pressure = value.pressure;
        doorOpen = value.doorOpen;
    }
}
