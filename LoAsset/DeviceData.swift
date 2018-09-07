//
//  DeviceData.swift
//  Lo Asset
//
//  Created by Moustapha Kebe on 06/09/2018.
//  Copyright © 2018 Orange. All rights reserved.
//

import Foundation
class DeviceData{
    var preferences = AppPreferences()
    enum myTags: String {
        case breakfast, lunch, dinner
    }
    struct Coord {
        var lat = 0.0, lon = 0.0
    }

    var streamId: String {
        get{
            return preferences.getStreamId()
        }
        set(newStreamId){
            self.streamId = newStreamId
        }
    }
    var timestamp: String{
        get{
        return "ts"
        }
        set(newTs){
        self.timestamp = newTs
        }
    }
    var model: String {
        get{
            return "m"
        }
        set(newMdl){
            self.model = newMdl
        }
    }
//    var objToGet: NSObject
    var value :Any? {
        get{
            return  nil
        }
        set(newObj){
            self.value = newObj
        }
    }
    var tags : Set<myTags>?
    var newLoc =  Coord()
    var location: Coord{
        get{
            let x = 0.0, y = 0.0
            return Coord(lat: x, lon: y)
        }
        set(locToSet){
            newLoc.lat = locToSet.lat
            newLoc.lon = locToSet.lon
        }
    }

 init?() {
        var model: String
        var latitude: String
        var longitude: String
        var tagsJSON: String
        var tags: Set <myTags> = []
        self.tags = tags
    }
}

