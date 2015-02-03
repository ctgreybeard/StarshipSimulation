//
//  LocationTests.swift
//  StarShipSimulation
//
//  Created by William Waggoner on 12/30/14.
//  Copyright (c) 2014 William C Waggoner. All rights reserved.
//

import Cocoa
import XCTest

class LocationTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testLocationEnum() {
        var newCode: LocationCode!
        XCTAssertTrue(newCode == nil, "newCode not nil")
        let testRaw: [LocationCode: (String, Int)] = [LocationCode.Spatial: ("Spatial", -1),
            LocationCode.Bridge: ("Bridge", 0),
            LocationCode.SciencesLaboratory: ("SciencesLaboratory", 1),
            LocationCode.Shuttlebay: ("ShuttleCraft", 17),
            LocationCode.ShuttleCraft: ("ShuttleCraft", 70),
            LocationCode.CelestialObject: ("CelestialObject", 1000),
            LocationCode.EnemyCraft: ("EnemyCraft", 2000),
            LocationCode.FederationCraft: ("FederationCraft", 3000),
            LocationCode.Enterprise: ("Enterprise", 4000),
            LocationCode.PhotonTorpedoTubeStation: ("PhotonTorpedoTubeStation", 80)]
        for testKey in testRaw.keys {
            let (name, raw) = testRaw[testKey]!
            XCTAssertEqual(testKey.rawValue, raw, "newCode raw value incorrect for \(name)")
        }
    }

    func testLocation() {
        let testPos = SpatialPosition(x: 1000, y: 2000, z: 3000)

        // Default location
        let testLoc2 = Location()
        XCTAssertEqual(testLoc2.code, LocationCode.None, "Default Location not .None")
        XCTAssertEqual(testLoc2.craftOrObjectNum, -1, "default Location craftOrObject not -1")
        XCTAssertNil(testLoc2.position, "default Location position not nil")

        // Initialize with a numeric location (72 == Shuttlecraft2)
        let testLoc3 = Location(7)
        XCTAssertEqual(testLoc3.code, LocationCode.MedicalComputer, "Location code not correct")
        XCTAssertEqual(testLoc3.craftOrObjectNum, -1, "set Location craftOrObject not -1")
        XCTAssertNil(testLoc3.position, "set Location position not nil")

        // Initialize with a position
        let testLoc4 = Location(testPos)
        XCTAssertEqual(testLoc4.num, -1, "Positional Location num not correct")
        XCTAssertEqual(testLoc4.code, LocationCode.Spatial, "Positional Location code not correct")
        XCTAssertEqual(testLoc4.craftOrObjectNum, -1, "Positional Location craftOrObject not -1")
        XCTAssertNotNil(testLoc4.position, "Positional Location position nil")
        XCTAssertTrue(testLoc4.position === testPos, "Positional Location position not set")

        // Set spatial position
        var testLoc5 = Location()
        XCTAssertEqual(testLoc5.code, LocationCode.None, "default Location code not correct")
        testLoc5.position = testPos
        XCTAssertEqual(testLoc5.num, -1, "Positional Location num not correct")
        XCTAssertEqual(testLoc5.code, LocationCode.Spatial, "Positional Location code not correct")
        XCTAssertEqual(testLoc5.craftOrObjectNum, -1, "Positional Location craftOrObject not -1")
        XCTAssertNotNil(testLoc5.position, "Positional Location position missing")
        XCTAssertTrue(testLoc5.position === testPos, "Positional Location position not set correctly")

        // Set numeric location (10 = FoodProcessingPlant)
        testLoc5.num = 10
        XCTAssertEqual(testLoc5.num, 10, "Numeric Location num not correct")
        XCTAssertEqual(testLoc5.code, LocationCode.FoodProcessingPlant, "Numeric Location code not correct")
        XCTAssertEqual(testLoc5.craftOrObjectNum, -1, "Numeric Location craftOrObject not -1")
        XCTAssertNil(testLoc5.position, "Numeric Location position not nil")

        // Set numeric location on Federation craft (3003 = Federation Craft #3)
        testLoc5.num = 3003
        XCTAssertEqual(testLoc5.num, 3003, "Federation Craft Location num not correct")
        XCTAssertEqual(testLoc5.code, LocationCode.FederationCraft, "Federation Craft Location code not correct")
        XCTAssertEqual(testLoc5.craftOrObjectNum, 3, "Federation Craft Location craftOrObject not correct")
        XCTAssertNil(testLoc5.position, "Federation Craft Location position not nil")

    }
    
}
