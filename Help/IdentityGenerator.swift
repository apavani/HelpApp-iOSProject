//
//  IdentityGenerator.swift
//  Help
//
//  Created by demo on 10/11/14.
//  Copyright (c) 2014 Adarshkumar Pavani. All rights reserved.
//

import Foundation

class IdentityGenerator
{

    var identifierForVendor: NSUUID!
    var device: UIDevice!
    init() {
    self.device =  UIDevice.currentDevice()
    self.identifierForVendor = self.device.identifierForVendor
    }
}