//
//  SystemArrayTests.swift
//  StarShipSimulation
//
//  Created by William Waggoner on 12/31/14.
//  Copyright (c) 2014 William C Waggoner. All rights reserved.
//

import Cocoa
import XCTest

class SystemArrayTests: XCTestCase {

    override func setUp() {
        super.setUp()

        // Set the random seed from the time of day value (seconds since 1970)
        var t = timeval(tv_sec: 0,tv_usec: 0)
        gettimeofday(&t, nil)
        srandom(UInt32(t.tv_sec))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func randomName(length: Int) -> String {
        var newName = ""
        let chars = "abcdefghijklmnopqrstuvwxyz" +
            "ABCDEFGHIJKLMNOPQRSTUVWXYZ" +
        " .,"
        var charset = [Character]()
        for c in chars {
            charset.append(c)
        }
        for _ in 0..<length {
            let i = ssRandom(charset.count)
            newName.append(charset[i])
        }
        return newName
    }

    func testSystemArray() {
        let numPersons = 430
        var _enterprisePersonnel = SSMakeSystemArray(count: numPersons, withType: EnterprisePerson.self)
        var enterprisePersonnel = SystemArrayAccess(source: _enterprisePersonnel)
        var BK: Int {return enterprisePersonnel.count}
        var BL: SystemArrayAccess
        var BM: SystemArrayAccess
        var BN: SystemArrayAccess
        var BO: SystemArrayAccess
        var BP: SystemArrayAccess
        var BQ: SystemArrayAccess
        var BR: SystemArrayAccess
        var BS: SystemArrayAccess
        var BT: SystemArrayAccess
        var BU: SystemArrayAccess

        XCTAssertEqual(_enterprisePersonnel.count, numPersons, "Array not created correctly")

        BL = SystemArrayAccess(source: _enterprisePersonnel, member: "BL")
        BM = SystemArrayAccess(source: _enterprisePersonnel, member: "BM")
        BN = SystemArrayAccess(source: _enterprisePersonnel, member: "BN")
        BO = SystemArrayAccess(source: _enterprisePersonnel, member: "BO")
        BP = SystemArrayAccess(source: _enterprisePersonnel, member: "BP")
        BQ = SystemArrayAccess(source: _enterprisePersonnel, member: "BQ")
        BR = SystemArrayAccess(source: _enterprisePersonnel, member: "BR")
        BS = SystemArrayAccess(source: _enterprisePersonnel, member: "BS")
        BT = SystemArrayAccess(source: _enterprisePersonnel, member: "BT")
        BU = SystemArrayAccess(source: _enterprisePersonnel, member: "BU")

        // Pick two random test people
        let tp1 = ssRandom(enterprisePersonnel.count)
        let tp2 = ssRandom(enterprisePersonnel.count)

        println("Test person 1: \(tp1), person 2: \(tp2)")

        // Give them names
        let tp1name = randomName(10)
        let tp2name = randomName(10)

        // Some other name
        let resetName = randomName(15)
        println("Name 1=\(tp1name), Name 2=\(tp2name), Mr Random=\(resetName)")

        let tp1health = 5       // Got the flu
        let tp2health = 7       // Probably hungover
        let resetHealth = 10    // Th default value

        XCTAssertEqual(enterprisePersonnel.count, numPersons, "Source array invalid")
        XCTAssertLessThan(tp1, numPersons, "Test person 1 invalid")
        XCTAssertLessThan(tp2, numPersons, "Test person 2 invalid")

        // Test default values directly
//        XCTAssertEqual((enterprisePersonnel[tp1]? as EnterprisePerson).name, "New Person", "default setting (name) incorrect")
//        XCTAssertEqual((enterprisePersonnel[tp2]? as EnterprisePerson).name, "New Person", "default setting (name) incorrect")
//        XCTAssertEqual((enterprisePersonnel[tp1]? as EnterprisePerson).healthStatus, 10, "default setting (healthStatus) incorrect")
//        XCTAssertEqual((enterprisePersonnel[tp2]? as EnterprisePerson).healthStatus, 10, "default setting (healthStatus) incorrect")

        // Check alias access
//        XCTAssertEqual((enterprisePersonnel[tp1]? as EnterprisePerson).BL, "New Person", "default setting (BL alias for name) incorrect")
//        XCTAssertEqual((enterprisePersonnel[tp2]? as EnterprisePerson).BL, "New Person", "default setting (BL alias for name) incorrect")
//        XCTAssertEqual((enterprisePersonnel[tp1]? as EnterprisePerson).BU, 10, "default setting (BU alias for healthStatus) incorrect")
//        XCTAssertEqual((enterprisePersonnel[tp2]? as EnterprisePerson).BU, 10, "default setting (BU alias for healthStatus) incorrect")

        // Check SystemArray access
        XCTAssertEqual(BL[tp1] as String, "New Person", "default setting (BL 1) incorrect")
        XCTAssertEqual(BL[tp2] as String, "New Person", "default setting (BL 2) incorrect")
        XCTAssertEqual(BU[tp1] as Int, 10, "default setting (BU 1) incorrect")
        XCTAssertEqual(BU[tp2] as Int, 10, "default setting (BU 2) incorrect")

        // Test direct access
        (enterprisePersonnel[tp1]? as EnterprisePerson).name = tp1name
        XCTAssertEqual((enterprisePersonnel[tp1]? as EnterprisePerson).name, tp1name, "direct setting (name 1) incorrect")
        XCTAssertEqual((enterprisePersonnel[tp2]? as EnterprisePerson).name, "New Person", "direct setting (name 2) incorrect")
        (enterprisePersonnel[tp2]? as EnterprisePerson).name = tp2name
        XCTAssertEqual((enterprisePersonnel[tp1]? as EnterprisePerson).name, tp1name, "direct setting (name 1) incorrect")
        XCTAssertEqual((enterprisePersonnel[tp2]? as EnterprisePerson).name, tp2name, "direct setting (name 2) incorrect")
        (enterprisePersonnel[tp1]? as EnterprisePerson).healthStatus = tp1health
        (enterprisePersonnel[tp2]? as EnterprisePerson).healthStatus = tp2health
        XCTAssertEqual((enterprisePersonnel[tp1]? as EnterprisePerson).healthStatus, tp1health, "direct setting (healthStatus 1) incorrect")
        XCTAssertEqual((enterprisePersonnel[tp2]? as EnterprisePerson).healthStatus, tp2health, "direct setting (healthStatus 2) incorrect")

        // Reset the names and health
        (enterprisePersonnel[tp1]? as EnterprisePerson).name = resetName
        (enterprisePersonnel[tp2]? as EnterprisePerson).name = resetName
        XCTAssertEqual((enterprisePersonnel[tp1]? as EnterprisePerson).name, resetName, "reset (name 1) incorrect")
        XCTAssertEqual((enterprisePersonnel[tp2]? as EnterprisePerson).name, resetName, "reset (name 2) incorrect")
        (enterprisePersonnel[tp1]? as EnterprisePerson).healthStatus = resetHealth
        (enterprisePersonnel[tp2]? as EnterprisePerson).healthStatus = resetHealth
        XCTAssertEqual((enterprisePersonnel[tp1]? as EnterprisePerson).healthStatus, resetHealth, "resetting (healthStatus 1) incorrect")
        XCTAssertEqual((enterprisePersonnel[tp2]? as EnterprisePerson).healthStatus, resetHealth, "resetting (healthStatus 2) incorrect")

        // Test alias access
        (enterprisePersonnel[tp1]? as EnterprisePerson).BL = tp1name
        XCTAssertEqual((enterprisePersonnel[tp1]? as EnterprisePerson).BL, tp1name, "direct setting (name 1) incorrect")
        XCTAssertEqual((enterprisePersonnel[tp2]? as EnterprisePerson).BL, resetName, "direct setting (name 2) incorrect")
        (enterprisePersonnel[tp2]? as EnterprisePerson).name = tp2name
        XCTAssertEqual((enterprisePersonnel[tp1]? as EnterprisePerson).BL, tp1name, "direct setting (name 1) incorrect")
        XCTAssertEqual((enterprisePersonnel[tp2]? as EnterprisePerson).BL, tp2name, "direct setting (name 2) incorrect")
        (enterprisePersonnel[tp1]? as EnterprisePerson).healthStatus = tp1health
        (enterprisePersonnel[tp2]? as EnterprisePerson).healthStatus = tp2health
        XCTAssertEqual((enterprisePersonnel[tp1]? as EnterprisePerson).BU, tp1health, "direct setting (healthStatus 1) incorrect")
        XCTAssertEqual((enterprisePersonnel[tp2]? as EnterprisePerson).BU, tp2health, "direct setting (healthStatus 2) incorrect")

        // Check SystemArray access
        XCTAssertEqual(BL[tp1] as String, tp1name, "BL[tp1] incorrect")
        XCTAssertEqual(BL[tp2] as String, tp2name, "BL[tp2] incorrect")
        XCTAssertEqual(BU[tp1] as Int, tp1health, "BU[tp1] incorrect")
        XCTAssertEqual(BU[tp2] as Int, tp2health, "BU[tp2] incorrect")

    }

    /// Deeper tests (2 level) of system array as in PhotonTorpedoTubes
    func testSystemArray2() {
        // Initialize the Photon Tubes
        let numPhotonTubes = 6
        let photonTubes = SSMakeSystemArray(count: numPhotonTubes, withType: PhotonTube.self)
        let numTorps = (photonTubes[0] as PhotonTube).B2
        XCTAssertEqual(photonTubes.count, numPhotonTubes, "Missing Photon Tubes")
        XCTAssertEqual(numTorps, 20, "Not enough Photon Torpedos, Captain!")
        for p in 0..<numPhotonTubes {
            let tube = photonTubes[p] as PhotonTube
            for t in 0..<numTorps {
                tube.B3[t] = 80 + p
                println("Setting tube \(p) torpedo \(t) to \(80 + p)")
                XCTAssertEqual(tube.B3[t] as Int, 80 + p, "Didn't set")
            }
        }
        for p in 0..<numPhotonTubes {
            let tube = photonTubes[p] as PhotonTube
            for t in 0..<numTorps {
                XCTAssertEqual(tube.B3[t] as Int, 80 + p, "Didn't verify")
            }
        }
        let BY = SystemArrayAccess(source: photonTubes, member: "tubeStatus.functionalStatus")
        let BZ = SystemArrayAccess(source: photonTubes, member: "tubeStatus.operationalStatus")
        let B1 = SystemArrayAccess(source: photonTubes, member: "tubeStatus.reliabilityFactor")
        let B2 = SystemArrayAccess(source: photonTubes, member: "torpedos.count")
        let B3 = SystemArrayAccess(source: photonTubes, members: ["torpedos", "location.num"])
        let B4 = SystemArrayAccess(source: photonTubes, members: ["torpedos", "destination.num"])

        let testTube = ssRandom(numPhotonTubes)    // Pick a test tube
        var t: Int
        var n = 0
        do  {
            if n++ > 20 {abort()}           // Don't get hung up too long
            t = ssRandom(numPhotonTubes)    // And another
        } while t == testTube
        let testTube2 = t   //  Assure we don't pick two the same
        let testTubes = [testTube, testTube2]
        let testFS = 67
        println("Checking tubes: \(testTubes)")
        for n in testTubes {
            (photonTubes[n] as PhotonTube).BY = testFS
            XCTAssertEqual((photonTubes[n] as PhotonTube).BY as Int, testFS, "functionalStatus access incorrect for photonTube#\(n)")
            XCTAssertEqual((photonTubes[n] as PhotonTube).B2 as Int, numTorps, "number of torpedos incorrect for photonTube#\(n)")
            XCTAssertEqual(BY[n] as Int, testFS, "functionalStatus access incorrect for photonTube#\(n)")
            XCTAssertEqual(B2[n] as Int, numTorps, "number of torpedos incorrect for photonTube#\(n)")
            XCTAssertEqual((photonTubes[n] as PhotonTube).B3[0] as Int, LocationCode.PhotonTorpedoTubeStation.rawValue + n, "location incorrect for photonTube#\(n), torpedo#0")
            var locNum: AnyObject? = B3[n, 0]   // Check first torpedo
            println("Found \(locNum)")
            let locI = locNum as Int
            XCTAssertEqual(locI, LocationCode.PhotonTorpedoTubeStation.rawValue + n, "Captain! The torpedo is missing!")
        }
    }
}
