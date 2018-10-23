//
//  DeviceData.swift
//  Lo Asset
//
//  Created by Moustapha Kebe on 06/09/2018.
//  Copyright © 2018 Orange. All rights reserved.
//

import Foundation
import UIKit
//
enum myTags: String {
    case breakfast, lunch, dinner
}
var preferences = AppPreferences()

struct DeviceData: Codable{
//var tags : [myTags] = []
        var s: String = ""
        var ts: String = ""
        var m: String = "NNNNN"
        var loc: [Double] = [0.0, 0.0]
    var v: V?
    
//    var e: NSObject
        var streamId: String {
            get{
                return preferences.getStreamId()
            }
            set{ s = newValue }
        }
        var timestamp: String{
            get{
            return "ts"
            }
            set(newTs){
            ts = newTs
            }
        }
        var model: String {
            get{
                return "m"
            }
            set(newMdl){
                m = newMdl
            }
        }
    var valuee :V {
                get{
                    return  v!
                }
                set(newObj){
                    v = newObj
                }
            }
    public mutating func setCo2(newCo2: Int) {
        v?.cO2 = newCo2
    }
    var location: [Double] {
        get{
            return  [0.0, 0.0]
        }
        set(newObj){
            loc = newObj
        }
    }
     init?() {
//            var model: String = "m"
//            var loc: [Double] = []
//            var tagsJSON: String
//            var value: V? = nil
////            var tags: [myTags] = []
//
//
//            location = loc
//            model = m
//            valuee = value!
        }
}


