//
//  PhotonTorpedo.swift
//  StarShipSimulation
//
//  Created by William Waggoner on 12/30/14.
//  Copyright (c) 2014 William C Waggoner. All rights reserved.
//

import Foundation

class PhotonTube: SystemArrayObject {
    dynamic var tubeStatus: SystemStatus
    dynamic var torpedos: SystemArray {
        didSet {
            setTorpedosAccess()
        }
    }
    dynamic var BY: Int {
        get {return tubeStatus.functionalStatus}
        set {tubeStatus.functionalStatus = newValue}
    }
    dynamic var BZ: Int {
        get {return tubeStatus.operationalStatus}
        set {tubeStatus.operationalStatus = newValue}
    }
    dynamic var B1: Int {
        get {return tubeStatus.reliabilityFactor}
        set {tubeStatus.reliabilityFactor = newValue}
    }
    dynamic var B2: Int {return torpedos.count}
    dynamic let B3: SystemArrayAccess
    dynamic let B4: SystemArrayAccess

    override func copyWithZone(zone: NSZone) -> AnyObject {
        let newTube = PhotonTube()
        newTube.tubeStatus = tubeStatus.copy() as SystemStatus
        var newTorps = [PhotonTorpedo]()
        for i in 0..<torpedos.count {
            newTorps.append((torpedos[i] as PhotonTorpedo).copy() as PhotonTorpedo)
        }
        newTube.torpedos = SystemArray(with: newTorps)
        return newTube
    }

    required init() {
        tubeStatus = SystemStatus()
        torpedos = SystemArray(num: 20, withType: PhotonTorpedo.self)
        B3 = SystemArrayAccess(source: torpedos, member: "location.num")
        B4 = SystemArrayAccess(source: torpedos, member: "destination.num")
        super.init()
        mkSOID(.PhotonTube)
    }

    func setTorpedosAccess() {
        B3.setSource(torpedos)
        B4.setSource(torpedos)
    }
}

class PhotonTorpedo: SystemArrayObject {
    dynamic var location: Location
    dynamic var destination: Location

    required init() {
        location = Location()
        destination = Location()
        super.init()
        mkSOID(.PhotonTorpedo)
    }

    override func copyWithZone(zone: NSZone) -> AnyObject {
        let newTorpedo = PhotonTorpedo()
        newTorpedo.location = location.copy() as Location
        newTorpedo.destination = destination.copy() as Location
        return newTorpedo
    }
}