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
var v: (Any)? = nil

struct DeviceData: Codable{
//var tags : [myTags] = []
        var s: String = ""
        var ts: String = ""
        var m: String = "NNNNN"
        var loc: [Double] = [0.0, 0.0]
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
    var value :Any? {
                get{
                    return  nil
                }
                set(newObj){
                    v = newObj
                }
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
            var model: String = "m"
            var loc: [Double] = []
            var tagsJSON: String
            var value: NSObject? = nil
            var tags: [myTags] = []
//            self.tags = tags
            self.location = loc
            self.model = model
            self.value = value
        }
}

