//
//  TurboElevatorCar.swift
//  StarShipSimulation
//
//  Created by William Waggoner on 1/4/15.
//  Copyright (c) 2015 William C Waggoner. All rights reserved.
//

import Foundation

private var numTECar = 0

class TurboElevatorCar: SystemStatus {
    var location: Location
    var destination: Location
    var arrivalTime: NSDate
    var arrived: Bool {return arrivalTime.timeIntervalSinceNow <= 0.0}

    var EC: FunctionalStatus {
        get {return functionalStatus}
        set {functionalStatus = newValue}
    }
    var ED: Int {
        get {return location.num}
        set {location.num = newValue}
    }
    var EF: Int {
        get {return destination.num}
        set {destination.num = newValue}
    }
    var EG: NSTimeInterval {
        get {return arrivalTime.timeIntervalSince1970}
        set {arrivalTime = NSDate(timeIntervalSince1970: newValue)}
    }

    required init() {
        location = Location()
        destination = Location()
        arrivalTime = NSDate()

        super.init()
        mkSOID(.TurboElevatorCar)
    }
}