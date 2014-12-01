//
//  UserInfo.swift
//  Help
//
//  Created by Adarshkumar Pavani on 10/12/14.
//  Copyright (c) 2014 Adarshkumar Pavani. All rights reserved.
//

import Foundation

class UserInfo{
    
    var name: String
    var macID: String
    var distance: Float
    var timeStamp : String
    var messageText : String
    var latitude : Float
    var longitude : Float
    var oldCount : Int
    var newCount : Int
    
    init(name: String, macID: String, distance: Float,  timeStamp: String, messageText: String, latitude: Float, longitude: Float, oldCount : Int, newCount : Int)
    {
        self.name = name
        self.macID = macID
        self.distance = distance
        self.timeStamp = timeStamp
        self.messageText = messageText
        self.latitude = latitude
        self.longitude = longitude
        self.oldCount = oldCount
        self.newCount = newCount
    }
    
    convenience init(name: String, message: String)
    {
        self.init(name: "", macID: "", distance: 0.0,  timeStamp: "", messageText: "", latitude: 0.0, longitude: 0.0, oldCount : 0, newCount : 0)
        
        self.name = name
        self.messageText = message
        
    }

}