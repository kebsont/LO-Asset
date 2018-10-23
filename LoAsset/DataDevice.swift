//
//  DataDevice.swift
//  LoAsset
//
//  Created by Moustapha Kebe on 19/10/2018.
//  Copyright © 2018 Orange. All rights reserved.
//

import Foundation
//import UIKit

var myV = V()


public struct DataDevice: Codable {
    
    public var loc : [Double]!
    public var m : String!
    public var s : String!
    public var t : [String]!
    public var ts : String!
    public var v : V = myV
    


    func getTemperature() -> Int{
        return v.temperature
    }
    public mutating func setTemperature(newTemp: Int) {
        v.temperature = newTemp
    }
    
    func getHydrometrie() -> Int{
        return v.hydrometry
    }
    public mutating func setHydrometrie(newHydro: Int) {
        v.hydrometry = newHydro
    }
    
    func getRevmin() -> Int{
        return v.revmin
    }
    
    public mutating func setRevmin(newRevmin: Int) {
        v.revmin = newRevmin
    }
    
    public mutating func setCo2(newCo2: Int) {
        v.cO2 = newCo2
    }
    
    func getCo2() -> Int{
        return v.cO2
    }
    func getDoorOpen() -> Bool{
        return false
    }
    public mutating func setDoorOpen(newDO: Bool) {
        v.doorOpen = newDO
    }
//    init( ) {
//        
//    }
    
}

public struct V {
    
    public var cO2 : Int! = 0
    public var doorOpen : Bool! = false
    public var hydrometry : Int! = 9
    public var pressure : Int! = 8
    public var revmin : Int! = 99
    public var temperature : Int! = 0
    
}
enum CodingKeys: String, CodingKey {
    case cO2
    case doorOpen
    case hydrometry
    case pressure
    case revmin
    case temperature
}

extension V: Encodable{
    public func encode(to encoder: Encoder) throws{
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cO2, forKey: .cO2)
        try container.encode(doorOpen, forKey: .doorOpen)
        try container.encode(hydrometry, forKey: .hydrometry)
        try container.encode(pressure, forKey: .pressure)
        try container.encode(revmin, forKey: .revmin)
        try container.encode(temperature, forKey: .temperature)
    }
}

extension V: Decodable{
    public init (from decoder: Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cO2 = try values.decode(Int.self, forKey: .cO2)
        doorOpen = try values.decode(Bool.self, forKey: .doorOpen)
        hydrometry = try values.decode(Int.self, forKey: .hydrometry)
        pressure = try values.decode(Int.self, forKey: .pressure)
        revmin = try values.decode(Int.self, forKey: .revmin)
        temperature = try values.decode(Int.self, forKey: .temperature)
    }
}
