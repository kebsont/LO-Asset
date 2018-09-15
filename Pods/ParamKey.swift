//
//  ParamKey.swift
//  CocoaAsyncSocket
//
//  Created by Moustapha Kebe on 13/09/2018.
//

//extension ParamKey: Codable{
//    private enum CodingKeys: String, CodingKey{
//        case type, value
//    }
//    private enum typeTitle: String, Codable{
//        case str, bin, f64, u32, i32
//    }
//    private struct typeValue{
//        let value: NSObject
//    }
//    func encode(to encoder: Encoder) throws{
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        switch self {
//        case .str:
//            try container.encode(typeTitle, forKey: .type)
//        default:
//            <#code#>
//        }
//    }
//}
