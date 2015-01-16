//
//  SpatialPosition.swift
//  StarshipSimulation
//
//  Created by William Waggoner on 12/29/14.
//  Copyright (c) 2014 William C Waggoner. All rights reserved.
//

import Foundation

/// A point in space
class SpatialPosition: SystemObject, Equatable, NSCopying {
    /// coordinates in space
    dynamic var x: Coordinate
    dynamic var y: Coordinate
    dynamic var z: Coordinate

    /// init with a zero center
    required convenience init() {
        self.init(x: 0.0, y: 0.0, z: 0.0)
    }

    /// init with coordinates
    init(x: Coordinate, y: Coordinate, z: Coordinate) {
        self.x = x
        self.y = y
        self.z = z
        super.init()
        mkSOID(.SpatialPosition)
    }

    /// Calculate the distance to another point
    func distanceTo(p2: SpatialPosition) -> BigNum {
        return sqrt(pow(p2.x - self.x, 2) + pow(p2.y - self.y, 2) + pow(p2.z - self.z, 2))
    }

    func copyWithZone(zone: NSZone) -> AnyObject {
        return SpatialPosition(x: x, y: y, z: z)
    }
}

/// Two positions are equal if the distance between them is less than 1.0
func ==(lhs: SpatialPosition, rhs: SpatialPosition) -> Bool {
    return lhs.distanceTo(rhs) < 1.0
}

/// A volume of space with a center location
class SpatialVolume: SpatialPosition {
    /// All volumes are sperical, it's a miracle
    dynamic var radius: BigNum = 0.0

    /// init with a zero center and radius of one
    convenience required init() {
        self.init(x: 0.0, y: 0.0, z: 0.0, radius: 1.0)
    }

    /// init with a center and radius given
    init(x: Coordinate, y: Coordinate, z: Coordinate, radius: Coordinate) {
        self.radius = radius
        super.init(x: x, y: y, z: z)
        mkSOID(.SpatialVolume)
    }

    /// init with a SpatialPosition and a radius
    convenience init(center: SpatialPosition, radius: BigNum) {
        self.init(x: center.x, y: center.y, z: center.z, radius: radius)
    }

    /// Compute the center as a Spatial position
    var center: SpatialPosition {
        return SpatialPosition(x: x, y: y, z: z)
    }

    /// The distance between the outer boundaries. Note that this may be negative for overlapping volumes
    func separationFrom(v2: SpatialVolume) -> BigNum {
        return distanceTo(v2.center) - radius - v2.radius
    }

    override func copyWithZone(zone: NSZone) -> AnyObject {
        return SpatialVolume(x: x, y: y, z: z, radius: radius)
    }
}

// Velocity vector
class Velocity: SystemObject, NSCopying {
    var xy: BigNum
    var xz: BigNum
    var speed: BigNum

    required convenience init() {
        self.init(xy: 0.0, xz: 0.0, speed: 0.0)
    }

    init(xy: BigNum, xz: BigNum, speed: BigNum) {
        self.xy = xy
        self.xz = xz
        self.speed = speed
        super.init()
        mkSOID(.Velocity)
    }

    func copyWithZone(zone: NSZone) -> AnyObject {
        return Velocity(xy: xy, xz: xz, speed: speed)
    }
}