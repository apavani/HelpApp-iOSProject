//
//  Calculate_Distance.swift
//  Help
//
//  Created by LiQihui on 10/4/14.
//  Copyright (c) 2014 Adarshkumar Pavani. All rights reserved.
//

import Foundation
import GLKit

class DistanceCalculator{
    
    let lat1:Float
    let lat2:Float
    let lon1:Float
    let lon2:Float
    
    init( lat1:Float, lat2:Float, lon1:Float, lon2:Float){
        self.lat1 = lat1
        self.lat2 = lat2
        self.lon1 = lon1
        self.lon2 = lon2
    
        }
    
    // Borrowed the code from a javascript reference online.
    func calculateDistance() ->Float{
        let R:Float = 6371.00// km
        var φ1 = GLKMathDegreesToRadians(lat1)
        var φ2 = GLKMathDegreesToRadians(lat2)
        var Δφ = GLKMathDegreesToRadians(lat2-lat1)
        var Δλ = GLKMathDegreesToRadians(lon2-lon1)
        
        var a = sin(Δφ/2) * sin(Δφ/2) + cos(φ1) * cos(φ2) * sin(Δλ/2) * sin(Δλ/2)
        var c = 2 * atan2(sqrt(a), sqrt(1-a))
        
        var d = R * c
        //println (d)
        return d
    }
    
    func printInfo(){
        println ("\(calculateDistance())")
    }
}

    //distanceCalculator.printInfo()


