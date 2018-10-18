//
//  DeviceConfig.swift
//  LoAsset
//
//  Created by Moustapha Kebe on 06/09/2018.
//  Copyright © 2018 Orange. All rights reserved.
//

import Foundation
//import SwiftyBase64

enum Type: String, Codable {
    case str
    case bin
    case f64
    case u32
    case i32
}

struct DeviceConfigElement: Codable {
    var key: String
    var value: TypeValue
}

struct DeviceConfig: Codable {

    var cfg: Dictionary<String, TypeValue>
    init(elements: [DeviceConfigElement]) {
        self.cfg = Dictionary<String, TypeValue>()
        for element in elements {
            self.cfg[element.key] = element.value
        }
    }
}

struct StringTypeValue: Codable {
    var t: Type
    var v: String
}

struct IntTypeValue: Codable {
    var t: Type
    var v: Int32
}
struct UIntTypeValue: Codable {
    var t: Type
    var v: UInt32
}
struct BinTypeValue: Codable{
    var t: Type
    var v: String
}
struct FloatTypeValue: Codable{
    var t: Type
    var v: Float64
}


enum TypeValue {
    case string(StringTypeValue)
    case bin(BinTypeValue)
    case int(IntTypeValue)
    case float64(FloatTypeValue)
    case uint(UIntTypeValue)
    case unsupported
}

extension TypeValue: Codable {
    private enum CodingKeys: String, CodingKey {
        case t
        case v
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let t = try container.decode(String.self, forKey: .t)
        if let type = Type(rawValue: t) {
            switch type {
            case .str:
                let value = try container.decode(String.self, forKey: .v)
                self = .string(StringTypeValue(t: type, v: value))
            case .i32:
                let value = try container.decode(Int.self, forKey: .v)
                self = .int(IntTypeValue(t: type, v: Int32(value)))
            case .bin:
                let value = try container.decode(String.self, forKey: .v)
                self = .bin(BinTypeValue(t: type, v: value))
            case .f64:
                let value = try container.decode(Float64.self, forKey: .v)
                self = .float64(FloatTypeValue(t: type, v: value))
            case .u32:
                let value = try container.decode(String.self, forKey: .v)
                self = .uint(UIntTypeValue(t: type, v: UInt32(value)!))
            }
        } else {
            self = .unsupported
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .string(let typeValue):
            try container.encode(typeValue.t, forKey: .t)
            try container.encode(typeValue.v, forKey: .v)
        case .int(let typeValue):
            try container.encode(typeValue.t, forKey: .t)
            try container.encode(typeValue.v, forKey: .v)
        case .bin(let typeValue):
            try container.encode(typeValue.t, forKey: .t)
            try container.encode(typeValue.v, forKey: .v)
        case .float64(let typeValue):
            try container.encode(typeValue.t, forKey: .t)
            try container.encode(typeValue.v, forKey: .v)
        case .uint(let typeValue):
            try container.encode(typeValue.t, forKey: .t)
            try container.encode(typeValue.v, forKey: .v)
        case .unsupported:
            let context = EncodingError.Context(codingPath: [], debugDescription: "invalid type")
            throw EncodingError.invalidValue(self, context)
            
        }
    }
}
let json = """
    {
       "cfg": {
          "log_level": {
             "t": "str",
             "v": "DEBUG"
          },
          "secret_key": {
             "t": "bin",
             "v": "Nzg3ODY4Ng=="
          },
          "conn_freq": {
             "t": "i32",
             "v": 80000
          }
        }
    }
    """.data(using: .utf8)!



//let decoder = JSONDecoder()
//let config = try decoder.decode(DeviceConfig.self, from: json)
//print(<#T##items: Any...##Any#>)

//    func setCfgParameters(cfgKey: String, cfgParam: DeviceConfig.Type) -> DeviceConfig.Type {
//        let userDefaults = UserDefaults.standard
//        switch self {
//        case .string(let typeValue):
//            userDefaults.set(cfgKey, forKey: cfgParam as! String)
//        case .unsupported: break
////            throw nil
//        }
//    }

