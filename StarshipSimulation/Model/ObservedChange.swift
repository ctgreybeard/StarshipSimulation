//
//  ObservedChange.swift
//  StarshipSimulation
//
//  Created by William Waggoner on 1/30/15.
//  Copyright (c) 2015 William C Waggoner. All rights reserved.
//




import Foundation

typealias ChangeDict = [NSObject: AnyObject]
typealias UsefulChangeDict = [String: AnyObject]

class ObservedChange: NSObject {

    let kindString: [NSKeyValueChange: String] = [
        .Replacement: ".Replacement",
        .Insertion: ".Insertion",
        .Removal: ".Removal",
        .Setting: ".Setting"]

    let cdict: UsefulChangeDict
    let kind: NSKeyValueChange
    let kindStr: String
    let prior: Bool
    let indexes: NSIndexSet?
    let changeNew: AnyObject?
    let changeOld: AnyObject?

    init(_ change: ChangeDict) {
        cdict = change as UsefulChangeDict
        kind = NSKeyValueChange(rawValue: UInt(cdict[NSKeyValueChangeKindKey] as NSNumber))!
        kindStr = kindString[kind] ?? ".???"
        prior = (cdict[NSKeyValueChangeNotificationIsPriorKey] as? NSNumber) == NSNumber(bool: true)
        indexes = cdict[NSKeyValueChangeIndexesKey] as? NSIndexSet
        changeNew = cdict[NSKeyValueChangeNewKey]
        changeOld = cdict[NSKeyValueChangeOldKey]
        super.init()
    }
}