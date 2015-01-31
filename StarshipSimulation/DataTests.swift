//
//  DataTests.swift
//  StarshipSimulation
//
//  Created by William Waggoner on 1/22/15.
//  Copyright (c) 2015 William C Waggoner. All rights reserved.
//

import Cocoa

class DataTests: NSObject {

    /// Data tests for Enterprise Person
    func dataTestsEP(#action: String) {
        logger.debug("Entry: \(action)")
        if let cd = masterData?.cd {
            let pick1 = ssRandom(min(20, cd.BK))   // In the first twenty if there are more than twenty
            switch action {
            case "Update":
                if cd.BK > 0 {
                    let funcStat = ssRandom(98)    //  Less than 100%
                    logger.info("Setting \(cd.BLid[pick1]!).BT=\(funcStat)")
                    cd.BT[pick1] = funcStat
                }
            case "Remove":
                logger.debug("Removing \(cd.BLid[pick1]) at \(pick1)")
                cd.removeObjectFromEnterprisePersonnelAtIndex(pick1)
            case "Insert":
                let newOne = EnterprisePerson()
                logger.debug("Inserting \(newOne.BLid) at \(pick1)")
                cd.insertObject(newOne, inEnterprisePersonnelAtIndex: pick1)
            case "Replace":
                let newOne = EnterprisePerson()
                logger.debug("Replacing \(cd.BLid[pick1]) with \(newOne.BLid) at \(pick1)")
                cd.replaceObjectInEnterprisePersonnelAtIndex(pick1, withObject: newOne)
            default:
                logger.error("Unknown Data Test request: \(action)")
            }
        }
        else {
            logger.severe("Error locating CommonData instance in masterData")
        }
    }
}