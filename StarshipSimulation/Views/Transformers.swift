//
//  Transformers.swift
//  StarshipSimulation
//
//  Created by William Waggoner on 2/3/15.
//  Copyright (c) 2015 William C Waggoner. All rights reserved.
//

import Cocoa

class EnterpriseEquipmentLocationTransformer: NSValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        return NSString.self
    }

    override class func allowsReverseTransformation() -> Bool { return false }

    override func transformedValue(value: AnyObject?) -> AnyObject? {
        var retVal: String?

        if let n = value as? Int {
            if let s = ShipLocation(rawValue: n) {
                retVal = ShipLocationName[s]!
            }
        }
        return retVal
    }
}
