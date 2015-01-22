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
            let pick1 = random() % min(10, cd.BK)   // In the first ten if there are more than ten
            switch action {
            case "Update":
                if cd.BK > 0 {
                    let funcStat = random() % 98    //  Less than 100%
                    logger.info("Setting \(cd.BLid[pick1]!).BT=\(funcStat)")
                    cd.BT[pick1] = funcStat
                }
            case "Remove":
                break
            case "Insert":
                break
            case "Replace":
                break
            default:
                logger.error("Unknown Data Test request: \(action)")
            }
        }
        else {
            logger.severe("Error locating CommonData instance in masterData")
        }
    }
}