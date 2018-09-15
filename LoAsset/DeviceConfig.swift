//
//  DeviceConfig.swift
//  LoAsset
//
//  Created by Moustapha Kebe on 06/09/2018.
//  Copyright © 2018 Orange. All rights reserved.
//

import Foundation

enum Type: String, Codable {
    case str
    //case bin
    //case f64
    //case u32
    case i32
}

struct DeviceConfig: Codable {
    var cfg: Dictionary<String,[String:TypeValue]>
}

struct StringTypeValue: Codable {
    var t: Type
    var v: String
}

struct IntTypeValue: Codable {
    var t: Type
    var v: Int
}

enum TypeValue {
    case string(StringTypeValue)
    case int(IntTypeValue)
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
                    self = .int(IntTypeValue(t: type, v: value))
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
        case .unsupported:
            let context = EncodingError.Context(codingPath: [], debugDescription: "invalid type")
            throw EncodingError.invalidValue(self, context)
        }
    }
}
